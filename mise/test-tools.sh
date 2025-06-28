#!/bin/bash

# 🧪 Script de Teste das Ferramentas Mise
# Verifica se todas as ferramentas estão funcionando corretamente

echo "🧪 Testando instalação das ferramentas mise..."
echo "=" * 50

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

test_command() {
    local cmd="$1"
    local name="$2"
    
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}✅ $name${NC} - $(command -v "$cmd")"
        return 0
    else
        echo -e "${RED}❌ $name${NC} - Não encontrado"
        return 1
    fi
}

test_version() {
    local cmd="$1"
    local name="$2"
    local version_flag="${3:---version}"
    
    if command -v "$cmd" &> /dev/null; then
        local version
        version=$("$cmd" "$version_flag" 2>/dev/null | head -1)
        echo -e "${GREEN}✅ $name${NC} - $version"
        return 0
    else
        echo -e "${RED}❌ $name${NC} - Não encontrado"
        return 1
    fi
}

echo -e "\n${YELLOW}🔧 Ferramentas CLI Modernas:${NC}"
test_version "bat" "Bat" "--version"
test_version "eza" "Eza" "--version"
test_version "fd" "Fd" "--version"
test_version "rg" "Ripgrep" "--version"
test_version "fzf" "FZF" "--version"
test_version "delta" "Delta" "--version"
test_version "dust" "Dust" "--version"
test_version "btm" "Bottom" "--version"
test_version "zoxide" "Zoxide" "--version"
test_version "starship" "Starship" "--version"

echo -e "\n${YELLOW}🚀 Git & Desenvolvimento:${NC}"
test_version "lazygit" "LazyGit" "--version"
test_version "gh" "GitHub CLI" "--version"
test_version "glab" "GitLab CLI" "--version"
test_version "pre-commit" "Pre-commit" "--version"

echo -e "\n${YELLOW}💻 Linguagens:${NC}"
test_version "python3" "Python" "--version"
test_version "node" "Node.js" "--version"
test_version "ruby" "Ruby" "--version"
test_version "go" "Go" "version"
test_version "rustc" "Rust" "--version"
test_version "java" "Java" "--version"

echo -e "\n${YELLOW}☁️ DevOps:${NC}"
test_version "kubectl" "Kubectl" "version --client"
test_version "helm" "Helm" "version --short"
test_version "k9s" "K9s" "version"
test_version "aws" "AWS CLI" "--version"
test_version "gcloud" "Google Cloud" "version"
test_version "terraform" "Terraform" "--version"

echo -e "\n${YELLOW}🛠️ Build & Package:${NC}"
test_version "poetry" "Poetry" "--version"
test_version "pipx" "Pipx" "--version"
test_version "uv" "UV" "--version"
test_version "yarn" "Yarn" "--version"
test_version "just" "Just" "--version"

echo -e "\n${YELLOW}📊 Utilitários:${NC}"
test_version "jq" "JQ" "--version"
test_version "yq" "YQ" "--version"
test_version "hyperfine" "Hyperfine" "--version"
test_version "tokei" "Tokei" "--version"
test_version "tmux" "Tmux" "-V"
test_version "nvim" "Neovim" "--version"

echo -e "\n${YELLOW}🔍 Testando aliases do ZSH:${NC}"

# Função para testar se um alias existe
test_alias() {
    local alias_name="$1"
    local description="$2"
    
    if alias "$alias_name" &>/dev/null; then
        local alias_cmd
        alias_cmd=$(alias "$alias_name" | cut -d"'" -f2)
        echo -e "${GREEN}✅ $alias_name${NC} → $alias_cmd ($description)"
    else
        echo -e "${RED}❌ $alias_name${NC} - Alias não encontrado"
    fi
}

# Verificar se estamos no zsh e se os aliases estão carregados
if [ -n "$ZSH_VERSION" ]; then
    echo "Detectado ZSH - verificando aliases..."
    test_alias "ll" "eza detalhado"
    test_alias "la" "eza com arquivos ocultos"
    test_alias "lt" "eza em árvore"
    test_alias "cat" "bat com highlighting"
    test_alias "find" "fd moderno"
    test_alias "grep" "ripgrep"
    test_alias "htop" "bottom"
    test_alias "top" "bottom"
    test_alias "du" "dust"
    test_alias "z" "zoxide"
else
    echo -e "${YELLOW}⚠️ Não está no ZSH - reinicie o terminal para testar aliases${NC}"
fi

echo -e "\n${YELLOW}📁 Verificando arquivos de configuração:${NC}"

check_file() {
    local file="$1"
    local description="$2"
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $description${NC} - $file"
    else
        echo -e "${RED}❌ $description${NC} - $file não encontrado"
    fi
}

check_file "$HOME/.config/mise/config.toml" "Configuração Mise"
check_file "$HOME/.default-python-packages" "Pacotes Python padrão"
check_file "$HOME/.default-npm-packages" "Pacotes NPM padrão"
check_file "$HOME/.default-gems" "Gems Ruby padrão"

echo -e "\n${YELLOW}🎯 Teste de Performance:${NC}"

# Teste simples de performance comparando ls vs eza
if command -v eza &> /dev/null && command -v hyperfine &> /dev/null; then
    echo "Comparando performance ls vs eza (se disponível):"
    hyperfine --warmup 3 'ls -la /usr/bin | head -20' 'eza -la /usr/bin | head -20' 2>/dev/null || echo "Hyperfine ou eza não disponível para benchmark"
fi

echo -e "\n${GREEN}🎉 Teste concluído!${NC}"
echo -e "${YELLOW}💡 Dicas:${NC}"
echo "• Execute 'exec zsh' para recarregar as configurações"
echo "• Use 'mise list' para ver todas as ferramentas instaladas"
echo "• Use 'mise upgrade' para atualizar tudo"
echo "• Consulte os guias em ~/.dotfiles/mise/ para mais dicas"

# Verificar se mise está no PATH
if command -v mise &> /dev/null; then
    echo -e "\n${GREEN}🎯 Mise está funcionando perfeitamente!${NC}"
    echo "Ferramentas disponíveis: $(mise list | wc -l) instaladas"
else
    echo -e "\n${RED}⚠️ Mise não está no PATH - adicione ~/.local/share/mise/bin ao PATH${NC}"
fi
