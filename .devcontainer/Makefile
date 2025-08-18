# ====================================================================
# DevContainer Makefile - Automação DevOps Avançada
# ====================================================================

.PHONY: help build build-advanced test clean cache-clean deploy dev-up dev-down logs shell benchmark security-scan

# Configurações
DOCKER_COMPOSE_FILE := .devcontainer/docker-compose.optimized.yml
ADVANCED_COMPOSE_FILE := .devcontainer/docker-compose.optimized.yml
IMAGE_NAME := dotfiles-dev
REGISTRY := ghcr.io/carloskvasir/dotfiles
BUILD_TIMESTAMP := $(shell date +%Y%m%d_%H%M%S)
GIT_SHA := $(shell git rev-parse --short HEAD 2>/dev/null || echo 'local')

# Colors para output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# ====================================================================
# TARGETS PRINCIPAIS
# ====================================================================

help: ## 📋 Mostra esta mensagem de ajuda
	@echo "$(BLUE)DevContainer Makefile - Automação DevOps Avançada$(NC)"
	@echo "=================================================="
	@echo ""
	@echo "$(GREEN)Targets Disponíveis:$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(BLUE)Exemplos de Uso:$(NC)"
	@echo "  make build-advanced    # Build com técnicas avançadas"
	@echo "  make dev-up           # Sobe ambiente de desenvolvimento"
	@echo "  make test             # Executa testes completos"
	@echo "  make benchmark        # Roda benchmark de performance"
	@echo ""

build: ## 🏗️  Build padrão do DevContainer
	@echo "$(YELLOW)🏗️  Executando build padrão...$(NC)"
	@cd .devcontainer && ./build-production.sh

build-advanced: ## 🚀 Build com técnicas DevOps avançadas
	@echo "$(YELLOW)🚀 Executando build avançado...$(NC)"
	@chmod +x .devcontainer/build-advanced.sh
	@.devcontainer/build-advanced.sh

build-parallel: ## ⚡ Build paralelo para máxima performance
	@echo "$(YELLOW)⚡ Executando build paralelo...$(NC)"
	@ENABLE_PARALLEL=true ENABLE_CACHE=true .devcontainer/build-advanced.sh

build-minimal: ## 🎯 Build mínimo para testes rápidos
	@echo "$(YELLOW)🎯 Executando build mínimo...$(NC)"
	@docker build -f .devcontainer/Dockerfile.optimized --target runtime -t $(IMAGE_NAME):minimal .

# ====================================================================
# AMBIENTE DE DESENVOLVIMENTO
# ====================================================================

dev-up: ## 🚀 Sobe ambiente de desenvolvimento
	@echo "$(GREEN)🚀 Subindo ambiente de desenvolvimento...$(NC)"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) up -d
	@echo "$(GREEN)✅ Ambiente pronto! Acesse via VS Code Remote Containers$(NC)"

dev-down: ## 🛑 Para ambiente de desenvolvimento
	@echo "$(YELLOW)🛑 Parando ambiente de desenvolvimento...$(NC)"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) down

dev-restart: ## 🔄 Reinicia ambiente de desenvolvimento
	@echo "$(YELLOW)🔄 Reiniciando ambiente...$(NC)"
	@make dev-down
	@make dev-up

dev-rebuild: ## 🏗️  Reconstroi e reinicia ambiente
	@echo "$(YELLOW)🏗️  Reconstruindo ambiente...$(NC)"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) down
	@docker-compose -f $(DOCKER_COMPOSE_FILE) build --no-cache
	@docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

# ====================================================================
# TESTES E VALIDAÇÃO
# ====================================================================

test: ## 🧪 Executa testes completos
	@echo "$(YELLOW)🧪 Executando testes completos...$(NC)"
	@chmod +x .devcontainer/test-zsh-mise.sh
	@docker run --rm $(IMAGE_NAME):latest /home/vscode/test-zsh-mise.sh

