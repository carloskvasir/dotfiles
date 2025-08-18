#!/bin/bash
# ====================================================================
# DevContainer Build Pipeline Avançado - DevOps Best Practices
# Implementa técnicas avançadas de CI/CD, caching e paralelização
# ====================================================================

set -euo pipefail

# ====================================================================
# CONFIGURAÇÃO E VARIÁVEIS
# ====================================================================

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Build Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
readonly IMAGE_NAME="dotfiles-dev"
readonly REGISTRY="${REGISTRY:-ghcr.io/carloskvasir/dotfiles}"
readonly BUILD_TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
readonly GIT_SHA="${GITHUB_SHA:-$(git rev-parse --short HEAD 2>/dev/null || echo 'local')}"

# Advanced Build Options
readonly ENABLE_CACHE="${ENABLE_CACHE:-true}"
readonly ENABLE_PARALLEL="${ENABLE_PARALLEL:-true}"
readonly ENABLE_REGISTRY_CACHE="${ENABLE_REGISTRY_CACHE:-true}"
readonly BUILD_PLATFORMS="${BUILD_PLATFORMS:-linux/amd64}"
readonly MAX_PARALLEL_BUILDS="${MAX_PARALLEL_BUILDS:-4}"

# Detectar contexto de build
if [[ "$(basename "$PWD")" == ".devcontainer" ]]; then
    readonly BUILD_CONTEXT="../"
    readonly DOCKERFILE_PATH="Dockerfile.optimized"
else
    readonly BUILD_CONTEXT="."
    readonly DOCKERFILE_PATH=".devcontainer/Dockerfile.optimized"
fi

# ====================================================================
# FUNÇÕES UTILITÁRIAS
# ====================================================================

log() {
    local level="$1"
    shift
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case "$level" in
        "INFO")  echo -e "${CYAN}[INFO]${NC}  [$timestamp] $*" ;;
        "WARN")  echo -e "${YELLOW}[WARN]${NC}  [$timestamp] $*" ;;
        "ERROR") echo -e "${RED}[ERROR]${NC} [$timestamp] $*" ;;
        "SUCCESS") echo -e "${GREEN}[SUCCESS]${NC} [$timestamp] $*" ;;
        "DEBUG") [[ "${DEBUG:-}" == "true" ]] && echo -e "${PURPLE}[DEBUG]${NC} [$timestamp] $*" ;;
    esac
}

check_requirements() {
    log "INFO" "🔍 Verificando requisitos do sistema..."
    
    local requirements=(
        "docker:Docker"
    )
    
    for req in "${requirements[@]}"; do
        local cmd="${req%%:*}"
        local name="${req##*:}"
        
        if command -v "$cmd" &> /dev/null; then
            log "SUCCESS" "✅ $name encontrado"
        else
            log "ERROR" "❌ $name não encontrado"
            return 1
        fi
    done
    
    # Verificar BuildKit
    if docker buildx ls | grep -q "devcontainer-builder"; then
        log "SUCCESS" "✅ Docker Buildx 'devcontainer-builder' já existe, usando-o"
        docker buildx use devcontainer-builder
    else
        log "WARN" "⚠️  Docker Buildx não configurado, criando builder 'devcontainer-builder'..."
        docker buildx create --name devcontainer-builder --use
    fi
}

validate_files() {
    log "INFO" "📋 Validando arquivos necessários..."
    
    local required_files=(
        "$DOCKERFILE_PATH"
        "mise/.config/mise/config.toml"
        "mise/.default-python-packages"
        "mise/.default-npm-packages"
    )
    
    for file in "${required_files[@]}"; do
        local full_path
        if [[ "$file" == "$DOCKERFILE_PATH" ]]; then
            full_path="$file"
        else
            full_path="$BUILD_CONTEXT/$file"
        fi
        
        if [[ -f "$full_path" ]]; then
            log "SUCCESS" "✅ $file"
        else
            log "ERROR" "❌ $file - AUSENTE"
            return 1
        fi
    done
}

