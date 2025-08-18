# GitHub Actions Configuration Guide

## 🚀 Configuração Automática de Build e Push

Este guia explica como configurar o build automático e push da imagem DevContainer para o GitHub Container Registry.

## 📋 Pré-requisitos

1. **Repository no GitHub** com acesso a GitHub Actions
2. **GitHub Container Registry habilitado** (automático)
3. **Permissões corretas** no repositório

## ⚙️ Configuração Rápida

### 1. Verificar Arquivos Criados

Os seguintes arquivos foram criados automaticamente:

```
.github/workflows/build-devcontainer.yml  # Workflow principal
.devcontainer/install-mise-tools.sh       # Script de instalação
.dockerignore                             # Exclusões do Docker
.devcontainer/test-github-actions-locally.sh  # Teste local
```

### 2. Configurar Permissões (Importante!)

No seu repositório GitHub:

1. Vá em **Settings** → **Actions** → **General**
2. Em **Workflow permissions**, selecione:
   - ✅ **Read and write permissions**
   - ✅ **Allow GitHub Actions to create and approve pull requests**

### 3. Ativar GitHub Container Registry

1. Vá em **Settings** → **Developer settings** → **Personal access tokens**
2. Ou simplesmente faça push - será ativado automaticamente

## 🏗️ Como Funciona o Workflow

### Triggers Automáticos

O workflow é executado quando:

```yaml
on:
  push:
    branches: [ main, dev ]  # Push para main ou dev
    paths:                   # Apenas se mudaram:
      - '.devcontainer/**'
      - 'mise/**'
      - 'nvim/**'
      - 'zsh/**'
  
  pull_request:
    branches: [ main ]       # PRs para main
    
  workflow_dispatch:         # Execução manual
```

### Stages do Build

1. **Validate** - Verifica arquivos necessários
2. **Build** - Constrói cada stage em paralelo
3. **Build-final** - Imagem final e push para registry
4. **Test** - Testa a imagem construída
5. **Notify** - Resumo do resultado

## 🧪 Teste Local Antes do Push

Antes de fazer commit, teste localmente:

```bash
cd /home/carlos/.dotfiles
chmod +x .devcontainer/test-github-actions-locally.sh
./.devcontainer/test-github-actions-locally.sh
```

Este script simula exatamente o que o GitHub Actions fará.

## 📦 Uso da Imagem Buildada

### Automático (Recomendado)

Mantenha no seu `.devcontainer/devcontainer.json`:

```json
{
  "dockerFile": "Dockerfile",
  "context": ".."
}
```

O GitHub Codespaces buildará automaticamente.

### Pré-buildada (Mais Rápido)

Para usar a imagem pré-buildada, atualize `.devcontainer/devcontainer.json`:

```json
{
  "image": "ghcr.io/carloskvasir/dotfiles/devcontainer:latest"
}
```

## 🔄 Workflow Manual

Para executar manualmente:

1. Vá na aba **Actions** do seu repositório
2. Selecione **Build and Push DevContainer**
3. Clique em **Run workflow**
4. Configure as opções:
   - **Push to registry**: true/false
   - **Cache strategy**: registry/local/none

## 📊 Monitoramento

### Ver Status do Build

1. Vá em **Actions** no GitHub
2. Veja o status em tempo real
3. Logs detalhados de cada step

### Ver Imagens Publicadas

1. Vá em **Packages** no seu perfil/organização
2. Encontre `dotfiles/devcontainer`
3. Veja todas as tags disponíveis

## 🏷️ Estratégia de Tags

- `latest` - Último build da branch main
- `main` - Específico da branch main
- `dev` - Específico da branch dev
- `pr-X` - Builds de Pull Requests
- `stage-name-hash` - Stages individuais

## 🔧 Troubleshooting

### Build Falhando?

1. **Teste local primeiro**:
   ```bash
   ./.devcontainer/test-github-actions-locally.sh
   ```

2. **Verificar logs do GitHub Actions**

3. **Arquivos mais comuns que causam problemas**:
   - Falta de `install-mise-tools.sh`
   - SSH sockets (use `.dockerignore`)
   - Permissões do workflow

### Cache Issues

Para limpar cache do GitHub Actions:

1. Vá em **Actions** → **Caches**
2. Delete caches antigos se necessário

### Permissões

Se der erro de permissão:

```
Error: failed to push ghcr.io/user/repo: unauthorized
```

Verifique as permissões do workflow (passo 2 acima).

## 🚀 Próximos Passos

1. **Faça commit dos arquivos criados**:
   ```bash
   git add .github .devcontainer .dockerignore
   git commit -m "feat: add GitHub Actions for DevContainer build"
   git push
   ```

2. **Acompanhe o primeiro build**:
   - Vá em Actions no GitHub
   - Veja o workflow executar

3. **Configure Codespaces**:
   - Use a imagem buildada automaticamente
   - Ou configure para usar a pré-buildada

## ✅ Validação Final

Para confirmar que tudo está funcionando:

1. ✅ Push trigger o workflow
2. ✅ Workflow completa sem erros
3. ✅ Imagem aparece em Packages
4. ✅ Codespaces usa a imagem corretamente

## 🔗 Links Úteis

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [Codespaces with Dev Containers](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/setting-up-your-project-for-codespaces)

---

**Pronto!** 🎉 Agora você tem build e deploy automático da sua imagem DevContainer.
