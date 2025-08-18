#!/bin/bash
# Script de validação completa do config.toml do mise

set -e

echo "🔍 Validação do config.toml do mise"
echo "=================================="

CONFIG_FILE="/home/carlos/.dotfiles/mise/.config/mise/config.toml"

# Verificar se o arquivo existe
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "❌ Arquivo config.toml não encontrado: $CONFIG_FILE"
    exit 1
fi

echo "✅ Arquivo config.toml encontrado"

# Verificar sintaxe básica
echo ""
echo "🔧 Verificando sintaxe básica..."

# Verificar se há linhas problemáticas
problematic_lines=()

while IFS= read -r line_num; do
    line_content=$(sed -n "${line_num}p" "$CONFIG_FILE")
    echo "⚠️  Linha $line_num: $line_content"
    problematic_lines+=("$line_num")
done < <(grep -n "http_timeout\|disable_tools" "$CONFIG_FILE" | cut -d: -f1)

if [[ ${#problematic_lines[@]} -gt 0 ]]; then
    echo "❌ Configurações problemáticas encontradas (configurações inválidas do mise)"
else
    echo "✅ Nenhuma configuração problemática encontrada"
fi

# Verificar consistência
echo ""
echo "🔍 Verificando consistência..."

# Verificar se Ruby está habilitado mas tools desabilitadas
if grep -q "ruby" "$CONFIG_FILE" | grep -v "^#"; then
    if grep -q "# ruby.*Desabilitado" "$CONFIG_FILE"; then
        echo "⚠️  Inconsistência: Ruby referenciado em settings mas desabilitado em tools"
    fi
fi

# Verificar ferramentas ativas
echo ""
echo "📋 Ferramentas ativas:"
grep -E "^[a-z].*=.*" "$CONFIG_FILE" | grep -v "experimental\|legacy\|pin\|always\|paranoid\|jobs" | while read line; do
    tool=$(echo "$line" | cut -d'=' -f1 | xargs)
    version=$(echo "$line" | cut -d'=' -f2 | tr -d '"' | xargs)
    echo "  ✓ $tool: $version"
done

# Verificar se mise pode interpretar o arquivo
echo ""
echo "🧪 Testando interpretação pelo mise..."

if command -v mise >/dev/null 2>&1; then
    # Usar mise em modo dry-run se possível
    export MISE_CONFIG_FILE="$CONFIG_FILE"
    if mise config 2>/dev/null | grep -q "tools\|settings"; then
        echo "✅ mise consegue interpretar o arquivo"
    else
        echo "⚠️  mise pode ter problemas para interpretar o arquivo"
    fi
else
    echo "⚠️  mise não está instalado no sistema host"
fi

echo ""
echo "📊 Resumo da validação:"
echo "  • Arquivo: $CONFIG_FILE"
echo "  • Sintaxe: $([ ${#problematic_lines[@]} -eq 0 ] && echo "✅ OK" || echo "❌ Problemas encontrados")"
echo "  • Ferramentas ativas: $(grep -cE "^[a-z].*=.*" "$CONFIG_FILE" | grep -v "experimental\|legacy\|pin\|always\|paranoid\|jobs" || echo "0")"

if [[ ${#problematic_lines[@]} -eq 0 ]]; then
    echo ""
    echo "🎉 Configuração está válida para uso!"
    exit 0
else
    echo ""
    echo "🔧 Correções necessárias nas linhas: ${problematic_lines[*]}"
    exit 1
fi