cleanup_old_images() {
    log "INFO" "🧹 Limpando imagens antigas..."
    
    # Remove imagens não utilizadas
    docker image prune -f --filter "label=stage" 2>/dev/null || true
    
    # Remove imagens antigas do projeto
    docker images --filter "reference=${IMAGE_NAME}*" --format "{{.ID}} {{.CreatedAt}}" | \
    sort -k2 -r | tail -n +6 | awk '{print $1}' | \
    xargs -r docker rmi 2>/dev/null || true
    
    log "SUCCESS" "✅ Limpeza concluída"
}

# ====================================================================
# PIPELINE DE BUILD AVANÇADO
# ====================================================================

setup_cache_mounts() {
    log "INFO" "🗄️  Configurando cache mounts avançados..."
    
    local cache_dirs=(
        "/var/cache/apt"
        "/var/lib/apt" 
        "/tmp/mise-cache"
        "/tmp/npm-cache"
        "/tmp/pip-cache"
    )
    
    for dir in "${cache_dirs[@]}"; do
        docker volume create "devcontainer-cache-${dir##*/}" 2>/dev/null || true
    done
    
    log "SUCCESS" "✅ Cache mounts configurados"
}

build_stage_parallel() {
    local stage="$1"
    local tag_suffix="$2"
    local dependencies="$3"
    
    log "INFO" "🏗️  Building stage: $stage"
    
    local cache_args=""
    if [[ "$ENABLE_CACHE" == "true" ]]; then
        cache_args="--cache-from type=local,src=/tmp/.buildx-cache-$stage"
        cache_args="$cache_args --cache-to type=local,dest=/tmp/.buildx-cache-$stage,mode=max"
        
        if [[ "$ENABLE_REGISTRY_CACHE" == "true" ]]; then
            cache_args="$cache_args --cache-from type=registry,ref=${REGISTRY}/cache:$stage"
            cache_args="$cache_args --cache-to type=registry,ref=${REGISTRY}/cache:$stage,mode=max"
        fi
    fi
    
    local build_args=(
        "--file" "$DOCKERFILE_PATH"
        "--target" "$stage"
        "--tag" "${IMAGE_NAME}:${stage}-${tag_suffix}"
        "--platform" "$BUILD_PLATFORMS"
        "--progress" "plain"
        "--build-arg" "BUILDKIT_INLINE_CACHE=1"
    )
    
    if [[ -n "$cache_args" ]]; then
        build_args+=($cache_args)
    fi
    
    # Add dependency cache references
    if [[ -n "$dependencies" ]]; then
        IFS=',' read -ra deps <<< "$dependencies"
        for dep in "${deps[@]}"; do
            build_args+=("--cache-from" "type=local,src=/tmp/.buildx-cache-$dep")
        done
    fi
    
    build_args+=("$BUILD_CONTEXT")
    
    docker buildx build "${build_args[@]}" || {
        log "ERROR" "❌ Falha no build do stage: $stage"
        return 1
    }
    
    log "SUCCESS" "✅ Stage $stage concluído"
}