test-integration: ## 🔗 Testes de integração
	@echo "$(YELLOW)🔗 Executando testes de integração...$(NC)"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) up -d
	@sleep 10
	@docker-compose -f $(DOCKER_COMPOSE_FILE) exec -T devcontainer /bin/zsh -c "source ~/.zshrc && mise --version"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) exec -T devcontainer /bin/zsh -c "source ~/.zshrc && node --version || echo 'Node not available'"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) exec -T devcontainer /bin/zsh -c "source ~/.zshrc && python --version || echo 'Python not available'"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) down

test-performance: ## ⚡ Testes de performance
	@echo "$(YELLOW)⚡ Executando testes de performance...$(NC)"
	@time docker run --rm $(IMAGE_NAME):latest /bin/zsh -c "source ~/.zshrc && mise list --installed"

validate: ## ✅ Valida configurações
	@echo "$(YELLOW)✅ Validando configurações...$(NC)"
	@echo "Verificando arquivos obrigatórios..."
	@test -f Dockerfile.optimized || (echo "$(RED)❌ Dockerfile.optimized não encontrado$(NC)" && exit 1)
	@test -f docker-compose.optimized.yml || (echo "$(RED)❌ docker-compose.optimized.yml não encontrado$(NC)" && exit 1)
	@test -f ../mise/.config/mise/config.toml || (echo "$(RED)❌ config.toml não encontrado$(NC)" && exit 1)
	@echo "$(GREEN)✅ Todos os arquivos encontrados$(NC)"

# ====================================================================
# BENCHMARK E PERFORMANCE
# ====================================================================

benchmark: ## 📊 Roda benchmark completo
	@echo "$(YELLOW)📊 Executando benchmark completo...$(NC)"
	@echo "=== Container Startup Time ==="
	@time docker run --rm $(IMAGE_NAME):latest echo "Container started"
	@echo ""
	@echo "=== Mise Activation Time ==="
	@time docker run --rm $(IMAGE_NAME):latest /bin/zsh -c "source ~/.zshrc && mise --version"
	@echo ""
	@echo "=== Tool Availability Test ==="
	@docker run --rm $(IMAGE_NAME):latest /bin/zsh -c "source ~/.zshrc && echo 'Node:' && node --version 2>/dev/null || echo 'Not available'"
	@docker run --rm $(IMAGE_NAME):latest /bin/zsh -c "source ~/.zshrc && echo 'Python:' && python --version 2>/dev/null || echo 'Not available'"
	@docker run --rm $(IMAGE_NAME):latest /bin/zsh -c "source ~/.zshrc && echo 'Neovim:' && nvim --version 2>/dev/null | head -1 || echo 'Not available'"

memory-usage: ## 💾 Analisa uso de memória
	@echo "$(YELLOW)💾 Analisando uso de memória...$(NC)"
	@docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}" $(shell docker ps -q --filter ancestor=$(IMAGE_NAME):latest) 2>/dev/null || echo "Nenhum container rodando"

image-size: ## 📏 Mostra tamanhos das imagens
	@echo "$(YELLOW)📏 Tamanhos das imagens:$(NC)"
	@docker images --filter reference=$(IMAGE_NAME) --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"

# ====================================================================
# LIMPEZA E MANUTENÇÃO  
# ====================================================================

clean: ## 🧹 Limpeza básica
	@echo "$(YELLOW)🧹 Executando limpeza básica...$(NC)"
	@docker system prune -f
	@docker volume prune -f

cache-clean: ## 🗑️  Limpeza completa de cache
	@echo "$(YELLOW)🗑️  Executando limpeza completa...$(NC)"
	@docker builder prune -f
	@docker image prune -a -f
	@docker volume prune -f
	@docker network prune -f

deep-clean: ## 💣 Limpeza profunda (CUIDADO!)
	@echo "$(RED)💣 ATENÇÃO: Limpeza profunda remove TUDO!$(NC)"
	@read -p "Tem certeza? [y/N] " -n 1 -r; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		echo ""; \
		echo "$(YELLOW)Removendo tudo...$(NC)"; \
		docker system prune -a -f --volumes; \
		docker builder prune -a -f; \
	else \
		echo ""; \
		echo "$(GREEN)Operação cancelada$(NC)"; \
	fi

# ====================================================================
# UTILITÁRIOS
# ====================================================================

