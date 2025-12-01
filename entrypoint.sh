#!/bin/bash
# opencode-docker Entrypoint Script

set -e

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
        echo "✓ SSH agent forwarding active"
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

# Execute the command passed to the container
exec "$@"