build_pipeline() {
    log "INFO" "🚀 Iniciando pipeline de build avançado..."
    
    # Criar diretórios de cache
    mkdir -p /tmp/.buildx-cache-{base-deps,user-setup,mise-base,tools-nodejs,tools-python,tools-dev,tools-merged,config-layer,runtime}
    # Use a user-specific cache directory to avoid security risks
    readonly USER_CACHE_DIR="${HOME}/.cache/buildx"
    mkdir -p "${USER_CACHE_DIR}/"{base-deps,user-setup,mise-base,tools-nodejs,tools-python,tools-dev,tools-merged,config-layer,runtime}
    if [[ "$ENABLE_PARALLEL" == "true" ]]; then
        log "INFO" "⚡ Usando build paralelo"
        
        # Estágio 1: Base Dependencies
        build_stage_parallel "base-deps" "$BUILD_TIMESTAMP" "" &
        local pid_base=$!
        
        wait $pid_base || {
            log "ERROR" "❌ Falha no build base-deps"
            return 1
        }
        
        # Estágio 2: User Setup (depende de base-deps)
        build_stage_parallel "user-setup" "$BUILD_TIMESTAMP" "base-deps" &
        local pid_user=$!
        
        wait $pid_user || {
            log "ERROR" "❌ Falha no build user-setup"
            return 1
        }
        
        # Estágio 3: Mise Base (depende de user-setup)
        build_stage_parallel "mise-base" "$BUILD_TIMESTAMP" "user-setup" &
        local pid_mise=$!
        
        wait $pid_mise || {
            log "ERROR" "❌ Falha no build mise-base"
            return 1
        }
        
        # Estágio 4: Tools paralelos (dependem de mise-base)
        log "INFO" "🔧 Construindo tools em paralelo..."
        build_stage_parallel "tools-nodejs" "$BUILD_TIMESTAMP" "mise-base" &
        local pid_node=$!
        
        build_stage_parallel "tools-python" "$BUILD_TIMESTAMP" "mise-base" &
        local pid_python=$!
        
        build_stage_parallel "tools-dev" "$BUILD_TIMESTAMP" "mise-base" &
        local pid_dev=$!
        
        # Aguardar todos os tools
        wait $pid_node $pid_python $pid_dev || {
            log "ERROR" "❌ Falha no build dos tools"
            return 1
        }
        
        # Estágio 5: Merge Tools
        build_stage_parallel "tools-merged" "$BUILD_TIMESTAMP" "tools-nodejs,tools-python,tools-dev" &
        local pid_merged=$!
        
        wait $pid_merged || {
            log "ERROR" "❌ Falha no build tools-merged"
            return 1
        }
        
        # Estágio 6: Config Layer
        build_stage_parallel "config-layer" "$BUILD_TIMESTAMP" "tools-merged" &
        local pid_config=$!
        
        wait $pid_config || {
            log "ERROR" "❌ Falha no build config-layer"
            return 1
        }
        
        # Estágio 7: Runtime Final
        build_stage_parallel "runtime" "$BUILD_TIMESTAMP" "config-layer" &
        local pid_runtime=$!
        
        wait $pid_runtime || {
            log "ERROR" "❌ Falha no build runtime"
            return 1
        }
        
    else
        log "INFO" "🐌 Usando build sequencial"
        
        local stages=("base-deps" "user-setup" "mise-base" "tools-nodejs" "tools-python" "tools-dev" "tools-merged" "config-layer" "runtime")
        
        for stage in "${stages[@]}"; do
            build_stage_parallel "$stage" "$BUILD_TIMESTAMP" ""
        done
    fi
    
    # Tag final
    docker tag "${IMAGE_NAME}:runtime-${BUILD_TIMESTAMP}" "${IMAGE_NAME}:latest"
    docker tag "${IMAGE_NAME}:runtime-${BUILD_TIMESTAMP}" "${IMAGE_NAME}:${GIT_SHA}"
    
    log "SUCCESS" "🎉 Pipeline de build concluído!"
}

# ====================================================================
# TESTES E VALIDAÇÃO
# ====================================================================

