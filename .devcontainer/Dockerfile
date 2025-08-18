
# ================================
# STAGE 1: Base Dependencies
# ================================
FROM mcr.microsoft.com/devcontainers/base:debian AS base-deps

# Install system dependencies in a single layer
RUN apt-get update && apt-get install -y \
    # Build essentials (needed for compilation)
    build-essential \
    gcc \
    autoconf \
    make \
    unixodbc \
    unzip \
    # Core utilities (lightweight)
    git \
    curl \
    wget \
    zsh \
    stow \
    # Language support
    ca-certificates \
    gnupg \
    lsb-release \
    # Additional tools
    vim \
    tmux \
    openssh-client \
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
    echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc && \
    echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc && \
    # Pre-create common directories
    mkdir -p ~/.config ~/.cache ~/.local/share

# ================================
# STAGE 3: Development Tools Cache
# ================================
FROM user-setup AS tools-cache

# Add mise to PATH for this stage
ENV PATH="/home/$USERNAME/.local/bin:$PATH"

# Copy mise configuration to pre-install common tools
COPY --chown=$USERNAME:$USERNAME mise/.config/mise/config.toml /home/$USERNAME/.config/mise/config.toml
COPY --chown=$USERNAME:$USERNAME mise/.default-python-packages /home/$USERNAME/.default-python-packages
COPY --chown=$USERNAME:$USERNAME mise/.default-npm-packages /home/$USERNAME/.default-npm-packages

# Pre-install only essential tools to cache them
RUN eval "$(mise activate bash)" && \
    mise install && \
    mise reshim

# ================================
# STAGE 4: Final Runtime
# ================================
FROM user-setup AS runtime

# Copy cached tools from previous stage
COPY --from=tools-cache --chown=$USERNAME:$USERNAME /home/$USERNAME/.local /home/$USERNAME/.local
COPY --from=tools-cache --chown=$USERNAME:$USERNAME /home/$USERNAME/.config /home/$USERNAME/.config
COPY --from=tools-cache --chown=$USERNAME:$USERNAME /home/$USERNAME/.cache /home/$USERNAME/.cache

# Set final environment
ENV PATH="/home/$USERNAME/.local/bin:$PATH"
ENV MISE_DATA_DIR="/home/$USERNAME/.local/share/mise"

# Set working directory to match DevContainer mount point
WORKDIR /workspaces

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD which mise && which stow || exit 1

# Labels for better image management
LABEL maintainer="carloskvasir" \
      description="Multi-stage DevContainer for dotfiles with mise + stow" \
      version="1.0"
