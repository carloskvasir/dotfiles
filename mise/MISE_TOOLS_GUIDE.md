# 🛠️ Ferramentas Mise Configuradas

## ✅ **Principais Benefícios desta Configuração**

- **Automatização completa**: Todas as ferramentas instaladas com um comando
- **Ambientes consistentes**: Mesmas versões em todos os projetos
- **Performance otimizada**: Ferramentas modernas em Rust
- **Integração total**: Funciona perfeitamente com tmux, IDEs e terminal

---

## 📦 **Ferramentas por Categoria**

### 🔧 **Ferramentas de Linha de Comando Modernas**
```bash
fd                      # Find moderno (substitui find)
bat                     # Cat com syntax highlighting  
eza                     # ls moderno (substitui ls)
ripgrep (rg)           # Grep ultra-rápido
fzf                    # Fuzzy finder
delta                  # Git diff melhorado
dust                   # du moderno
procs                  # ps moderno  
bottom (btm)           # htop moderno
zoxide (z)             # cd inteligente
hyperfine              # Benchmarking de comandos
tokei                  # Contador de linhas de código
```

### 🚀 **Git & Versionamento**
```bash
lazygit                # Git TUI interativo
gh                     # GitHub CLI
glab                   # GitLab CLI
git-cliff              # Gerador de changelog
pre-commit             # Git hooks
```

### 💻 **Linguagens & Runtimes**
```bash
node 22.16.0           # Node.js LTS
python 3.12            # Python moderno
ruby 3                 # Ruby para Rails
go latest              # Go para ferramentas
rust latest            # Rust para performance
java 24                # Java enterprise
lua latest             # Lua para Neovim
```

### 🏗️ **Build & Deploy**
```bash
terraform              # Infrastructure as Code
maven                  # Build Java
yarn                   # Package manager JS
just                   # Command runner
docker                 # Containerização
kubectl                # Kubernetes CLI
helm                   # Kubernetes packages
```

### ☁️ **Cloud & DevOps**
```bash
gcloud                 # Google Cloud CLI
aws-cli                # AWS CLI
k9s                    # Kubernetes TUI
```

### 🔍 **Desenvolvimento Web**
```bash
deno                   # Runtime JS/TS moderno
bun                    # Runtime JS ultra-rápido
```

---

## 🎯 **Comandos Úteis do Mise**

### Gerenciamento Básico
```bash
mise install           # Instala todas as ferramentas do config.toml
mise i                 # Alias para install
mise upgrade           # Atualiza todas para latest
mise u                 # Alias para upgrade
mise list              # Lista ferramentas disponíveis
mise ls                # Alias para list
mise list --installed  # Lista apenas instaladas
mise lsi               # Alias para list --installed
```

### Gerenciamento por Projeto
```bash
mise use node@20       # Define Node 20 para projeto atual
mise use --global python@3.11  # Define Python global
mise local ruby@3.2    # Cria .tool-versions local
mise shell go@1.19     # Temporário na sessão atual
```

### Informações e Debug
```bash
mise current           # Mostra versões ativas
mise where node        # Mostra caminho de instalação
mise which node        # Mostra executável ativo
mise doctor            # Diagnóstico do sistema
mise config            # Mostra configuração atual
```

---

## ⚡ **Aliases Configurados**

```bash
mise i                 # = mise install
mise u                 # = mise upgrade  
mise ls                # = mise list
mise lsi               # = mise list --installed
```

---

## 📁 **Arquivos de Configuração**

### 🐍 **Python** (`~/.default-python-packages`)
- **black**, **flake8**, **mypy** - Formatação e linting
- **pytest**, **ipython**, **jupyter** - Desenvolvimento
- **httpie**, **rich**, **typer** - CLI tools

### 📦 **Node.js** (`~/.default-npm-packages`) 
- **typescript**, **eslint**, **prettier** - Desenvolvimento
- **vite**, **serve**, **nodemon** - Build e dev server
- **create-react-app**, **@angular/cli** - Frameworks

### 💎 **Ruby** (`~/.default-gems`)
- **rails**, **bundler**, **pry** - Desenvolvimento Rails
- **rubocop**, **rspec**, **factory_bot** - Testing
- **solargraph**, **brakeman** - Tooling

---

## 🔄 **Integração com IDEs**

### VS Code
```bash
# O mise funciona automaticamente no terminal integrado
# Extensões recomendadas:
# - mise-vscode (se disponível)
# - Better TOML (para editar config.toml)
```

### RubyMine  
```bash
# Configure o interpretador Ruby para usar:
# ~/.local/share/mise/installs/ruby/3.x.x/bin/ruby

# Para Rails:
# ~/.local/share/mise/installs/ruby/3.x.x/bin/rails
```

### Terminal Integrado
```bash
# O mise é ativado automaticamente via eval "$(mise activate zsh)"
# no seu .zshrc, funcionando em qualquer terminal
```

---

## 🚀 **Comandos de Produtividade**

### Busca Rápida  
```bash
fd arquivo             # Busca arquivos
rg "texto"             # Busca conteúdo
fzf                    # Fuzzy finder interativo
```

### Navegação
```bash
z projeto              # cd inteligente
eza -la                # ls moderno com detalhes
bat arquivo.py         # cat com syntax highlight
```

### Git Workflow
```bash
lazygit                # Git TUI completo
gh repo create         # Criar repo GitHub
gh pr create           # Criar Pull Request
```

### Monitoramento
```bash
btm                    # Monitor de sistema
procs                  # Lista de processos
dust                   # Uso de disco
```

---

## 🎨 **Próximos Passos**

1. **Execute**: `mise install` para instalar tudo
2. **Configure**: Ajuste versões específicas por projeto
3. **Explore**: Teste as ferramentas modernas (fd, bat, eza)
4. **Integre**: Configure IDEs para usar as versões do mise
5. **Automatize**: Use os arquivos de pacotes padrão

---

*💡 **Dica**: Execute `mise doctor` se tiver problemas e `mise config` para ver a configuração ativa*
