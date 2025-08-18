# DevContainer Setup for GitHub Codespaces

## 🚀 Como usar este DevContainer no GitHub Codespaces

### Método 1: Build Automático (Recomendado)
1. Faça push do repositório para o GitHub
2. Vá para o repositório no GitHub
3. Clique em "Code" > "Codespaces" > "Create codespace on main"
4. O GitHub vai buildar a imagem automaticamente usando o Dockerfile

### Método 2: Usando Imagem Pré-buildada
Se você quiser acelerar o startup, pode usar imagens pré-buildadas.

## 📋 Arquivos necessários no repositório:
- `.devcontainer/devcontainer.json`
- `.devcontainer/Dockerfile`
- `.devcontainer/docker-compose.yml`
- `mise/.config/mise/config.toml`
- `mise/.default-*-packages`

## ⚡ Para otimizar no Codespaces:
1. Use prebuilds (configuração no GitHub)
2. Configure cache de layers no GitHub Actions
3. Use imagem base oficial do GitHub Codespaces se necessário

## 🔧 Configuração de Prebuild:
No GitHub, vá em Settings > Codespaces > Set up prebuild para configurar builds automáticos quando você fizer push.
