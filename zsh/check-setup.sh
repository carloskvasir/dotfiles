#!/bin/bash

# 🚀 Zsh Configuration Checker & Installer
# Verifica e instala dependências necessárias para configuração completa

echo "🔍 Verificando dependências da configuração Zsh..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if command exists
check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $1 está instalado"
        return 0
    else
        echo -e "${RED}✗${NC} $1 não encontrado"
        return 1
    fi
}

# Function to install package
install_package() {
    echo -e "${BLUE}📦${NC} Instalando $1..."
    sudo apt update && sudo apt install -y "$1"
}

echo -e "\n${BLUE}=== DEPENDÊNCIAS ESSENCIAIS ===${NC}"

# Check essential tools
missing_packages=()

if ! check_command "fzf"; then
    missing_packages+=("fzf")
fi

if ! check_command "git"; then
    missing_packages+=("git")
fi

if ! check_command "curl"; then
    missing_packages+=("curl")
fi

if ! check_command "tree"; then
    missing_packages+=("tree")
fi

if ! check_command "bat"; then
    echo -e "${YELLOW}⚠${NC}  bat não encontrado (opcional para preview de arquivos)"
    echo "    Instale com: sudo apt install bat"
fi

if ! check_command "fd"; then
    echo -e "${YELLOW}⚠${NC}  fd não encontrado (opcional para busca rápida de arquivos)"
    echo "    Instale com: sudo apt install fd-find"
fi

if ! check_command "xclip" && ! check_command "xsel" && ! check_command "wl-copy"; then
    echo -e "${RED}✗${NC} Nenhum utilitário de clipboard encontrado"
    missing_packages+=("xclip")
fi

echo -e "\n${BLUE}=== FERRAMENTAS DE DESENVOLVIMENTO ===${NC}"

check_command "tmux" || echo -e "${YELLOW}⚠${NC}  tmux recomendado para melhor experiência"
check_command "ruby" || echo -e "${YELLOW}⚠${NC}  ruby para desenvolvimento Rails"
check_command "rails" || echo -e "${YELLOW}⚠${NC}  rails para desenvolvimento Rails"
check_command "node" || echo -e "${YELLOW}⚠${NC}  node.js para desenvolvimento web"

echo -e "\n${BLUE}=== CONFIGURAÇÃO ZSH ===${NC}"

if [[ "$SHELL" == */zsh ]]; then
    echo -e "${GREEN}✓${NC} Zsh é o shell padrão"
else
    echo -e "${YELLOW}⚠${NC}  Zsh não é o shell padrão atual: $SHELL"
    echo "    Execute: chsh -s $(which zsh)"
fi

if [[ -d ~/.zplug ]]; then
    echo -e "${GREEN}✓${NC} Zplug está instalado"
else
    echo -e "${RED}✗${NC} Zplug não encontrado"
    echo "    Será instalado automaticamente na primeira execução do .zshrc"
fi

if [[ -f ~/.fzf.zsh ]]; then
    echo -e "${GREEN}✓${NC} FZF integration configurada"
else
    echo -e "${YELLOW}⚠${NC}  ~/.fzf.zsh não encontrado"
    echo "    Execute: $(curl -fsSL https://raw.githubusercontent.com/junegunn/fzf/HEAD/install) --all"
fi

echo -e "\n${BLUE}=== ARQUIVOS DE CONFIGURAÇÃO ===${NC}"

config_files=(
    "~/.dotfiles/zsh/.zshrc"
    "~/.aliases"
    "~/.gitconfig"
)

for file in "${config_files[@]}"; do
    expanded_file="${file/#\~/$HOME}"
    if [[ -f "$expanded_file" ]]; then
        echo -e "${GREEN}✓${NC} $file existe"
    else
        echo -e "${RED}✗${NC} $file não encontrado"
    fi
done

# Install missing packages
if [[ ${#missing_packages[@]} -gt 0 ]]; then
    echo -e "\n${YELLOW}📦 Pacotes faltando: ${missing_packages[*]}${NC}"
    read -p "Deseja instalar os pacotes faltando? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        for package in "${missing_packages[@]}"; do
            install_package "$package"
        done
    fi
fi

echo -e "\n${BLUE}=== VERIFICAÇÃO DE PERFORMANCE ===${NC}"

# Check history file size
if [[ -f ~/.zsh_history ]]; then
    hist_size=$(wc -l < ~/.zsh_history)
    echo -e "${GREEN}✓${NC} Histórico: $hist_size linhas"
    if [[ $hist_size -gt 10000 ]]; then
        echo -e "${YELLOW}⚠${NC}  Histórico grande, considere limpar: tail -5000 ~/.zsh_history > ~/.zsh_history.tmp && mv ~/.zsh_history.tmp ~/.zsh_history"
    fi
else
    echo -e "${YELLOW}⚠${NC}  Arquivo de histórico não encontrado (será criado)"
fi

# Check zsh completion cache
if [[ -f ~/.zcompdump ]]; then
    echo -e "${GREEN}✓${NC} Cache de autocompleção existe"
else
    echo -e "${YELLOW}⚠${NC}  Cache de autocompleção será criado na primeira execução"
fi

echo -e "\n${BLUE}=== RESUMO ===${NC}"

echo -e "📚 Documentação completa: ${HOME}/.dotfiles/zsh/BEST_ZSH_COMMANDS.md"
echo -e "🆘 Ajuda rápida: execute ${YELLOW}zsh-help${NC} no terminal"
echo -e "🔄 Recarregar config: ${YELLOW}source ~/.zshrc${NC}"

echo -e "\n${GREEN}🎉 Verificação concluída!${NC}"
echo -e "Execute ${YELLOW}source ~/.zshrc${NC} para aplicar a configuração."
