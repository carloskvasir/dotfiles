#!/bin/bash
# Script para publicar a imagem Docker no GitHub Container Registry

set -e

echo "🚀 Publicando DevContainer no GitHub Container Registry"
echo "======================================================"

# Configurações
GITHUB_USERNAME="carloskvasir"
IMAGE_NAME="dotfiles-devcontainer"
IMAGE_TAG="latest"
REGISTRY="ghcr.io"

# Imagem local
LOCAL_IMAGE="dotfiles-dev:latest"

# Imagem remota
REMOTE_IMAGE="$REGISTRY/$GITHUB_USERNAME/$IMAGE_NAME:$IMAGE_TAG"

echo "📋 Configuração:"
echo "  Local: $LOCAL_IMAGE"
echo "  Remote: $REMOTE_IMAGE"
echo ""

# Verificar se a imagem local existe
if ! docker image inspect "$LOCAL_IMAGE" &> /dev/null; then
    echo "❌ Imagem local não encontrada: $LOCAL_IMAGE"
    echo "Execute primeiro: ./build-simple.sh"
    exit 1
fi

echo "✅ Imagem local encontrada"

# Fazer tag para o registry
echo "🏷️  Criando tag para o registry..."
docker tag "$LOCAL_IMAGE" "$REMOTE_IMAGE"

echo "✅ Tag criada: $REMOTE_IMAGE"

# Login no GitHub Container Registry
echo ""
echo "🔐 Fazendo login no GitHub Container Registry..."
echo "Você precisa de um Personal Access Token com permissões 'write:packages'"
echo "Crie em: https://github.com/settings/tokens"
echo ""

# Prompt para token
echo "Digite seu GitHub Personal Access Token:"
read -s GITHUB_TOKEN

if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "❌ Token não pode ser vazio"
    exit 1
fi

# Login
echo "$GITHUB_TOKEN" | docker login "$REGISTRY" -u "$GITHUB_USERNAME" --password-stdin

if [[ $? -eq 0 ]]; then
    echo "✅ Login realizado com sucesso"
else
    echo "❌ Falha no login"
    exit 1
fi

# Push da imagem
echo ""
echo "📤 Enviando imagem para o registry..."
docker push "$REMOTE_IMAGE"

if [[ $? -eq 0 ]]; then
    echo ""
    echo "🎉 Imagem publicada com sucesso!"
    echo ""
    echo "📋 Para usar no devcontainer.json:"
    echo '{'
    echo '  "image": "'$REMOTE_IMAGE'",'
    echo '  "features": {...},'
    echo '  "customizations": {...}'
    echo '}'
    echo ""
    echo "🔗 Acesse em: https://github.com/$GITHUB_USERNAME?tab=packages"
else
    echo "❌ Falha ao enviar imagem"
    exit 1
fi

# Cleanup
docker logout "$REGISTRY"
echo "✅ Logout realizado"
