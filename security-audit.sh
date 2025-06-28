#!/bin/bash

# 🔒 Security Audit Script for Dotfiles
# Verifica se há informações sensíveis expostas no repositório

echo "🔒 Executando auditoria de segurança dos dotfiles..."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

CRITICAL_FOUND=false
WARNING_FOUND=false

# Function to check for sensitive patterns
check_pattern() {
    local pattern="$1"
    local description="$2"
    local severity="$3"
    
    echo -e "\n${BLUE}🔍 Verificando: $description${NC}"
    
    # Search for pattern excluding .git directory and binary files
    results=$(git grep -l "$pattern" 2>/dev/null | grep -v ".git/" | head -10)
    
    if [[ -n "$results" ]]; then
        if [[ "$severity" == "CRITICAL" ]]; then
            echo -e "${RED}🚨 CRÍTICO: Padrão encontrado!${NC}"
            CRITICAL_FOUND=true
        else
            echo -e "${YELLOW}⚠️  AVISO: Padrão encontrado!${NC}"
            WARNING_FOUND=true
        fi
        
        while IFS= read -r file; do
            if [[ -n "$file" ]]; then
                echo -e "  📄 $file"
                # Show line with context
                git grep -n "$pattern" "$file" 2>/dev/null | head -3 | while IFS=: read -r line_num content; do
                    echo -e "    Linha $line_num: ${content:0:80}..."
                done
            fi
        done <<< "$results"
    else
        echo -e "${GREEN}✓ Nenhum padrão encontrado${NC}"
    fi
}

# Function to check if file exists and is tracked
check_sensitive_file() {
    local file="$1"
    local description="$2"
    
    echo -e "\n${BLUE}🔍 Verificando arquivo: $description${NC}"
    
    if [[ -f "$file" ]]; then
        if git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
            echo -e "${RED}🚨 CRÍTICO: Arquivo sensível está sendo rastreado pelo Git!${NC}"
            echo -e "  📄 $file"
            CRITICAL_FOUND=true
        else
            echo -e "${GREEN}✓ Arquivo existe mas não está sendo rastreado${NC}"
        fi
    else
        echo -e "${GREEN}✓ Arquivo não encontrado${NC}"
    fi
}

echo -e "${BLUE}=== VERIFICAÇÃO DE PADRÕES SENSÍVEIS ===${NC}"

# Check for IP addresses
check_pattern '\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\b' "Endereços IP" "CRITICAL"

# Check for SSH key patterns
check_pattern 'BEGIN.*PRIVATE KEY' "Chaves SSH privadas" "CRITICAL"
check_pattern 'ssh-rsa|ssh-ed25519|ssh-ecdsa' "Chaves SSH públicas" "WARNING"

# Check for passwords and secrets
check_pattern 'password.*=' "Senhas em configurações" "CRITICAL"
check_pattern 'secret.*=' "Secrets em configurações" "CRITICAL"
check_pattern 'token.*=' "Tokens de API" "CRITICAL"
check_pattern 'api.*key' "API Keys" "CRITICAL"

# Check for email addresses (excluding examples)
check_pattern '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' "Endereços de email" "WARNING"

# Check for hostnames and server names
check_pattern 'HostName.*[0-9]' "Hostnames com IPs" "CRITICAL"
check_pattern 'User.*root|User.*admin' "Usuários privilegiados" "WARNING"

echo -e "\n${BLUE}=== VERIFICAÇÃO DE ARQUIVOS SENSÍVEIS ===${NC}"

# Check for SSH config files
check_sensitive_file "ssh/.ssh/config" "Configuração SSH"
check_sensitive_file "ssh/.ssh/known_hosts" "Known hosts SSH"
check_sensitive_file "ssh/.ssh/authorized_keys" "Authorized keys SSH"

# Check for private keys
for key_file in ssh/.ssh/id_* ssh/.ssh/*_rsa ssh/.ssh/*_ed25519; do
    if [[ -f "$key_file" && ! "$key_file" =~ \.pub$ ]]; then
        check_sensitive_file "$key_file" "Chave SSH privada"
    fi
done

# Check for personal git config
check_sensitive_file "gitconfig/.gitconfig" "Configuração Git pessoal"

echo -e "\n${BLUE}=== VERIFICAÇÃO DE .GITIGNORE ===${NC}"

# Check if sensitive files are properly ignored
sensitive_files=(
    "ssh/.ssh/config"
    "ssh/.ssh/known_hosts"
    "ssh/.ssh/id_rsa"
    "gitconfig/.gitconfig"
)

for file in "${sensitive_files[@]}"; do
    if git check-ignore "$file" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ $file está sendo ignorado${NC}"
    else
        echo -e "${YELLOW}⚠️  $file NÃO está sendo ignorado${NC}"
        WARNING_FOUND=true
    fi
done

echo -e "\n${BLUE}=== VERIFICAÇÃO DE HISTÓRICO GIT ===${NC}"

# Check if sensitive files were ever committed
echo -e "🔍 Verificando histórico do Git para arquivos sensíveis..."

for file in "${sensitive_files[@]}"; do
    if git log --all --full-history -- "$file" | head -1 | grep -q "commit"; then
        echo -e "${RED}🚨 CRÍTICO: $file foi commitado no passado!${NC}"
        echo -e "  Use: git filter-branch ou BFG Repo-Cleaner para remover"
        CRITICAL_FOUND=true
    fi
done

echo -e "\n${BLUE}=== VERIFICAÇÃO DE CONFIGURAÇÃO ===${NC}"

# Check if templates exist
if [[ -f "ssh/.ssh/config.template" ]]; then
    echo -e "${GREEN}✓ Template SSH existe${NC}"
else
    echo -e "${YELLOW}⚠️  Template SSH não encontrado${NC}"
fi

if [[ -f "gitconfig/.gitconfig.template" ]]; then
    echo -e "${GREEN}✓ Template Git existe${NC}"
else
    echo -e "${YELLOW}⚠️  Template Git não encontrado${NC}"
fi

echo -e "\n${BLUE}=== RESUMO DA AUDITORIA ===${NC}"

if [[ "$CRITICAL_FOUND" == true ]]; then
    echo -e "${RED}🚨 PROBLEMAS CRÍTICOS ENCONTRADOS!${NC}"
    echo -e "  Ação necessária IMEDIATAMENTE:"
    echo -e "  1. Remover arquivos sensíveis do controle de versão"
    echo -e "  2. Adicionar ao .gitignore"
    echo -e "  3. Limpar histórico do Git se necessário"
    echo -e "  4. Trocar chaves/senhas expostas"
    exit 1
elif [[ "$WARNING_FOUND" == true ]]; then
    echo -e "${YELLOW}⚠️  Avisos encontrados${NC}"
    echo -e "  Revise os itens acima e considere as correções"
    exit 2
else
    echo -e "${GREEN}✅ Nenhum problema de segurança encontrado!${NC}"
    echo -e "  Repositório parece seguro para commit"
    exit 0
fi
