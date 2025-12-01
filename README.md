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

opencode-docker provides a dedicated, secure Docker container for running [OpenCode AI](https://opencode.ai) with:

- **🔒 Enhanced Security**: Runs with minimal privileges and capability restrictions
- **🔑 SSH Agent Forwarding**: Access private repositories without copying keys
- **⚙️ Configuration Inheritance**: One-time setup, persistent across sessions
- **🚀 Multi-Language Support**: Python (uv), Node.js (NVM), Bun pre-installed
- **💾 Package Caching**: Persistent caching for npm, pip, Maven, and Gradle
- **🎨 Per-Project Isolation**: Separate container state for each workspace

Based on the excellent [AgentBox](https://github.com/fletchgqc/agentbox) architecture by fletchgqc.

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
git clone https://github.com/yourusername/opencode-docker.git
cd opencode-docker

# Start OpenCode in current directory
./opencode-docker

# That's it! OpenCode AI is now running in a secure container
```

---

## 📦 Installation

### Prerequisites

- **Docker**: [Install Docker](https://docs.docker.com/get-docker/)
- **Linux/macOS**: Tested on Linux and macOS (Windows via WSL2)
- **Disk Space**: ~2GB for Docker image

### Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/opencode-docker.git
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

For accessing private repositories:

```bash
# Start SSH agent on host
eval $(ssh-agent)
ssh-add ~/.ssh/id_ed25519  # or your key path

# SSH agent will be automatically forwarded to container
./opencode-docker

# Inside container, test GitHub access:
ssh -T git@github.com
# Should authenticate successfully without prompting for host key
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
# Change config directory
export OPENCODEBOX_CONFIG_DIR=~/.my-opencode-docker-config

# Change cache directory
export OPENCODEBOX_CACHE_DIR=~/.my-cache

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
│  ┌───────────────────────────────────┐ │
│  │  opencode-docker Container            │ │
│  │                                   │ │
│  │  ┌─────────────────────────────┐ │ │
│  │  │  OpenCode AI                │ │ │
│  │  │  (Python, Node.js, Bun)     │ │ │
│  │  └─────────────────────────────┘ │ │
│  │                                   │ │
│  │  /workspace  ← Your Project      │ │
│  │  /mnt/*      ← Custom Dirs       │ │
│  │                                   │ │
│  └───────────────────────────────────┘ │
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

- **Capability Drop**: Starts with no privileges
- **Selective Capabilities**: Only adds essential Linux capabilities
- **Read-Only Mounts**: SSH agent and configs mounted read-only
- **No Privilege Escalation**: `no-new-privileges` security option
- **Path Validation**: Prevents mounting dangerous system directories

---

## 🆚 Comparison with Alternatives

| Feature | opencode-docker | Native OpenCode | Docker Run | DevContainer |
|---------|-------------|----------------|------------|--------------|
| **One-command launch** | ✅ | ✅ | ❌ | ❌ |
| **SSH agent forwarding** | ✅ | N/A | ⚠️ Manual | ⚠️ Manual |
| **Security hardening** | ✅ | N/A | ❌ | ❌ |
| **Config persistence** | ✅ | ✅ | ❌ | ⚠️ Manual |
| **Per-project isolation** | ✅ | ❌ | ⚠️ Manual | ✅ |
| **Package caching** | ✅ | ✅ | ❌ | ⚠️ Manual |
| **Works without IDE** | ✅ | ✅ | ✅ | ❌ |

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
- [AgentBox (Base Project)](https://github.com/fletchgqc/agentbox)
- [Docker Documentation](https://docs.docker.com/)

---

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### Development

```bash
# Clone the repo
git clone https://github.com/yourusername/opencode-docker.git
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

## 🙏 Acknowledgments

- **[AgentBox](https://github.com/fletchgqc/agentbox)** by fletchgqc - The architectural foundation
- **[OpenCode AI](https://opencode.ai)** - The AI coding assistant this project supports
- Security patterns inspired by [opencode-box](https://github.com/filipesoccol/opencode-box) and [RecursiveHook/opencode-docker](https://github.com/RecursiveHook/opencode-docker)

---

## 🔗 Links

- **Report Issues**: [GitHub Issues](https://github.com/yourusername/opencode-docker/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/opencode-docker/discussions)
- **OpenCode AI**: https://opencode.ai

---

<div align="center">

**Made with ❤️ for the OpenCode AI community**

</div>
