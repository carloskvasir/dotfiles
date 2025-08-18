
# ================================
# STAGE 1: Base Dependencies
# ================================
FROM mcr.microsoft.com/devcontainers/base:debian AS base-deps

# Install system dependencies in a single layer
RUN apt-get update && apt-get install -y \
    # Essential shells and tools (mise requirements)
    bash \
    zsh \
    # File utilities and compression
    grep \
    wget \
    curl \
    tar \
    bzip2 \
    xz-utils \
    # Hash utilities
    coreutils \
    # Patch utilities
    patch \
    # Build essentials (mise compilation requirements)
    build-essential \
    gcc \
    clang \
    autoconf \
    make \
    # Development utilities
    git \
    stow \
    unzip \
    # System utilities
    ca-certificates \
    gnupg \
    lsb-release \
    # Cleanup in same layer to reduce size
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/*

# ================================
# STAGE 2: User Setup & Mise
# ================================
FROM base-deps AS user-setup

# Create vscode user efficiently
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# User creation in single RUN to reduce layers
RUN if ! getent passwd $USER_UID; then \
        groupadd --gid $USER_GID $USERNAME && \
        useradd --uid $USER_UID --gid $USER_GID -m -s /bin/zsh $USERNAME && \
        echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
        chmod 0440 /etc/sudoers.d/$USERNAME; \
    fi

# Switch to user and install mise
USER $USERNAME
WORKDIR /home/$USERNAME

# Install mise and configure shells in single layer
RUN curl -fsSL https://mise.run | sh && \
    echo 'eval "$($HOME/.local/bin/mise activate bash)"' >> ~/.bashrc && \
    echo 'eval "$($HOME/.local/bin/mise activate zsh)"' >> ~/.zshrc && \
    # Pre-create common directories
    mkdir -p ~/.config ~/.cache ~/.local/share

# ================================
# STAGE 3: Development Tools Cache
# ================================
FROM user-setup AS tools-cache

# Add mise to PATH for this stage
ENV PATH="/home/$USERNAME/.local/bin:$PATH"

# Copy mise configuration to pre-install common tools
COPY --chown=vscode:vscode mise/.config/mise/config.toml /home/vscode/.config/mise/config.toml
COPY --chown=vscode:vscode mise/.default-python-packages /home/vscode/.default-python-packages
COPY --chown=vscode:vscode mise/.default-npm-packages /home/vscode/.default-npm-packages

# Pre-install only essential tools to cache them - Using external script for retry logic
COPY --chown=vscode:vscode .devcontainer/install-mise-tools.sh /home/vscode/install-mise-tools.sh
RUN chmod +x /home/vscode/install-mise-tools.sh && /home/vscode/install-mise-tools.sh

# ================================
# STAGE 4: Final Runtime
# ================================
FROM user-setup AS runtime

# Copy cached tools from previous stage
COPY --from=tools-cache --chown=vscode:vscode /home/vscode/.local /home/vscode/.local
COPY --from=tools-cache --chown=vscode:vscode /home/vscode/.config /home/vscode/.config
COPY --from=tools-cache --chown=vscode:vscode /home/vscode/.cache /home/vscode/.cache

# Set final environment variables
ENV PATH="/home/vscode/.local/bin:/home/vscode/.local/share/mise/shims:$PATH"
ENV MISE_DATA_DIR="/home/vscode/.local/share/mise"
ENV SHELL=/bin/zsh

# Copy test script
COPY --chown=vscode:vscode .devcontainer/test-zsh-mise.sh /home/vscode/test-zsh-mise.sh
RUN chmod +x /home/vscode/test-zsh-mise.sh

# Set working directory to match DevContainer mount point
WORKDIR /workspaces

# Add comprehensive health check for mise requirements
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD /bin/bash -c ' \
        # Check shell versions \
        bash_version=$(bash --version | head -1 | grep -o "[0-9]\+\.[0-9]\+") && \
        # Check core utilities \
        which grep wget curl tar bzip2 xz patch gcc clang && \
        # Check hash utilities (from coreutils) \
        which md5sum sha1sum sha256sum sha512sum && \
        # Check mise and stow \
        which mise stow && \
        # Verify bash version >= 3.x \
        [[ ${bash_version%%.*} -ge 3 ]] && \
        echo "All dependencies verified successfully" \
    ' || exit 1

# Labels for better image management
LABEL maintainer="carloskvasir" \
      description="ZSH-optimized DevContainer with complete mise requirements" \
      version="2.0" \
      requirements="bash>=3.x,grep,wget,curl,tar,bzip2,xz,patch,gcc,clang,coreutils" \
      shell="zsh"

# Default command
CMD ["/bin/zsh"]
