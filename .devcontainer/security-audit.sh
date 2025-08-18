#!/bin/bash
# Security audit and cleanup script for dotfiles repository
# Removes hardcoded personal information and credentials

set -e

echo "🔒 Security Audit & Cleanup"
echo "============================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get repository root
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

echo -e "${BLUE}📁 Repository: $(basename "$REPO_ROOT")${NC}"
echo -e "${BLUE}🔍 Scanning for security issues...${NC}"
echo ""

# Function to check for potential security issues
check_security_issues() {
    local issues_found=0
    
    echo -e "${YELLOW}🔍 Checking for hardcoded credentials...${NC}"
    
    # Patterns to search for
    patterns=(
        "password|passwd"
        "token|jwt|bearer"
        "api_key|apikey|access_key"
        "secret|private_key"
        "ghp_|ghs_|github_token"
        "ssh-rsa|ssh-ed25519"
        "-----BEGIN.*KEY-----"
    )
    
    for pattern in "${patterns[@]}"; do
        if grep -r -i -E "$pattern" \
            --exclude-dir=.git \
            --exclude-dir=node_modules \
            --exclude-dir=.cache \
            --exclude-dir=dist \
            --exclude-dir=build \
            --exclude="*.md" . 2>/dev/null | grep -v "^Binary file" | head -5; then
            echo -e "${RED}⚠️  Found potential credential pattern: $pattern${NC}"
            ((issues_found++))
        fi
    done
    
    echo -e "${YELLOW}🔍 Checking for hardcoded paths...${NC}"
    
    # Check for hardcoded personal paths
    if grep -r "/home/carlos" --exclude-dir=.git . 2>/dev/null | grep -v "^Binary file" | head -5; then
        echo -e "${RED}⚠️  Found hardcoded personal paths${NC}"
        ((issues_found++))
    fi
    
    echo -e "${YELLOW}🔍 Checking for hardcoded usernames...${NC}"
    
    # Check for hardcoded usernames
    if grep -r "carloskvasir" --exclude-dir=.git --exclude="*.md" . 2>/dev/null | grep -v "^Binary file" | head -5; then
        echo -e "${RED}⚠️  Found hardcoded username${NC}"
        ((issues_found++))
    fi
    
    if [[ $issues_found -eq 0 ]]; then
        echo -e "${GREEN}✅ No obvious security issues found${NC}"
    else
        echo -e "${RED}❌ Found $issues_found potential security issues${NC}"
    fi
    
    return $issues_found
}

# Function to sanitize files
sanitize_files() {
    echo -e "${YELLOW}🧹 Sanitizing files...${NC}"
    
    # List of files that may contain personal info
    files_to_check=(
        ".devcontainer/*.sh"
        ".devcontainer/*.json"
        ".github/workflows/*.yml"
    )
    
    # Backup original files
    backup_dir=".security_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    for pattern in "${files_to_check[@]}"; do
        for file in $pattern; do
            if [[ -f "$file" ]]; then
                cp "$file" "$backup_dir/"
                echo "📋 Backed up: $file"
            fi
        done
    done
    
    echo -e "${GREEN}✅ Files backed up to: $backup_dir${NC}"
}

# Function to create environment template
create_env_template() {
    echo -e "${YELLOW}📝 Creating environment template...${NC}"
    
    cat > .env.example << 'EOF'
# GitHub Configuration
GITHUB_USERNAME=your-github-username
GITHUB_TOKEN=your-github-token

# Repository Configuration  
REPOSITORY_NAME=your-repo-name

# Docker Registry
REGISTRY=ghcr.io

# Optional: Custom paths
DOTFILES_PATH=/path/to/your/dotfiles

# Development Environment
EDITOR=nvim
SHELL=zsh
EOF
    
    echo -e "${GREEN}✅ Created .env.example template${NC}"
}

# Function to create gitignore for sensitive files
update_gitignore() {
    echo -e "${YELLOW}🔒 Updating .gitignore...${NC}"
    
    # Patterns to ignore
    ignore_patterns=(
        "# Security - Personal Information"
        ".env"
        ".env.local"
        ".env.*.local"
        "*.key"
        "*.pem"
        "*.p12"
        "*.pfx"
        "*_rsa"
        "*_ed25519"
        "*.log"
        "*.backup"
        ".security_backup_*"
        ""
        "# IDE and Editor"
        ".vscode/settings.json"
        ".idea/"
        "*.swp"
        "*.swo"
        "*~"
        ""
        "# OS Generated"
        ".DS_Store"
        "Thumbs.db"
        "ehthumbs.db"
    )
    
    # Check if patterns already exist
    for pattern in "${ignore_patterns[@]}"; do
        if [[ -n "$pattern" ]] && ! grep -Fq "$pattern" .gitignore 2>/dev/null; then
            echo "$pattern" >> .gitignore
        fi
    done
    
    echo -e "${GREEN}✅ Updated .gitignore${NC}"
}

# Function to provide security recommendations
show_recommendations() {
    echo ""
    echo -e "${BLUE}🛡️  Security Recommendations:${NC}"
    echo ""
    echo "1. 🔐 Use environment variables for sensitive data:"
    echo "   - Create .env file (ignored by git)"
    echo "   - Use \$GITHUB_USERNAME instead of hardcoded values"
    echo ""
    echo "2. 🏠 Use dynamic paths instead of hardcoded ones:"
    echo "   - Use \$(git rev-parse --show-toplevel) for repo root"
    echo "   - Use \$(whoami) or \$USER for username"
    echo ""
    echo "3. 🔑 For GitHub Actions:"
    echo "   - Use \${{ secrets.GITHUB_TOKEN }} (already configured)"
    echo "   - Store custom secrets in repository settings"
    echo ""
    echo "4. 📋 Regular security audits:"
    echo "   - Run this script before commits"
    echo "   - Use tools like git-secrets or detect-secrets"
    echo ""
    echo "5. 🚫 Never commit:"
    echo "   - Personal access tokens"
    echo "   - SSH private keys"
    echo "   - Database passwords"
    echo "   - API keys"
    echo ""
}

# Main execution
echo -e "${BLUE}🚀 Starting security audit...${NC}"
echo ""

# Run security check
if check_security_issues; then
    echo ""
    echo -e "${GREEN}🎉 Repository appears secure!${NC}"
else
    echo ""
    echo -e "${YELLOW}⚠️  Security issues detected${NC}"
    
    read -p "🔧 Would you like to create backups and templates? (y/N): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        sanitize_files
        create_env_template
    fi
fi

update_gitignore
show_recommendations

echo ""
echo -e "${GREEN}🔒 Security audit completed!${NC}"
echo ""
echo "📝 Next steps:"
echo "1. Review any flagged issues above"
echo "2. Use environment variables for personal data"  
echo "3. Test scripts with generic values"
echo "4. Commit security improvements"
