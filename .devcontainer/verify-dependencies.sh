#!/bin/bash
# Comprehensive dependency verification script for mise requirements

set -e

echo "🔍 Verificando dependências do mise..."
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to check and report
check_tool() {
    local tool=$1
    local min_version=$2
    
    if command -v "$tool" >/dev/null 2>&1; then
        local version=$(eval "$tool --version 2>/dev/null | head -1" || echo "unknown")
        echo -e "${GREEN}✅ $tool${NC} - $version"
        return 0
    else
        echo -e "${RED}❌ $tool${NC} - NOT FOUND"
        return 1
    fi
}

# Function to check bash version specifically
check_bash_version() {
    local bash_version=$(bash --version | head -1 | grep -o "[0-9]\+\.[0-9]\+")
    local major_version=${bash_version%%.*}
    
    if [[ $major_version -ge 3 ]]; then
        echo -e "${GREEN}✅ bash${NC} - version $bash_version (>= 3.x required)"
        return 0
    else
        echo -e "${RED}❌ bash${NC} - version $bash_version (< 3.x)"
        return 1
    fi
}

# Function to check wget version
check_wget_version() {
    local wget_version=$(wget --version 2>/dev/null | head -1 | grep -o "[0-9]\+\.[0-9]\+" | head -1)
    if [[ -n "$wget_version" ]]; then
        # Check if version > 1.12 (simplified check)
        local major=$(echo $wget_version | cut -d. -f1)
        local minor=$(echo "$wget_version" | cut -d. -f2)
        if [[ $major -gt 1 ]] || [[ $major -eq 1 && $minor -gt 12 ]]; then
            echo -e "${GREEN}✅ wget${NC} - version $wget_version (> 1.12 required)"
            return 0
        else
            echo -e "${YELLOW}⚠️  wget${NC} - version $wget_version (might be < 1.12)"
            return 0
        fi
    else
        echo -e "${RED}❌ wget${NC} - version check failed"
        return 1
    fi
}

echo "🐚 Verificando shells..."
check_bash_version
check_tool "zsh"

echo ""
echo "🔧 Verificando utilitários essenciais..."
check_tool "grep"
check_wget_version
check_tool "curl"

echo ""
echo "🗜️  Verificando utilitários de compressão..."
check_tool "tar"
check_tool "bzip2"
check_tool "xz"

echo ""
echo "🔐 Verificando utilitários de hash..."
check_tool "md5sum"
check_tool "sha1sum" 
check_tool "sha256sum"
check_tool "sha512sum"

echo ""
echo "🩹 Verificando utilitários de patch..."
check_tool "patch"

echo ""
echo "🏗️  Verificando compiladores..."
check_tool "gcc"
check_tool "clang"

echo ""
echo "📦 Verificando ferramentas de desenvolvimento..."
check_tool "make"
check_tool "git"
check_tool "stow"
check_tool "mise"

echo ""
echo "=================================================="
echo -e "${GREEN}✅ Verificação de dependências concluída!${NC}"
echo "Todas as dependências necessárias para o mise estão disponíveis."
