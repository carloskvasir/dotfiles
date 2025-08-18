# 📚 DevContainer - Guia Completo de Uso

## 🎯 Visão Geral

Este DevContainer foi otimizado com **técnicas DevOps avançadas** e está disponível no GitHub Container Registry. Ele fornece um ambiente de desenvolvimento completo com ZSH, Mise e todas as ferramentas necessárias pré-configuradas.

## 🚀 Opções de Uso

### 1. **Usar Imagem do Registry (Recomendado)**

A imagem está disponível no GitHub Container Registry e pode ser usada diretamente:

```bash
# Pull da imagem otimizada
docker pull ghcr.io/carloskvasir/dotfiles/devcontainer:latest

# Verificar funcionamento
docker run --rm ghcr.io/carloskvasir/dotfiles/devcontainer:latest \
  /bin/zsh -c "echo 'DevContainer funcionando!' && mise --version"
```

### 2. **Build Local com Otimizações**

Para builds locais com todas as otimizações:

```bash
# Clone do repositório
git clone https://github.com/carloskvasir/dotfiles.git
cd dotfiles/.devcontainer

# Build otimizado
make build-advanced

# OU build paralelo para máxima performance
make build-parallel
```

## 🛠️ Métodos de Desenvolvimento

### **Método 1: VS Code Remote Containers (Recomendado)**

#### Configuração Inicial:
```bash
# 1. Clone o repositório
git clone https://github.com/carloskvasir/dotfiles.git
cd dotfiles

# 2. Abrir no VS Code
code .

# 3. VS Code detectará automaticamente o .devcontainer
# 4. Clique em "Reopen in Container" quando solicitado
```

#### Configurações Disponíveis:
- **Padrão**: `.devcontainer/devcontainer.json`
- **Avançada**: `.devcontainer/devcontainer.advanced.json`
- **Codespaces**: `.devcontainer/devcontainer.codespaces.json`

### **Método 2: Docker Compose (Desenvolvimento)**

```bash
# Subir ambiente de desenvolvimento
make dev-up

# Verificar status
make status

# Acessar shell
make shell-compose

# Parar ambiente
make dev-down
```

#### Configurações Docker Compose:
- **Padrão**: `docker-compose.yml`
- **Otimizada**: `docker-compose.optimized.yml`

### **Método 3: Docker Run (Teste Rápido)**

```bash
# Usar imagem do registry
docker run -it --rm \
  -v $(pwd):/workspaces/dotfiles \
  ghcr.io/carloskvasir/dotfiles/devcontainer:latest \
  /bin/zsh

# OU usar imagem local
docker run -it --rm \
  -v $(pwd):/workspaces/dotfiles \
  dotfiles-dev:latest \
  /bin/zsh
```

## 🔧 Comandos de Automação (Makefile)

### **Build e Deploy**
```bash
make build-advanced    # Build com todas as otimizações
make build-parallel    # Build paralelo máxima performance
make build-minimal     # Build mínimo para testes
make deploy            # Deploy para registry
```

### **Desenvolvimento**
```bash
make dev-up           # Sobe ambiente otimizado
make dev-down         # Para ambiente
make dev-restart      # Reinicia ambiente
make dev-rebuild      # Reconstroi e reinicia
```

### **Testes e Validação**
```bash
make test             # Testes completos
make test-integration # Testes de integração
make test-performance # Testes de performance
make validate         # Validação de configurações
make benchmark        # Benchmark completo
```

### **Monitoramento**
```bash
make status           # Status do ambiente
make memory-usage     # Análise de memória
make image-size       # Tamanhos de imagem
make logs            # Logs do container
```

### **Manutenção**
```bash
make clean           # Limpeza básica
make cache-clean     # Limpeza completa de cache
make deep-clean      # Limpeza profunda (CUIDADO!)
```

### **Utilitários**
```bash
make shell           # Acessa shell do container
make shell-compose   # Shell via docker-compose
make security-scan   # Scan de segurança
make info           # Informações do sistema
make help           # Lista todos os comandos
```

## 📊 Performance e Benchmarks

### **Métricas Atuais** (após otimizações):
```
Container Startup: ~8 segundos
Mise Activation: ~8 segundos
Build Time: ~6 minutos (inicial)
Rebuild Time: ~30 segundos (cache)
Image Size: ~2.47 GB
```

### **Executar Benchmark:**
```bash
make benchmark
```

## 🔒 Segurança

### **Security Scan:**
```bash
# Instalar Trivy (se necessário)
sudo apt update && sudo apt install trivy

# Executar scan
make security-scan
```

### **Boas Práticas:**
- Container executa como usuário `vscode` (não-root)
- Health checks automatizados
- Security scanning no CI/CD
- Secrets não são incluídos na imagem

