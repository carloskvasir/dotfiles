# 🔗 VS Code Remote Development Guide

## 📱 **Instalação do VS Code Desktop**

```bash
# Opção 1: Via APT (recomendado)
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code

# Opção 2: Via Snap (mais simples)
sudo snap install code --classic
```

## 🌐 **Desenvolvimento Remoto**

### **Extensões Essenciais**
```bash
# Instalar extensões via comando
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension ms-vscode-remote.remote-containers  
code --install-extension ms-vscode-remote.remote-wsl
code --install-extension ms-vscode-remote.vscode-remote-extensionpack
```

### **Conexão SSH Remota**
1. **Configurar SSH** no `~/.ssh/config`:
```
Host servidor-dev
    HostName 192.168.1.100
    User carlos
    Port 22
    IdentityFile ~/.ssh/id_rsa
```

2. **Conectar via VS Code**:
   - `Ctrl+Shift+P` → "Remote-SSH: Connect to Host"
   - Escolher `servidor-dev`
   - VS Code Server será instalado automaticamente

### **Containers e Docker**
```bash
# Abrir projeto em container
code .devcontainer/devcontainer.json
# Ctrl+Shift+P → "Remote-Containers: Reopen in Container"
```

## 🛠️ **Integração com Mise**

### **Configuração do Terminal Integrado**
No VS Code, as ferramentas do mise funcionam automaticamente porque:

1. **Terminal herda o PATH** do shell configurado
2. **Mise está ativado** no `.zshrc` via `eval "$(mise activate zsh)"`
3. **Todas as ferramentas** ficam disponíveis instantaneamente

### **Verificação**
No terminal integrado do VS Code:
```bash
which python  # ~/.local/share/mise/installs/python/3.12.11/bin/python
which node    # ~/.local/share/mise/installs/node/22.16.0/bin/node
which ruby    # ~/.local/share/mise/installs/ruby/3.4.4/bin/ruby
```

## 🎯 **Configurações Recomendadas**

### **Settings.json do VS Code**
```json
{
    "terminal.integrated.defaultProfile.linux": "zsh",
    "terminal.integrated.profiles.linux": {
        "zsh": {
            "path": "/usr/bin/zsh",
            "args": ["-l"]
        }
    },
    "python.defaultInterpreterPath": "python",
    "ruby.interpreter.commandPath": "ruby",
    "go.gopath": ""
}
```

### **Extensões para Desenvolvimento**
```bash
# Languages
code --install-extension ms-python.python
code --install-extension ms-vscode.go  
code --install-extension rebornix.ruby
code --install-extension bradlc.vscode-tailwindcss

# Tools
code --install-extension ms-vscode.vscode-json
code --install-extension redhat.vscode-yaml
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools

# Git
code --install-extension eamodio.gitlens
code --install-extension github.copilot
```

## 🚀 **Workflow de Desenvolvimento**

### **Projeto Local**
```bash
# 1. Navegar para o projeto
cd ~/projetos/meu-app

# 2. Configurar versions para o projeto
mise use python@3.12 node@22 ruby@3.4

# 3. Abrir no VS Code
code .

# 4. No terminal integrado, tudo já funciona
python --version  # 3.12.11
npm --version     # 10.8.1
bundle install    # usa Ruby 3.4.4
```

### **Projeto Remoto**
```bash
# 1. Conectar via SSH
# VS Code → Remote-SSH: Connect

# 2. Clonar projeto no servidor remoto
git clone https://github.com/usuario/projeto.git

# 3. Abrir pasta no VS Code remoto
# File → Open Folder

# 4. mise funciona automaticamente no servidor
```

## 🔍 **Troubleshooting**

### **Ferramentas não encontradas**
```bash
# No terminal integrado do VS Code:
echo $PATH    # Verificar se mise está no PATH
mise doctor   # Diagnóstico completo
exec zsh      # Recarregar shell
```

### **Python/Node não detectados**
```json
// settings.json
{
    "python.pythonPath": "python",
    "eslint.nodePath": "node"
}
```

### **Performance remota lenta**
- Usar extensão "Remote - SSH: Editing Configuration Files"
- Configurar `"remote.SSH.useLocalServer": true`
- Usar `"remote.SSH.showLoginTerminal": true` para debug

## 💡 **Dicas Pro**

1. **Multi-root workspace**: Abrir múltiplos projetos com diferentes versões
2. **Dev Containers**: Usar `.devcontainer/` para ambientes consistentes  
3. **Live Share**: Colaboração em tempo real
4. **Settings Sync**: Sincronizar configurações entre máquinas

**VS Code + Mise = Ambiente de desenvolvimento poderoso e consistente!** 🎉
