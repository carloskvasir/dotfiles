# 🎯 Mise Quick Reference - Comandos Essenciais

## 🚀 **Comandos Mise Mais Usados**

```bash
# === Instalação e Gerenciamento ===
mise install              # Instala TODAS as ferramentas do config.toml
mise i                    # Alias para install
mise upgrade              # Atualiza todas para versão latest
mise u                    # Alias para upgrade

# === Listagem ===
mise list --installed     # Lista ferramentas instaladas
mise lsi                  # Alias para list --installed
mise current              # Mostra versões ativas no diretório atual

# === Por Projeto ===
mise use node@20          # Define Node 20 para projeto atual  
mise use python@3.11      # Define Python 3.11 para projeto atual
mise local ruby@3.2       # Cria .tool-versions no diretório

# === Global ===
mise use --global node@22 # Define versão global
mise shell go@1.19        # Temporário apenas na sessão atual
```

---

## 🛠️ **Ferramentas Modernas Instaladas**

```bash
# === Navegação e Listagem ===
ls                        # = eza (moderno, com ícones)
ll                        # = eza -l (lista detalhada)
la                        # = eza -la (inclui arquivos ocultos)  
lt                        # = eza --tree (visualização árvore)

# === Visualização de Arquivos ===
cat arquivo.py            # = bat (syntax highlighting)
ccat arquivo.py           # = bat completo (com números de linha)

# === Busca ===
find . -name "*.rb"       # = fd (mais rápido e intuitivo)
fd "\.rb$"                # Busca arquivos .rb
rg "function"             # Busca texto em arquivos (ripgrep)

# === Navegação Inteligente ===
z projeto                 # = zoxide (cd inteligente)
z web                     # Vai para diretório que contém "web"

# === Monitoramento ===
htop                      # = bottom (monitor moderno)
du                        # = dust (uso de disco visual)

# === Git ===
git diff                  # Usa delta automaticamente (colorido)
lazygit                   # Git TUI completo
gh repo create            # GitHub CLI
```

---

## 📦 **Pacotes Padrão Auto-Instalados**

### 🐍 **Python** (via ~/.default-python-packages)
```bash
black arquivo.py          # Formatador de código
flake8 arquivo.py         # Linter
pytest                    # Executar testes
ipython                   # REPL melhorado
jupyter notebook          # Notebooks
http GET api.com/users    # HTTPie para APIs
```

### 📦 **Node.js** (via ~/.default-npm-packages)
```bash
tsc arquivo.ts            # TypeScript compiler
nodemon app.js            # Auto-restart em desenvolvimento
prettier --write .        # Formatador de código
serve build/              # Servidor estático
npx create-react-app app  # Criar app React
```

### 💎 **Ruby** (via ~/.default-gems)
```bash
rails new app             # Criar app Rails
bundle install            # Instalar gems
pry                       # REPL melhorado
rubocop                   # Linter Ruby
rspec                     # Executar testes
spring stop               # Parar Rails preloader
```

---

## 🔍 **FZF - Comandos Aprimorados**

```bash
# === Histórico ===
Ctrl+R                    # Busca interativa no histórico
Ctrl+Y                    # (no FZF) Copia comando sem executar

# === Arquivos ===  
Ctrl+T                    # Busca arquivos com preview (bat)
Alt+C                     # Busca diretórios (sem arquivos ocultos)

# === Git ===
Ctrl+G Ctrl+B            # Seletor de branches Git
```

---

## ⚡ **Aliases Úteis Configurados**

```bash
# === Clipboard ===
copy "texto"              # Copia texto para clipboard
cpwd                      # Copia diretório atual
copyout                   # Copia último comando
cpcommit                  # Copia hash do commit
cpbranch                  # Copia nome da branch

# === Git Workflow ===
gst                       # git status
gaa                       # git add --all  
gcmsg "msg"               # git commit -m "msg"
gpr                       # git pull --rebase

# === Rails ===
rc                        # rails console
rs                        # rails server
rg                        # rails generate  
rdbm                      # rails db:migrate
```

---

## 🎨 **Configuração para IDEs**

### **VS Code e Desenvolvimento Remoto**
- **VS Code Desktop**: Instalar via `sudo apt install code` ou snap
- **VS Code Server**: Instalado automaticamente quando você usa Remote Development
- **Extensões úteis**: Remote-SSH, Remote-Containers, Remote-WSL

### **Terminal em qualquer IDE**
- Funciona automaticamente via `eval "$(mise activate zsh)"` no .zshrc

---

## 🔧 **Solução de Problemas**

```bash
mise doctor               # Diagnóstico completo
mise config               # Mostra configuração ativa  
mise which node           # Mostra qual executável está sendo usado
mise where node           # Mostra diretório de instalação

# Se algo não funcionar:
mise reshim               # Reconstrói symlinks
source ~/.zshrc           # Recarrega configuração
```

---

## 📁 **Arquivos Importantes**

```
~/.config/mise/config.toml     # Configuração principal
~/.default-python-packages     # Pacotes Python auto-instalados  
~/.default-npm-packages        # Pacotes Node auto-instalados
~/.default-gems                # Gems Ruby auto-instaladas
.tool-versions                 # Versões por projeto (crie com mise local)
```

---

*💡 **Dica Pro**: Execute `mise install` após qualquer mudança no config.toml para manter tudo sincronizado!*
