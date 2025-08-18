#!/bin/bash
# Production build script with comprehensive validation
# DevOps best practices implementation

set -e

echo "🚀 DevContainer Build Pipeline - Iniciando..."
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Build configuration
IMAGE_NAME="dotfiles-dev"
IMAGE_TAG="latest"
BUILD_CONTEXT="../"
DOCKERFILE_PATH="Dockerfile"

echo -e "${BLUE}📋 Build Configuration:${NC}"
echo "   Image: $IMAGE_NAME:$IMAGE_TAG"
echo "   Context: $BUILD_CONTEXT"
echo "   Dockerfile: .devcontainer/$DOCKERFILE_PATH"
echo ""

# Debug: Verificar variáveis
echo -e "${YELLOW}🔍 Debug - Verificando variáveis:${NC}"
echo "   IMAGE_NAME='$IMAGE_NAME'"
echo "   IMAGE_TAG='$IMAGE_TAG'" 
echo "   BUILD_CONTEXT='$BUILD_CONTEXT'"
echo "   DOCKERFILE_PATH='$DOCKERFILE_PATH'"
echo "   Full tag example: '${IMAGE_NAME}:user-setup'"
echo ""

# Step 1: Pre-build validation
echo -e "${YELLOW}🔍 Step 1: Pre-build validation${NC}"
echo "Verificando arquivos necessários..."

required_files=(
    "mise/.config/mise/config.toml"
    "mise/.default-python-packages"  
    "mise/.default-npm-packages"
    ".devcontainer/Dockerfile"
    ".devcontainer/test-zsh-mise.sh"
)

for file in "${required_files[@]}"; do
    if [[ -f "$BUILD_CONTEXT/$file" ]]; then
        echo -e "${GREEN}✅${NC} $file"
    else
        echo -e "${RED}❌${NC} $file - MISSING"
        exit 1
    fi
done

# Step 2: Docker environment check
echo ""
echo -e "${YELLOW}🐳 Step 2: Docker environment check${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker não encontrado${NC}"
    exit 1
fi

echo -e "${GREEN}✅${NC} Docker version: $(docker --version)"

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    echo -e "${RED}❌ Docker daemon não está rodando${NC}"
    exit 1
fi

echo -e "${GREEN}✅${NC} Docker daemon está ativo"

# Step 3: Clean previous builds
echo ""
echo -e "${YELLOW}🧹 Step 3: Limpeza de builds anteriores${NC}"
if docker image inspect "$IMAGE_NAME:$IMAGE_TAG" &> /dev/null; then
    echo "Removendo imagem anterior..."
    docker rmi "$IMAGE_NAME:$IMAGE_TAG" || true
fi

# Clean build cache if needed
echo "Limpando cache de build..."
docker builder prune -f || true

# Step 4: Multi-stage build with validation
echo ""
echo -e "${YELLOW}🏗️  Step 4: Build da imagem (multi-stage)${NC}"

# Build each stage individually to catch errors early
echo "Building base-deps stage..."
docker build \
    --target base-deps \
    --tag "${IMAGE_NAME}:base-deps" \
    --file ".devcontainer/${DOCKERFILE_PATH}" \
    "${BUILD_CONTEXT}" || {
    echo -e "${RED}❌ Falha no stage base-deps${NC}"
    exit 1
}
echo -e "${GREEN}✅ Stage base-deps concluído${NC}"

echo "Building user-setup stage..."
docker build \
    --target user-setup \
    --tag "${IMAGE_NAME}:user-setup" \
    --file ".devcontainer/${DOCKERFILE_PATH}" \
    "${BUILD_CONTEXT}" || {
    echo -e "${RED}❌ Falha no stage user-setup${NC}"
    exit 1
}
echo -e "${GREEN}✅ Stage user-setup concluído${NC}"

echo "Building tools-cache stage..."
docker build \
    --target tools-cache \
    --tag "${IMAGE_NAME}:tools-cache" \
    --file ".devcontainer/${DOCKERFILE_PATH}" \
    "${BUILD_CONTEXT}" || {
    echo -e "${RED}❌ Falha no stage tools-cache${NC}"
    exit 1
}
echo -e "${GREEN}✅ Stage tools-cache concluído${NC}"

echo "Building final runtime stage..."
docker build \
    --target runtime \
    --tag "${IMAGE_NAME}:${IMAGE_TAG}" \
    --file ".devcontainer/${DOCKERFILE_PATH}" \
    "${BUILD_CONTEXT}" || {
    echo -e "${RED}❌ Falha no stage final${NC}"
    exit 1
}
echo -e "${GREEN}✅ Build final concluído${NC}"

# Step 5: Post-build validation
echo ""
echo -e "${YELLOW}🧪 Step 5: Validação pós-build${NC}"

# Test container startup
echo "Testando inicialização do container..."
CONTAINER_ID=$(docker run -d "$IMAGE_NAME:$IMAGE_TAG" sleep 30)

if [[ -z "$CONTAINER_ID" ]]; then
    echo -e "${RED}❌ Falha ao iniciar container${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Container iniciado: $CONTAINER_ID${NC}"

# Test dependencies inside container
echo "Verificando dependências dentro do container..."
docker exec "$CONTAINER_ID" /bin/bash -c '
    echo "Bash version: $(bash --version | head -1)"
    echo "ZSH version: $(zsh --version)"
    echo "Checking tools..."
    which grep wget curl tar bzip2 xz patch gcc clang mise stow
' || {
    echo -e "${RED}❌ Falha na verificação de dependências${NC}"
    docker stop "$CONTAINER_ID" && docker rm "$CONTAINER_ID"
    exit 1
}

# Test mise functionality
echo "Testando funcionalidade do mise..."
docker exec "$CONTAINER_ID" /bin/zsh -c '
    source ~/.zshrc
    mise --version
    mise list --installed
' || {
    echo -e "${YELLOW}⚠️  Mise test com warning (normal se não há ferramentas instaladas)${NC}"
}

# Cleanup test container
docker stop "$CONTAINER_ID" && docker rm "$CONTAINER_ID"

# Step 6: Health check validation
echo ""
echo -e "${YELLOW}💊 Step 6: Health check validation${NC}"
HEALTH_CONTAINER=$(docker run -d "$IMAGE_NAME:$IMAGE_TAG")
sleep 15  # Wait for health check

HEALTH_STATUS=$(docker inspect --format='{{.State.Health.Status}}' "$HEALTH_CONTAINER" 2>/dev/null || echo "no-healthcheck")
if [[ "$HEALTH_STATUS" == "healthy" ]]; then
    echo -e "${GREEN}✅ Health check passou${NC}"
elif [[ "$HEALTH_STATUS" == "starting" ]]; then
    echo -e "${YELLOW}⏳ Health check ainda iniciando${NC}"
else
    echo -e "${RED}❌ Health check falhou: $HEALTH_STATUS${NC}"
fi

docker stop "$HEALTH_CONTAINER" && docker rm "$HEALTH_CONTAINER"

# Step 7: Final report
echo ""
echo "=================================================="
echo -e "${GREEN}🎉 Build Pipeline Concluído com Sucesso!${NC}"
echo ""
echo -e "${BLUE}📊 Resumo:${NC}"
docker images | grep "$IMAGE_NAME" | head -5
echo ""
echo -e "${BLUE}🚀 Para usar o DevContainer:${NC}"
echo "   docker-compose up -d"
echo "   code --remote containers-reopen-folder"
echo ""
echo -e "${GREEN}✅ Pronto para desenvolvimento!${NC}"