## 🎛️ Configurações Avançadas

### **Variáveis de Ambiente:**
```bash
# Build
export ENABLE_CACHE=true
export ENABLE_PARALLEL=true
export ENABLE_REGISTRY_CACHE=true
export BUILD_PLATFORMS=linux/amd64
export MAX_PARALLEL_BUILDS=4

# Runtime
export MISE_DATA_DIR=/home/vscode/.local/share/mise
export MISE_CONFIG_DIR=/home/vscode/.config/mise
```

### **Volumes Persistentes:**
O DevContainer usa volumes nomeados para persistência:
- `dotfiles-vscode-server-v3`: VS Code Server
- `dotfiles-mise-cache-v3`: Cache do Mise
- `dotfiles-mise-data-v3`: Ferramentas instaladas
- `dotfiles-npm-cache-v3`: Cache NPM
- `dotfiles-pip-cache-v3`: Cache Python

### **Portas Pré-configuradas:**
- `3000`: Next.js dev server
- `8080`: HTTP dev server
- `8000`: Python dev server
- `5000`: Flask dev server
- `4000`: Jekyll/Hugo dev server

## 🚀 CI/CD e GitHub Actions

### **Workflow Avançado:**
O repositório inclui um workflow CI/CD avançado em `.github/workflows/devcontainer-advanced.yml` com:

- **Matrix builds** paralelos
- **Cache inteligente** por stage
- **Security scanning** automatizado
- **Performance benchmarks**
- **Multi-platform** support

### **Disparar Build Manual:**
1. Vá para Actions no GitHub
2. Selecione "Advanced DevContainer CI/CD Pipeline"
3. Clique em "Run workflow"
4. Configure opções:
   - Build strategy: `parallel`
   - Cache strategy: `aggressive`
   - Push to registry: `true`

## 🛠️ Ferramentas Incluídas

### **Linguagens de Programação:**
- **Node.js**: v22.18.0
- **Python**: 3.12.11
- **ZSH**: Shell padrão

### **Editores:**
- **Neovim**: v0.11.3 (pré-configurado)

### **Ferramentas CLI:**
- **Mise**: 2025.8.12 (gerenciador de versões)
- **Git**: Controle de versão
- **Stow**: Gerenciamento de dotfiles

### **VS Code Extensions (Pré-instaladas):**
- Python, TypeScript, ESLint
- GitLens, Docker, Remote Containers
- Material Theme, Better Comments
- E muitas outras...

## 🔄 Troubleshooting

### **Problemas Comuns:**

#### **Container não inicia:**
```bash
# Verificar logs
make logs

# Verificar status
make status

# Rebuild completo
make dev-rebuild
```

#### **Mise não funciona:**
```bash
# Dentro do container
source ~/.zshrc
mise doctor
mise install
```

#### **Performance lenta:**
```bash
# Limpar cache
make cache-clean

# Verificar recursos
make memory-usage

# Benchmark
make benchmark
```

#### **Erro de permissões:**
```bash
# Verificar usuário
docker exec -it <container> whoami

# Deve retornar 'vscode'
```

## 📚 Documentação Adicional

### **Arquivos de Documentação:**
- `DEVOPS_OPTIMIZATIONS.md`: Detalhes das otimizações
- `FINAL_OPTIMIZATION_SUMMARY.md`: Resumo das melhorias
- `PRODUCTION-SUMMARY.md`: Configuração de produção

### **Links Úteis:**
- [DevContainer Specification](https://containers.dev/)
- [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview)
- [Docker BuildKit](https://docs.docker.com/build/buildkit/)
- [Mise Documentation](https://mise.jdx.dev/)

## 💡 Dicas de Produtividade

### **Atalhos Úteis:**
```bash
# Desenvolvimento rápido
make dev-up && code --remote containers-reopen-folder

# Build e teste
make build-advanced && make test

# Monitoramento contínuo
watch make status

# Deploy automatizado
make ci-test && make deploy
```

### **Aliases Recomendados:**
```bash
alias dc='make dev-up'
alias dt='make test'
alias db='make benchmark'
alias ds='make status'
alias dcl='make clean'
```

## 🎉 Conclusão

Este DevContainer oferece:

- ✅ **Setup em 1 comando**
- ✅ **Performance otimizada** (60-95% melhoria)
- ✅ **Segurança enterprise-grade**
- ✅ **Automação completa**
- ✅ **Monitoramento integrado**
- ✅ **CI/CD avançado**

**Próximo passo:** `make dev-up` ou abrir no VS Code Remote Containers!

---

**Registry:** `ghcr.io/carloskvasir/dotfiles/devcontainer:latest`  
**Repositório:** https://github.com/carloskvasir/dotfiles  
**Documentação:** Este arquivo + Makefiles comentados
