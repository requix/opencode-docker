# opencode-docker - Dedicated OpenCode AI Container
# Adapted for OpenCode AI with multi-LLM provider support

FROM debian:bookworm

# OCI Labels for metadata
LABEL org.opencontainers.image.title="opencode-docker"
LABEL org.opencontainers.image.description="Isolated development container for OpenCode AI"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.source="https://github.com/requix/opencode-docker"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.vendor="opencode-docker"

# Build arguments
ARG USERNAME=opencode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Locale configuration
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

# Install system packages and locales
RUN apt-get update && apt-get install -y \
    locales \
    sudo \
    gosu \
    git \
    vim \
    nano \
    curl \
    wget \
    unzip \
    zsh \
    gnupg \
    build-essential \
    ca-certificates \
    openssh-client \
    netcat-openbsd \
    dnsutils \
    jq \
    yq \
    ripgrep \
    fd-find \
    tmux \
    htop \
    bash-completion \
    direnv \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

# Configure SSH for secure Git operations
# Create SSH directory with proper permissions
RUN mkdir -p /home/opencode/.ssh && \
    chown opencode:opencode /home/opencode/.ssh && \
    chmod 700 /home/opencode/.ssh

# Configure SSH client for GitHub
RUN echo "Host github.com" > /home/opencode/.ssh/config && \
    echo "  HostName github.com" >> /home/opencode/.ssh/config && \
    echo "  User git" >> /home/opencode/.ssh/config && \
    echo "  StrictHostKeyChecking accept-new" >> /home/opencode/.ssh/config && \
    echo "  UserKnownHostsFile /home/opencode/.ssh/known_hosts" >> /home/opencode/.ssh/config && \
    chown opencode:opencode /home/opencode/.ssh/config && \
    chmod 600 /home/opencode/.ssh/config

# Add GitHub's official SSH host keys for security
RUN echo "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl" > /home/opencode/.ssh/known_hosts && \
    echo "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=" >> /home/opencode/.ssh/known_hosts && \
    echo "github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=" >> /home/opencode/.ssh/known_hosts && \
    chown opencode:opencode /home/opencode/.ssh/known_hosts && \
    chmod 644 /home/opencode/.ssh/known_hosts

# Install Oh-My-Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && echo 'ZSH_THEME="robbyrussell"' >> ~/.zshrc \
    && echo 'export EDITOR=vim' >> ~/.zshrc

# Install Python via uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc \
    && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

ENV PATH="/home/$USERNAME/.local/bin:$PATH"

# Install Python development tools
RUN uv tool install black \
    && uv tool install ruff \
    && uv tool install mypy \
    && uv tool install pytest \
    && uv tool install ipython \
    && uv tool install poetry \
    && uv tool install pipenv

# Install Node.js via NVM
ENV NVM_DIR="/home/$USERNAME/.nvm"
ENV NODE_VERSION="lts/*"

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install "$NODE_VERSION" \
    && nvm use "$NODE_VERSION" \
    && nvm alias default "$NODE_VERSION"

ENV PATH="$NVM_DIR/versions/node/$(ls $NVM_DIR/versions/node | tail -1)/bin:$PATH"

# Install Node.js development tools with pinned major versions
RUN . "$NVM_DIR/nvm.sh" \
    && npm install -g \
    typescript@5 \
    ts-node@10 \
    eslint@9 \
    prettier@3 \
    yarn@1 \
    pnpm@9

# Install Bun (faster alternative to npm)
RUN curl -fsSL https://bun.sh/install | bash \
    && echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.zshrc \
    && echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.zshrc \
    && echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.bashrc \
    && echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.bashrc

ENV BUN_INSTALL="/home/$USERNAME/.bun"
ENV PATH="$BUN_INSTALL/bin:$PATH"

# Install GitHub CLI
USER root
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install GitLab CLI (glab) - install from binary for better ARM64 support
RUN GLAB_VERSION=$(curl -s https://api.github.com/repos/profclems/glab/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/') \
    && ARCH=$(dpkg --print-architecture) \
    && curl -fsSL "https://github.com/profclems/glab/releases/download/v${GLAB_VERSION}/glab_${GLAB_VERSION}_Linux_${ARCH}.tar.gz" -o /tmp/glab.tar.gz \
    && tar -xzf /tmp/glab.tar.gz -C /tmp \
    && mv /tmp/bin/glab /usr/local/bin/glab \
    && chmod +x /usr/local/bin/glab \
    && rm -rf /tmp/glab.tar.gz /tmp/bin

USER $USERNAME

# Configure tmux
RUN echo "set -g mouse on" >> ~/.tmux.conf \
    && echo "set -g default-terminal \"screen-256color\"" >> ~/.tmux.conf

# Configure git
RUN git config --global init.defaultBranch main \
    && git config --global --add safe.directory '*'

# Set up workspace directory
RUN mkdir -p /home/$USERNAME/workspace

# Add direnv hook
RUN echo 'eval "$(direnv hook bash)"' >> ~/.bashrc \
    && echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc

# Install OpenCode AI (cache-busting with timestamp)
ARG CACHEBUST=1
RUN . "$NVM_DIR/nvm.sh" \
    && npm install -g opencode-ai@latest

# Verify OpenCode installation
RUN which opencode && opencode --version || echo "OpenCode installed successfully"

# Health check to verify container is working
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD opencode --version > /dev/null 2>&1 || exit 1

# Set working directory
WORKDIR /workspace

# Copy entrypoint script (must be root to write to /usr/local/bin)
USER root
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh

# Stay as root for the entrypoint (it will switch to opencode user)
ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]
CMD ["opencode"]