shell: ## 🐚 Acessa shell do container
	@echo "$(YELLOW)🐚 Acessando shell do container...$(NC)"
	@docker run -it --rm -v $(PWD):/workspaces/dotfiles $(IMAGE_NAME):latest /bin/zsh

shell-compose: ## 🐚 Acessa shell via docker-compose
	@echo "$(YELLOW)🐚 Acessando shell via compose...$(NC)"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) exec devcontainer /bin/zsh

logs: ## 📜 Mostra logs do container
	@echo "$(YELLOW)📜 Mostrando logs...$(NC)"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) logs -f

status: ## 📊 Status do ambiente
	@echo "$(YELLOW)📊 Status do ambiente:$(NC)"
	@echo ""
	@echo "=== Containers ==="
	@docker ps --filter ancestor=$(IMAGE_NAME) --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
	@echo ""
	@echo "=== Volumes ==="
	@docker volume ls --filter name=dotfiles --format "table {{.Name}}\t{{.Driver}}"
	@echo ""
	@echo "=== Images ==="
	@docker images --filter reference=$(IMAGE_NAME) --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

# ====================================================================
# SEGURANÇA
# ====================================================================

security-scan: ## 🔒 Executa scan de segurança
	@echo "$(YELLOW)🔒 Executando scan de segurança...$(NC)"
	@if command -v trivy >/dev/null 2>&1; then \
		trivy image $(IMAGE_NAME):latest; \
	else \
		echo "$(RED)❌ Trivy não encontrado. Instale com: sudo apt install trivy$(NC)"; \
	fi

# ====================================================================
# CI/CD e DEPLOY
# ====================================================================

ci-test: ## 🔄 Testes para CI/CD
	@echo "$(YELLOW)🔄 Executando testes CI/CD...$(NC)"
	@make validate
	@make build-advanced
	@make test
	@make test-integration

deploy: ## 🚀 Deploy para registry
	@echo "$(YELLOW)🚀 Fazendo deploy para $(REGISTRY)...$(NC)"
	@docker tag $(IMAGE_NAME):latest $(REGISTRY)/devcontainer:latest
	@docker tag $(IMAGE_NAME):latest $(REGISTRY)/devcontainer:$(GIT_SHA)
	@docker push $(REGISTRY)/devcontainer:latest
	@docker push $(REGISTRY)/devcontainer:$(GIT_SHA)
	@echo "$(GREEN)✅ Deploy concluído!$(NC)"

# ====================================================================
# INFORMAÇÕES
# ====================================================================

info: ## ℹ️  Informações do sistema
	@echo "$(BLUE)ℹ️  Informações do Sistema$(NC)"
	@echo "=========================="
	@echo "Docker version: $(shell docker --version)"
	@echo "Docker Compose version: $(shell docker-compose --version)"
	@echo "BuildKit version: $(shell docker buildx version 2>/dev/null | head -1 || echo 'Not available')"
	@echo "Git SHA: $(GIT_SHA)"
	@echo "Build Timestamp: $(BUILD_TIMESTAMP)"
	@echo "Registry: $(REGISTRY)"
	@echo "Image Name: $(IMAGE_NAME)"
	@echo ""
	@echo "$(BLUE)Recursos Disponíveis:$(NC)"
	@echo "CPU cores: $(shell nproc)"
	@echo "Memory: $(shell free -h | awk '/^Mem:/ {print $$2}')"
	@echo "Disk space: $(shell df -h . | awk 'NR==2 {print $$4}')"

version: ## 📝 Versão e informações do build
	@echo "$(BLUE)DevContainer Build Information$(NC)"
	@echo "=============================="
	@echo "Version: 3.0-advanced"
	@echo "Build Timestamp: $(BUILD_TIMESTAMP)"
	@echo "Git SHA: $(GIT_SHA)"
	@echo "Image: $(IMAGE_NAME):latest"
	@echo "Registry: $(REGISTRY)"
	@echo ""
	@echo "$(GREEN)Últimas alterações:$(NC)"
	@git log --oneline -5 2>/dev/null || echo "Git não disponível"

# ====================================================================
# DEFAULT TARGET
# ====================================================================

.DEFAULT_GOAL := help
