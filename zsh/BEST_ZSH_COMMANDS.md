# 🚀 Best Zsh Commands & Configuration Guide

> **Configuração otimizada para Linux Mint + Tmux + IDEs (RubyMine/VSCode)**

## 📋 Índice

- [🎯 Comandos de Histórico & Busca](#-comandos-de-histórico--busca)
- [📁 Navegação de Arquivos & Diretórios](#-navegação-de-arquivos--diretórios)
- [📋 Sistema de Clipboard](#-sistema-de-clipboard)
- [🌿 Git & Controle de Versão](#-git--controle-de-versão)
- [🚀 Rails Development](#-rails-development)
- [📺 Tmux Integration](#-tmux-integration)
- [🔧 System & Process Management](#-system--process-management)
- [⚡ Power User Tips](#-power-user-tips)

---

## 🎯 Comandos de Histórico & Busca

### FZF History Search (Melhorado)
```bash
# Busca interativa no histórico
Ctrl+R                    # Abre busca FZF no histórico

# Dentro do FZF History:
Ctrl+Y                    # Copia comando para clipboard e sai
Ctrl+X                    # Copia comando para clipboard e continua
Ctrl+R                    # Alterna ordenação (recente ↔ antigo)
?                         # Liga/desliga preview
Ctrl+U                    # Scroll up no preview
Ctrl+J                    # Scroll down no preview
Enter                     # Executa comando selecionado
Esc                       # Cancela busca
```

### Histórico Tradicional
```bash
!!                        # Repete último comando
!string                   # Executa último comando que começa com 'string'
!?string                  # Executa último comando que contém 'string'
^old^new                  # Substitui 'old' por 'new' no último comando
history | grep comando    # Busca comando específico no histórico
```

---

## 📁 Navegação de Arquivos & Diretórios

### FZF File & Directory Navigation
```bash
# Busca de arquivos
Ctrl+T                    # Busca arquivos com preview (bat)

# Busca de diretórios
Alt+C                     # Busca e navega para diretórios

# Dentro do FZF Files/Dirs:
Ctrl+/                    # Liga/desliga preview
Tab                       # Seleciona múltiplos arquivos
Enter                     # Confirma seleção
```

### Navegação Tradicional Melhorada
```bash
# Autocompleção inteligente
ls <Tab>                  # Lista arquivos com cores
cd <Tab>                  # Autocompleção de diretórios (case-insensitive)

# Navegação rápida
..                        # Volta um diretório
...                       # Volta dois diretórios
....                      # Volta três diretórios

# Busca de arquivos
find . -name "*.rb"       # Busca arquivos Ruby
fd "pattern"              # Busca moderna (se fd estiver instalado)
```

---

## 📋 Sistema de Clipboard

### Funções de Cópia Avançadas
```bash
# Cópia básica
copy "texto"              # Copia texto para clipboard
paste                     # Cola do clipboard

# Cópia de comandos e arquivos
copyout                   # Copia último comando executado
cpwd                      # Copia diretório atual
copycat arquivo.txt       # Copia conteúdo de arquivo

# Git clipboard
cpcommit                  # Copia hash do commit atual
cpbranch                  # Copia nome da branch atual
cpremote                  # Copia URL do repositório remoto

# Sistema e rede
cpip                      # Copia IP público
cpssh [arquivo]           # Copia chave SSH pública
cpsysinfo                 # Copia informações do sistema

# Inteligente
smartcopy item            # Detecta se é arquivo, diretório ou texto
```

### Atalhos de Clipboard
```bash
Ctrl+X, Ctrl+C           # Copia linha de comando atual
Ctrl+X, Ctrl+V           # Cola do clipboard na linha de comando
```

---

## 🌿 Git & Controle de Versão

### FZF Git Integration
```bash
Ctrl+G, Ctrl+B           # Seletor interativo de branches Git
```

### Git Aliases Essenciais
```bash
# Status e informações
gst                       # git status
gaa                       # git add --all
gcmsg "message"           # git commit -m "message"

# Branches e navegação
gpr                       # git pull --rebase
gpsup                     # git push --set-upstream origin current_branch

# Histórico e logs
gl                        # git log com graph colorido
gla                       # git log --all com graph
```

### Git Workflow Commands
```bash
# Branch management
git checkout -b feature   # Cria e muda para nova branch
git branch -d branch      # Deleta branch local
git push -u origin branch # Push com upstream tracking

# Rebase workflow
git rebase -i HEAD~3      # Rebase interativo dos últimos 3 commits
git rebase main           # Rebase da branch atual com main
```

---

## 🚀 Rails Development

### Rails-specific Autocompletion
```bash
rails <Tab>               # Autocompleção de comandos Rails
rails generate <Tab>      # Autocompleção de generators
rake <Tab>                # Autocompleção de tasks (com cache)
bundle <Tab>              # Autocompleção de comandos bundle
```

### Rails Project Management
```bash
# Setup e navegação
rails-setup               # Auto-detecta projeto Rails e mostra info
rails-root                # Navega para raiz do projeto Rails
rs                        # Alias para rails-server com auto-detecção

# Logs
rails-logs [env]          # Tail dos logs (default: development)
```

### Rails Database Shortcuts
```bash
# Database management
rails-db-reset            # Drop, create, migrate, seed
rails-db-fresh            # Drop, create, schema:load, seed
rails db:migrate          # Roda migrações
rails db:rollback         # Desfaz última migração
rails db:seed             # Popula banco com seeds
```

### Rails Testing
```bash
# Testing shortcuts
rails-test                # Roda todos os testes
rails-spec                # Roda RSpec (se disponível)
rails-test-models         # Testa apenas models
rails-test-controllers    # Testa apenas controllers
```

### Rails Aliases & Functions
```bash
# Comandos básicos
rails c                   # rails console
rails s                   # rails server
rails g                   # rails generate
rails d                   # rails destroy

# Routes e schema clipboard
cproutes [filtro]         # Copia rotas Rails (opcionalmente filtradas)
cpschema modelo           # Copia schema de modelo específico
```

### Bundle Management
```bash
bundle install            # Instala gems
bundle update             # Atualiza gems
bundle exec comando       # Executa comando no contexto do bundle
```

---

## 📺 Tmux Integration

### Tmux Session Management
```bash
tm                        # Lista e seleciona sessões tmux com FZF
tm nome_sessao            # Conecta ou cria sessão específica
tw                        # Seleciona janela tmux com FZF
```

### Tmux + Zsh Workflow
```bash
# Dentro do tmux
Ctrl+B, C                 # Nova janela
Ctrl+B, %                 # Split vertical
Ctrl+B, "                 # Split horizontal
Ctrl+B, [                 # Modo de navegação/copy

# Navegação entre panes
Ctrl+B, arrow keys        # Navega entre panes
Ctrl+B, z                 # Zoom/unzoom pane atual
```

---

## 🔧 System & Process Management

### Process Management
```bash
Ctrl+P                    # Process killer interativo com FZF

# Comandos tradicionais
ps aux | grep processo    # Busca processo específico
top                       # Monitor de processos em tempo real
htop                      # Monitor melhorado (se instalado)
kill -9 PID              # Mata processo por PID
```

### System Information
```bash
# Informações do sistema
uname -a                  # Informações do kernel
df -h                     # Uso de disco
free -h                   # Uso de memória
lscpu                     # Informações da CPU
```

---

## ⚡ Power User Tips

### Quick Help Command
```bash
zsh-help                  # Mostra resumo de todos os comandos customizados
```

### Autocompleção Inteligente
```bash
# O Zsh tem autocompleção case-insensitive habilitada
cd desk<Tab>              # Completa para Desktop/
ls *.RB<Tab>              # Encontra arquivos .rb (case-insensitive)
```

### Zsh Globbing Patterns
```bash
ls **/*.rb                # Busca recursiva por arquivos .rb
ls *.{js,ts,jsx,tsx}      # Lista arquivos com múltiplas extensões
ls **/test*               # Busca arquivos/dirs que contenham 'test'
```

### Expansão de Histórico
```bash
# Modifiers de histórico
!!:h                      # Diretório do último comando
!!:t                      # Nome do arquivo do último comando
!!:r                      # Remove extensão do último comando
```

### Environment Variables
```bash
# Variáveis úteis
$PWD                      # Diretório atual
$OLDPWD                   # Diretório anterior
$RANDOM                   # Número aleatório
$COLUMNS                  # Largura do terminal
$LINES                    # Altura do terminal
```

### Performance Optimization
```bash
# Para IDEs (já configurado automaticamente)
# - Histórico compartilhado desabilitado em IDEs
# - FZF com altura reduzida (40%) em IDEs
# - Tmux integration automática quando disponível

# Reload configuration
source ~/.zshrc           # Recarrega configuração
```

---

## 🎨 Visual Enhancements

### Spaceship Prompt Features
```bash
# O prompt mostra automaticamente:
# - Status do Git (branch, changes, stash)
# - Ambiente virtual Python/Ruby
# - Versão do Node.js, Ruby, etc.
# - Tempo de execução de comandos longos
# - Status de exit codes
```

### FZF Visual Features
```bash
# Interface moderna com:
# - Bordas e cores tema Dracula
# - Preview windows contextuais
# - Headers informativos com dicas
# - Indicadores visuais (🔍 🌿 📚 📁 📂)
```

---

## 🛠️ Troubleshooting

### Common Issues
```bash
# Se o FZF não funcionar
which fzf                 # Verifica se está instalado
echo $FZF_DEFAULT_OPTS    # Verifica configurações

# Se autocompleção não funcionar
compinit -d               # Reconstrói cache de autocompleção
rm ~/.zcompdump*          # Remove cache antigo

# Se histórico não funcionar
echo $HISTFILE            # Verifica arquivo de histórico
ls -la ~/.zsh_history     # Verifica se arquivo existe
```

### IDE-specific Notes
```bash
# RubyMine/IntelliJ
# - Histórico compartilhado automaticamente desabilitado
# - FZF otimizado para menor altura

# VSCode
# - Integração automática detectada via $VSCODE_PID
# - Terminal integrado funciona normalmente
```

---

## 📚 Learning Resources

### Essential Zsh Concepts
- **Autocompleção**: Tab completion with intelligent matching
- **Globbing**: Pattern matching with *, **, {}, []
- **History**: Shared across sessions with search capabilities
- **Aliases**: Short commands for complex operations
- **Functions**: Complex logic with parameters

### Key Files
- `~/.zshrc` - Main configuration
- `~/.aliases` - Custom aliases
- `~/.fzf.zsh` - FZF integration
- `~/.zsh_history` - Command history

---

> **💡 Pro Tip**: Use `Ctrl+R` constantemente para buscar comandos anteriores. É o comando mais útil para produtividade!

> **🔥 Hot Tip**: Combine `cpbranch` + `copy` para workflow Git rápido: copie nome da branch e use em comandos ou issues.

> **⚡ Speed Tip**: Use `tm` no início do dia para rapidamente conectar às suas sessões tmux de trabalho.
