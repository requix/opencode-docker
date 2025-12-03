#!/bin/bash
# opencode-docker Entrypoint Script

set -e

# If running as root, fix permissions and switch to opencode user
if [ "$(id -u)" = "0" ]; then
    # Fix SSH agent socket permissions if it exists
    if [ -n "$SSH_AUTH_SOCK" ] && [ -S "$SSH_AUTH_SOCK" ]; then
        chmod 660 "$SSH_AUTH_SOCK" 2>/dev/null || true
        chown opencode:opencode "$SSH_AUTH_SOCK" 2>/dev/null || true
    fi
    
    # Switch to opencode user and re-execute this script
    exec gosu opencode "$0" "$@"
fi

# Now running as opencode user - continue with normal entrypoint logic

# Handle terminal size for proper TTY support
if [ -t 0 ]; then
    resize >/dev/null 2>&1 || true
fi

# Copy gitconfig if it exists and hasn't been copied yet
if [ -f /tmp/.gitconfig ] && [ ! -f ~/.gitconfig ]; then
    cp /tmp/.gitconfig ~/.gitconfig
fi

# Copy OpenCode configuration from host if container config is empty
if [ -d "/tmp/host-opencode-config" ]; then
    if [ ! -f ~/.config/opencode/config.json ]; then
        echo "Copying OpenCode configuration from host..."
        mkdir -p ~/.config/opencode
        cp -r /tmp/host-opencode-config/* ~/.config/opencode/ 2>/dev/null || true
        echo "✓ OpenCode configuration copied"
    fi
fi

if [ -d "/tmp/host-opencode-share" ]; then
    if [ ! -d ~/.local/share/opencode ] || [ -z "$(ls -A ~/.local/share/opencode 2>/dev/null)" ]; then
        echo "Copying OpenCode shared data from host..."
        mkdir -p ~/.local/share/opencode
        cp -r /tmp/host-opencode-share/* ~/.local/share/opencode/ 2>/dev/null || true
        echo "✓ OpenCode shared data copied"
    fi
fi

# Verify SSH agent forwarding
if [ -n "$SSH_AUTH_SOCK" ]; then
    if [ -S "$SSH_AUTH_SOCK" ]; then
        # Test if we can actually use it
        if ssh-add -l >/dev/null 2>&1 || [ $? -eq 1 ]; then
            echo "✓ SSH agent forwarding active"
        else
            echo "⚠ SSH agent socket exists but cannot connect"
        fi
    else
        echo "⚠ SSH_AUTH_SOCK set but socket not found"
    fi
fi

# Initialize OpenCode config directory if it doesn't exist
if [ ! -d ~/.config/opencode ]; then
    mkdir -p ~/.config/opencode
fi

# Link project-level OpenCode config if it exists
if [ -f /workspace/.opencode/opencode.json ] && [ ! -L ~/.config/opencode/opencode.json ]; then
    ln -sf /workspace/.opencode/opencode.json ~/.config/opencode/opencode.json
fi

# Source NVM for Node.js
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Add Bun to PATH
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Add uv to PATH
export PATH="$HOME/.local/bin:$PATH"

# Configure git to use tokens if provided
if [ -n "$GITHUB_TOKEN" ]; then
    git config --global url."https://${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/"
    echo "✓ Git configured to use GitHub token for HTTPS"
fi

if [ -n "$GITLAB_TOKEN" ]; then
    git config --global url."https://oauth2:${GITLAB_TOKEN}@gitlab.com/".insteadOf "https://gitlab.com/"
    echo "✓ Git configured to use GitLab token for HTTPS"
fi

# Execute the command passed to the container
exec "$@"
