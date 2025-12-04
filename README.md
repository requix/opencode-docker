# opencode-docker

<div align="center">

**Isolated, secure containerized environment for [OpenCode AI](https://opencode.ai)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=flat&logo=docker&logoColor=white)](https://www.docker.com/)
[![OpenCode](https://img.shields.io/badge/OpenCode-AI-blue)](https://opencode.ai)

[Features](#-features) •
[Quick Start](#-quick-start) •
[Installation](#-installation) •
[Usage](#-usage) •
[Documentation](#-documentation)

</div>

---

## 🎯 What is opencode-docker?

opencode-docker provides a dedicated, secure Docker container for running [OpenCode AI](https://opencode.ai) - an open-source AI coding assistant that helps you write, review, and refactor code directly from your terminal.

### About OpenCode AI

**OpenCode** is a CLI-based AI coding assistant that:
- 🤖 Writes and modifies code based on natural language instructions
- � Undaerstands your entire codebase context
- 💬 Supports multiple LLM providers (OpenAI, Anthropic, Google, local models)
- 🌐 Works with any programming language and framework
- 🔓 Fully open-source and self-hostable

**Why use OpenCode?**
- No vendor lock-in (works with any LLM provider)
- Privacy-focused (can run with local models)
- Terminal-native workflow (no IDE required)
- Free and open-source

---

## ✨ Features

### Security Hardening

- **Capability Restrictions**: Drops all capabilities, adds only essential ones
- **No Privilege Escalation**: Runs with `no-new-privileges` security option
- **Non-Root User**: Everything runs as unprivileged `opencode` user
- **SSH Agent Forwarding**: Never copies SSH keys into container
- **Input Validation**: Prevents mounting dangerous system directories

### User Experience

- **One-Command Launch**: `./opencode-docker` to start
- **Configuration Persistence**: OpenCode settings inherited from host
- **GitHub Pre-configured**: No "unknown host" prompts for GitHub/GitLab
- **Shell History**: Command history persists between sessions
- **Custom Directory Mounting**: Mount any directory into container

### Development Environment

- **Python Tools**: uv, black, ruff, mypy, pytest, ipython, poetry
- **Node.js Tools**: Latest LTS via NVM, TypeScript, eslint, prettier
- **Bun Runtime**: Fast JavaScript runtime and package manager
- **Git Integrations**: GitHub CLI (`gh`) and GitLab CLI (`glab`)
- **Shell Enhancements**: Zsh with Oh-My-Zsh, tmux, vim, nano

---

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/requix/opencode-docker.git
cd opencode-docker

# Start OpenCode in current directory
./opencode-docker

# That's it! OpenCode AI is now running in a secure container
```

---

## 📦 Installation

### Prerequisites

- **Docker**: [Install Docker](https://docs.docker.com/get-docker/) (version 20.10 or later)
- **Linux/macOS**: Tested on Linux and macOS (Windows via WSL2)
- **Disk Space**: ~2GB for Docker image
- **Architecture**: x86_64/amd64 and ARM64 (Apple Silicon) supported

### Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/requix/opencode-docker.git
   cd opencode-docker
   ```

2. **Make the script executable** (if needed):
   ```bash
   chmod +x opencode-docker
   ```

3. **First run** (builds the Docker image):
   ```bash
   ./opencode-docker
   # First build takes 5-10 minutes
   # Subsequent runs are instant
   ```

4. **(Optional) Add to PATH**:
   ```bash
   sudo ln -s $(pwd)/opencode-docker /usr/local/bin/opencode-docker
   # Now you can run `opencode-docker` from anywhere
   ```

---

## 🔐 Git Authentication

OpenCode AI can make commits and push code. Choose your authentication method:

### Option 1: GitHub Token (Recommended)

Most secure - gives AI only the permissions it needs.

```bash
# 1. Create token at: https://github.com/settings/tokens?type=beta
#    Set permissions: Contents (R/W), Pull Requests (R/W), Issues (R/W)
#    Expiration: 90 days

# 2. Export and run:
export GITHUB_TOKEN=ghp_your_token_here
./opencode-docker
```

### Option 2: Dedicated SSH Key

Good balance of security and convenience.

```bash
# 1. Generate and add to GitHub:
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_opencode_ai -C "opencode-ai"
cat ~/.ssh/id_ed25519_opencode_ai.pub  # Add at github.com/settings/keys

# 2. Load and run:
ssh-add ~/.ssh/id_ed25519_opencode_ai
./opencode-docker
```

### Option 3: Personal SSH Key

⚠️ **Not recommended** - gives AI full access to all your repositories.

```bash
ssh-add ~/.ssh/id_ed25519
./opencode-docker
```

**Why dedicated credentials?** If AI is compromised, you can revoke its access without affecting yours. See [SECURITY.md](SECURITY.md) for details.

---

## 💻 Usage

### Basic Commands

```bash
# Start OpenCode AI (default)
./opencode-docker

# Open bash shell in container
./opencode-docker shell

# Open zsh shell in container
./opencode-docker zsh

# Check version
./opencode-docker version

# Force rebuild the image
./opencode-docker rebuild

# Clean up all data
./opencode-docker clean
```

### Advanced Usage

#### Mount Additional Directories

```bash
# Mount one directory
./opencode-docker --add-dir ~/my-workspace
# Available inside container as: /mnt/my-workspace

# Mount multiple directories
./opencode-docker --add-dir ~/docs --add-dir ~/scripts
# Available as: /mnt/docs and /mnt/scripts
```

#### SSH Agent Forwarding

For accessing private repositories, you need to add your SSH key to the agent on your **host machine** first:

```bash
# On your host (macOS/Linux), add your SSH key:
ssh-add ~/.ssh/id_ed25519  # or ~/.ssh/id_rsa

# Verify it was added:
ssh-add -l

# SSH agent will be automatically forwarded to container
./opencode-docker

# Inside container, test GitHub access:
ssh -T git@github.com
# Should see: "Hi username! You've successfully authenticated..."
```

**Troubleshooting SSH:**
```bash
# If you get "Permission denied (publickey)" inside container:

# 1. Check if key is added on HOST:
ssh-add -l  # Run this on your Mac, not in container

# 2. If "The agent has no identities", add your key:
ssh-add ~/.ssh/id_ed25519

# 3. Test on host first:
ssh -T git@github.com  # Should work on host

# 4. Then test in container:
./opencode-docker shell
ssh -T git@github.com  # Should now work in container too
```

#### Custom Commands

```bash
# Run specific OpenCode command
./opencode-docker opencode --help

# Execute any command in container
./opencode-docker python --version
./opencode-docker node --version
```

---

## 🔧 Configuration

### Environment Variables

```bash
# Git authentication (recommended for AI agents)
export GITHUB_TOKEN=ghp_your_token_here
export GITLAB_TOKEN=glpat_your_token_here

# Change config directory
export OPENCODE_DOCKER_CONFIG_DIR=~/.my-opencode-docker-config

# Change cache directory
export OPENCODE_DOCKER_CACHE_DIR=~/.my-cache

# Then run opencode-docker
./opencode-docker
```

### OpenCode Configuration

OpenCode configuration is automatically inherited from your host:

- Host config: `~/.config/opencode/`
- Copied to container on first run
- Persists across container restarts
- No need to re-authenticate

---

## 📊 How It Works

### Architecture

```
┌─────────────────────────────────────────┐
│           Host System                   │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  opencode-docker Container        │  │
│  │                                   │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │  OpenCode AI                │  │  │
│  │  │  (Python, Node.js, Bun)     │  │  │
│  │  └─────────────────────────────┘  │  │
│  │                                   │  │
│  │  /workspace  ← Your Project       │  │
│  │  /mnt/*      ← Custom Dirs        │  │
│  │                                   │  │
│  └───────────────────────────────────┘  │
│         ↑              ↑                │
│    SSH Agent    Config Files            │
└─────────────────────────────────────────┘
```

### Container Lifecycle

1. **Ephemeral Containers**: Each run creates a fresh container (`--rm` flag)
2. **Persistent Data**: Config, caches, and history persist via Docker volumes
3. **Per-Project Isolation**: Each workspace gets its own container namespace
4. **Automatic Cleanup**: Containers automatically removed when you exit

### Security Model

opencode-docker balances security with development usability:

**Container Isolation (Primary Security Boundary)**
- Built on Debian Bookworm (stable) for reliability and security
- Containers are ephemeral and isolated from the host system
- Even with elevated privileges inside the container, host system remains protected
- Each workspace gets its own isolated container environment
- Health checks ensure container integrity

**Capability Restrictions**
- Drops all Linux capabilities by default (`--cap-drop ALL`)
- Selectively adds only essential capabilities:
  - `CHOWN`: Change file ownership
  - `FOWNER`: Bypass permission checks on file operations
  - `SETGID/SETUID`: Required for sudo functionality
- Removed `DAC_OVERRIDE` to prevent bypassing file permission checks
- Enforces `no-new-privileges` to prevent privilege escalation

**Development Container Philosophy**
- Runs as non-root user (`opencode`) with passwordless sudo access
- This is intentional for development containers where users need to:
  - Install system packages on-the-fly
  - Modify configurations for testing
  - Run privileged development tools
- Similar to VS Code DevContainers and GitHub Codespaces

**Additional Protections**
- SSH agent forwarding (never copies keys into container)
- SSH configured with `accept-new` for MITM protection while maintaining usability
- Read-only mounts for SSH agent and configs
- Path validation prevents mounting critical system directories
- Separate volumes per project for isolation
- Pinned package versions for reproducible builds

**Threat Model**
- Protects host system from container compromise
- Suitable for trusted development workflows
- Not designed for running untrusted code in production
- If running untrusted AI-generated code, review it before execution

---

## 🔒 Security Considerations

### Understanding the Security Model

opencode-docker is designed as a **development container**, not a production security sandbox. Understanding this distinction is important:

#### What It Protects Against

✅ **Host system isolation**: Container cannot directly access or modify host system files (except mounted directories)  
✅ **Accidental damage**: Mistakes inside the container won't affect your host system  
✅ **SSH key exposure**: Keys never copied into container, only forwarded via agent  
✅ **Dependency conflicts**: Container dependencies isolated from host packages  
✅ **Per-project separation**: Each workspace has isolated container state  

#### What It Doesn't Protect Against

⚠️ **Malicious code execution**: If OpenCode AI generates malicious code and you run it, it executes with your permissions  
⚠️ **Mounted directory access**: Container has full read-write access to your workspace  
⚠️ **Network access**: Container can make network requests  
⚠️ **Resource exhaustion**: No CPU/memory limits by default  

### Best Practices

**When using OpenCode AI:**
1. **Review generated code** before executing, especially system commands
2. **Don't mount sensitive directories** (like `~/.ssh`, `~/.aws`, etc.)
3. **Use SSH agent forwarding** instead of copying keys
4. **Keep Docker updated** to get latest security patches
5. **Run on trusted networks** when using SSH agent forwarding

**For enhanced security:**
```bash
# Run container with resource limits
docker run --memory="2g" --cpus="2" ...

# Mount workspace as read-only (if you don't need to save changes)
# Modify opencode-docker script to use :ro instead of :rw

# Disable network access (breaks package installation)
docker run --network none ...
```

### Sudo Access Explained

The container user has passwordless sudo access. This is intentional because:

- **Development flexibility**: Install packages, modify configs, test privileged operations
- **Industry standard**: Same approach as VS Code DevContainers, GitHub Codespaces
- **Container isolation**: Root inside container ≠ root on host system
- **User experience**: Avoids password prompts in development workflow

If you're concerned about this, remember:
- The container is ephemeral (destroyed on exit)
- Your host system remains protected by container isolation
- This is standard practice for development containers

### Reporting Security Issues

Found a security vulnerability? Please report it privately.

See our [Security Policy](SECURITY.md) for:
- How to report vulnerabilities
- What to expect
- Security best practices
- Known limitations

**Quick reporting:**
- GitHub Security Advisories: https://github.com/requix/opencode-docker/security/advisories
- Do not open public issues for security vulnerabilities

---


## 🛠️ Troubleshooting

### Image Build Fails

```bash
# Clean rebuild
./opencode-docker rebuild

# Check Docker daemon
docker info
```

### SSH Agent Not Detected

```bash
# Start SSH agent
eval $(ssh-agent)

# Add your key
ssh-add ~/.ssh/id_ed25519

# Verify
ssh-add -l
```

### Permission Denied Errors

```bash
# Ensure script is executable
chmod +x opencode-docker

# Check Docker permissions
docker run hello-world
```

### OpenCode Still Asks for API Key

```bash
# Configure OpenCode on host first
opencode  # Follow setup prompts

# Then start opencode-docker
./opencode-docker  # Config will be inherited
```

---

## 📚 Documentation

- [OpenCode AI Documentation](https://opencode.ai/docs/)
- [OpenCode AI GitHub](https://github.com/sst/opencode)
- [Docker Documentation](https://docs.docker.com/)

---

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### Development

```bash
# Clone the repo
git clone https://github.com/requix/opencode-docker.git
cd opencode-docker

# Make changes to Dockerfile or opencode-docker script

# Test your changes
./opencode-docker rebuild
./opencode-docker shell

# Submit a PR!
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---


- **Report Issues**: [GitHub Issues](https://github.com/requix/opencode-docker/issues)
- **Discussions**: [GitHub Discussions](https://github.com/requix/opencode-docker/discussions)
- **OpenCode AI**: https://opencode.ai

---

<div align="center">

**Made with ❤️ for the OpenCode AI community**

</div>