run_comprehensive_tests() {
    log "INFO" "🧪 Executando testes abrangentes..."
    
    # Test 1: Container Startup
    log "INFO" "Test 1/5: Container startup..."
    local container_id
    container_id=$(docker run -d "${IMAGE_NAME}:latest" sleep 60) || {
        log "ERROR" "❌ Falha ao iniciar container"
        return 1
    }
    
    sleep 5
    
    # Test 2: Basic Shell
    log "INFO" "Test 2/5: Basic shell functionality..."
    docker exec "$container_id" /bin/zsh -c 'echo "ZSH working"' || {
        log "ERROR" "❌ ZSH não funciona"
        docker stop "$container_id" && docker rm "$container_id"
        return 1
    }
    
    # Test 3: Mise Integration
    log "INFO" "Test 3/5: Mise integration..."
    docker exec "$container_id" /bin/zsh -c 'source ~/.zshrc && mise --version' || {
        log "ERROR" "❌ Mise não funciona"
        docker stop "$container_id" && docker rm "$container_id"
        return 1
    }
    
    # Test 4: Tools Availability
    log "INFO" "Test 4/5: Tools availability..."
    docker exec "$container_id" /bin/zsh -c '
        source ~/.zshrc
        echo "Testing Node.js..." && node --version
        echo "Testing Python..." && python --version
        echo "Testing Neovim..." && nvim --version | head -1
    ' || {
        log "WARN" "⚠️  Alguns tools podem não estar disponíveis"
    }
    
    # Test 5: Performance Test
    log "INFO" "Test 5/5: Performance test..."
    local start_time=$(date +%s)
    docker exec "$container_id" /bin/zsh -c 'source ~/.zshrc && mise list --installed' >/dev/null
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    if [[ $duration -lt 5 ]]; then
        log "SUCCESS" "✅ Performance test passed (${duration}s)"
    else
        log "WARN" "⚠️  Performance test slow (${duration}s)"
    fi
    
    # Cleanup
    docker stop "$container_id" && docker rm "$container_id"
    
    log "SUCCESS" "✅ Todos os testes concluídos"
}

generate_build_report() {
    log "INFO" "📊 Gerando relatório de build..."
    
    local report_file="/tmp/devcontainer-build-report-${BUILD_TIMESTAMP}.md"
    
    cat > "$report_file" << EOF
# DevContainer Build Report

**Build Timestamp:** $BUILD_TIMESTAMP  
**Git SHA:** $GIT_SHA  
**Build Context:** $BUILD_CONTEXT  
**Dockerfile:** $DOCKERFILE_PATH  

## Images Created

\`\`\`
$(docker images --filter "reference=${IMAGE_NAME}*" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}")
\`\`\`

## Cache Usage

\`\`\`
$(docker system df)
\`\`\`

## Build Configuration

- **Cache Enabled:** $ENABLE_CACHE
- **Parallel Build:** $ENABLE_PARALLEL  
- **Registry Cache:** $ENABLE_REGISTRY_CACHE
- **Platforms:** $BUILD_PLATFORMS
- **Max Parallel:** $MAX_PARALLEL_BUILDS

## Next Steps

Para usar o DevContainer:

\`\`\`bash
# Via Docker Compose
docker-compose -f docker-compose.optimized.yml up -d

# Via VS Code
code --remote containers-reopen-folder
\`\`\`

EOF
    
    log "SUCCESS" "📋 Relatório salvo em: $report_file"
    cat "$report_file"
}

# ====================================================================
# MAIN EXECUTION
# ====================================================================

main() {
    log "INFO" "🚀 DevContainer Build Pipeline Avançado - Iniciando..."
    log "INFO" "Build ID: $BUILD_TIMESTAMP | Git SHA: $GIT_SHA"
    
    # Verificações preliminares
    check_requirements
    validate_files
    
    # Setup
    setup_cache_mounts
    cleanup_old_images
    
    # Build principal
    build_pipeline
    
    # Testes
    run_comprehensive_tests
    
    # Relatório
    generate_build_report
    
    log "SUCCESS" "🎉 DevContainer Build Pipeline concluído com sucesso!"
    log "INFO" "🚀 Pronto para desenvolvimento com técnicas DevOps avançadas!"
}

# Trap para cleanup em caso de erro
trap 'log "ERROR" "❌ Build interrompido"; exit 1' ERR

# Executar pipeline se script for chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
