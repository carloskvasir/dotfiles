# 🔑 GitHub Token Configuration Guide

## 📋 Pré-requisitos

Para fazer push de imagens Docker para o GitHub Container Registry (GHCR), você precisa de um Personal Access Token (PAT) com permissões adequadas.

## 🔧 Passo 1: Criar GitHub Personal Access Token

### 1.1 Acessar GitHub Settings
1. Vá para [GitHub.com](https://github.com)
2. Clique na sua foto de perfil (canto superior direito)
3. Selecione **Settings**
4. No menu lateral esquerdo, clique em **Developer settings**
5. Clique em **Personal access tokens**
6. Selecione **Tokens (classic)** ou **Fine-grained tokens**

### 1.2 Criar Novo Token (Classic - Recomendado)
1. Clique em **Generate new token** → **Generate new token (classic)**
2. Preencha as informações:

#### Token Details:
```
Name: dotfiles-devcontainer-registry
Description: Token for pushing DevContainer images to GHCR
Expiration: 90 days (ou conforme preferência)
```

#### Permissions Required:
```
✅ write:packages     - Push packages to GitHub Packages
✅ read:packages      - Pull packages from GitHub Packages  
✅ delete:packages    - Delete packages (opcional)
✅ repo               - Access to repositories (se repositório privado)
```

### 1.3 Permissions Detalhadas
- **`write:packages`**: **OBRIGATÓRIO** - Permite push de imagens
- **`read:packages`**: **OBRIGATÓRIO** - Permite pull de imagens
- **`delete:packages`**: **OPCIONAL** - Permite deletar imagens antigas
- **`repo`**: **NECESSÁRIO SE REPO PRIVADO** - Acesso ao repositório

3. Clique em **Generate token**
4. **⚠️ IMPORTANTE**: Copie o token imediatamente (só aparece uma vez!)

## 🔒 Passo 2: Configurar Token Localmente

### 2.1 Adicionar ao .env
```bash
# Editar arquivo .env
nano .env
```

Adicione a linha:
```env
GITHUB_REGISTRY_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### 2.2 Testar Token
```bash
# Carregar environment
source .env

# Testar login
echo "$GITHUB_REGISTRY_TOKEN" | docker login ghcr.io -u carloskvasir --password-stdin
```

## 🚀 Passo 3: Usar com Scripts

### 3.1 Push Manual
```bash
# Usar script de push manual
./.devcontainer/manual-push-to-ghcr.sh
```

### 3.2 Build e Push Automático
```bash
# Build + Push em um comando
./.devcontainer/build-and-push.sh
```

## 🎛️ Passo 4: GitHub Actions (Automático)

Para GitHub Actions, o token é fornecido automaticamente:

```yaml
# .github/workflows/build-devcontainer.yml
- name: Log in to Container Registry
  uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}  # Automático
```

## 🔐 Segurança do Token

### ✅ Boas Práticas:
- ✅ Token no `.env` (git-ignored)
- ✅ Permissões mínimas necessárias
- ✅ Expiração configurada
- ✅ Nome descritivo do token

### ❌ Nunca Faça:
- ❌ Hardcode token nos scripts
- ❌ Commit token no git
- ❌ Compartilhe token em texto plano
- ❌ Use token sem expiração

## 🧪 Validação

### Testar Push:
```bash
# 1. Build da imagem
./.devcontainer/build-production.sh

# 2. Push para registry
./.devcontainer/manual-push-to-ghcr.sh
```

### Verificar no GitHub:
1. Vá para seu perfil no GitHub
2. Clique na aba **Packages**
3. Deve aparecer: `dotfiles/devcontainer`

## 🔄 Renovação do Token

### Quando Renovar:
- ✅ Antes da expiração
- ✅ Se suspeitar de comprometimento
- ✅ Mudança de permissões necessárias

### Como Renovar:
1. Gerar novo token (mesmos passos)
2. Atualizar `.env` com novo token
3. Testar funcionamento

## 🆘 Troubleshooting

### Erro: "unauthorized"
```bash
# Verificar token
echo "$GITHUB_REGISTRY_TOKEN" | wc -c  # Deve ter ~40 caracteres

# Re-login
docker logout ghcr.io
echo "$GITHUB_REGISTRY_TOKEN" | docker login ghcr.io -u seu-username --password-stdin
```

### Erro: "insufficient scope"
- ✅ Verificar se token tem `write:packages`
- ✅ Verificar se token não expirou
- ✅ Verificar username correto

### Erro: "package not found"
- ✅ Verificar nome do repositório
- ✅ Verificar se repositório é público/privado
- ✅ Verificar permissões do token

## 📋 Checklist Final

Antes de usar:
- [ ] Token criado com permissões corretas
- [ ] Token adicionado ao `.env`
- [ ] `.env` está no `.gitignore`
- [ ] Login testado com sucesso
- [ ] Build da imagem funciona
- [ ] Push manual funciona

**Após configurar, você terá push automático funcionando! 🎉**
