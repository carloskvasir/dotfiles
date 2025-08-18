# 🚀 Como Usar no GitHub Codespaces

## 📋 **Opções Disponíveis**

### 🎯 **Opção 1: Build Automático (RECOMENDADO)**
**Vantagens:** Simples, sem configuração extra
**Desvantagens:** Build inicial pode levar 5-10 minutos

1. **Faça push do repositório:**
   ```bash
   git add .
   git commit -m "Add DevContainer configuration"
   git push origin main
   ```

2. **Crie o Codespace:**
   - Vá para o repositório no GitHub
   - Clique em "Code" > "Codespaces" > "Create codespace on main"
   - Aguarde o build (primeira vez demora mais)

### 🚀 **Opção 2: Imagem Pré-buildada (MAIS RÁPIDO)**
**Vantagens:** Startup em 1-2 minutos
**Desvantagens:** Requer publicação da imagem

1. **Publique a imagem:**
   ```bash
   # Execute o script de publicação
   ./publish-to-github.sh
   ```

2. **Atualize o devcontainer.json:**
   ```json
   {
     "name": "Dotfiles ZSH Development Environment",
     "image": "ghcr.io/carloskvasir/dotfiles-devcontainer:latest",
     "features": {...},
     "customizations": {...}
   }
   ```

3. **Commit e push:**
   ```bash
   git add .devcontainer/devcontainer.json
   git commit -m "Use pre-built DevContainer image"
   git push origin main
   ```

### ⚡ **Opção 3: GitHub Actions + Prebuild (PROFISSIONAL)**
**Vantagens:** Build automático + cache + prebuild
**Desvantagens:** Configuração mais complexa

1. **O workflow já está configurado** em `.github/workflows/devcontainer.yml`

2. **Configure Prebuild no GitHub:**
   - Vá em: `Settings` > `Codespaces` > `Set up prebuild`
   - Selecione branch: `main`
   - Selecione região: `US East`
   - Configure trigger: `On push to branch`

3. **Resultado:** Codespaces serão criados instantaneamente!

## 🎛️ **Configurações Específicas para Codespaces**

### 📝 **devcontainer.json otimizado:**
```json
{
  "name": "Dotfiles ZSH Development Environment",
  "dockerComposeFile": "docker-compose.yml",
  "service": "devcontainer",
  "workspaceFolder": "/workspaces/dotfiles",
  
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.defaultProfile.linux": "zsh",
        "workbench.colorTheme": "GitHub Dark Default"
      },
      "extensions": [
        "GitHub.copilot",
        "GitHub.copilot-chat"
      ]
    },
    "codespaces": {
      "openFiles": ["README.md"]
    }
  },
  
  "features": {
    "ghcr.io/devcontainers/features/github-cli:1": {}
  },
  
  "forwardPorts": [3000, 8000, 8080],
  "hostRequirements": {
    "memory": "4gb",
    "storage": "32gb",
    "cpus": 2
  }
}
```

## 🔧 **Scripts Úteis**

### 📦 **Para publicar imagem:**
```bash
./publish-to-github.sh
```

### 🧪 **Para testar localmente:**
```bash
./build-simple.sh
docker-compose up -d
```

### 🔍 **Para validar configuração:**
```bash
./validate-mise-config.sh
```

## 📊 **Comparação de Performance**

| Método | Primeira Vez | Subsequentes | Manutenção |
|--------|--------------|--------------|------------|
| Build Automático | 8-12 min | 2-5 min | Baixa |
| Imagem Pré-buildada | 2-3 min | 1-2 min | Média |
| Prebuild + Actions | 30-60 seg | 30-60 seg | Alta |

## 🎯 **Recomendação Final**

1. **Para testes rápidos:** Use Build Automático
2. **Para uso regular:** Configure Prebuild + Actions
3. **Para produção:** Use Imagem Pré-buildada + Prebuild

## 🔗 **Links Úteis**

- [Codespaces Documentation](https://docs.github.com/en/codespaces)
- [DevContainer Reference](https://containers.dev/implementors/json_reference/)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
