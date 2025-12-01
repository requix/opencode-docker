# Contributing to opencode-docker

Thank you for your interest in contributing to opencode-docker! This document provides guidelines and instructions for contributing.

## 🎯 Ways to Contribute

- **🐛 Report Bugs**: Found a bug? [Open an issue](https://github.com/yourusername/opencode-docker/issues)
- **✨ Suggest Features**: Have an idea? [Start a discussion](https://github.com/yourusername/opencode-docker/discussions)
- **📖 Improve Documentation**: Fix typos, clarify instructions, add examples
- **🔧 Submit Code**: Fix bugs, add features, improve performance
- **🧪 Test**: Try opencode-docker on different platforms and report findings

## 🚀 Getting Started

### Prerequisites

- Docker installed and running
- Basic familiarity with Bash scripting
- Git and GitHub account

### Development Setup

```bash
# Fork the repository on GitHub

# Clone your fork
git clone https://github.com/YOUR-USERNAME/opencode-docker.git
cd opencode-docker

# Test the current version
./opencode-docker shell

# Make your changes to:
# - Dockerfile (container environment)
# - opencode-docker (CLI script)
# - entrypoint.sh (container initialization)
# - README.md (documentation)

# Test your changes
./opencode-docker rebuild
./opencode-docker shell
```

## 📝 Contribution Process

### 1. Create an Issue First

For significant changes, please create an issue first to discuss:
- What problem you're solving
- Your proposed solution
- Any breaking changes

### 2. Fork and Branch

```bash
# Create a feature branch
git checkout -b feature/your-feature-name

# Or for bug fixes
git checkout -b fix/issue-number-description
```

### 3. Make Your Changes

#### Code Style

- **Bash Scripts**: Follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- **Indentation**: Use 4 spaces (not tabs)
- **Comments**: Add comments for complex logic
- **Error Handling**: Use proper error messages with `error_exit()`

#### Dockerfile Best Practices

- Minimize layers by combining RUN commands
- Clean up package caches after installations
- Pin versions for reproducibility
- Document non-obvious choices with comments

#### Commit Messages

Use conventional commit format:

```
<type>: <description>

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

Examples:
```
feat: add support for mounting multiple directories

fix: resolve SSH agent socket permission issue

docs: clarify installation instructions for macOS
```

### 4. Test Your Changes

```bash
# Rebuild the image
./opencode-docker rebuild

# Test basic functionality
./opencode-docker shell

# Test SSH agent forwarding
eval $(ssh-agent)
ssh-add ~/.ssh/id_ed25519
./opencode-docker
# Inside container:
echo $SSH_AUTH_SOCK
ssh -T git@github.com

# Test custom directory mounting
./opencode-docker --add-dir ~/test-dir

# Test configuration inheritance
# (if you have OpenCode configured on host)

# Test security features
./opencode-docker shell
cat /proc/self/status | grep Cap
```

### 5. Submit Pull Request

```bash
# Push your branch
git push origin feature/your-feature-name

# Open a Pull Request on GitHub with:
# - Clear title describing the change
# - Description of what changed and why
# - Reference to related issues
# - Screenshots if applicable
# - Checklist of what was tested
```

## 📋 Pull Request Checklist

Before submitting, ensure:

- [ ] Code follows project style guidelines
- [ ] All tests pass locally
- [ ] Documentation updated (README, comments)
- [ ] Commit messages follow conventional commit format
- [ ] No sensitive information in commits (API keys, passwords)
- [ ] Branch is up to date with main
- [ ] PR description is clear and complete

## 🧪 Testing Guidelines

### Manual Testing

Test these scenarios:

1. **Fresh Install**
   - Clone repo, run `./opencode-docker` for first time
   - Verify image builds successfully
   - Verify OpenCode starts

2. **SSH Agent Forwarding**
   - With and without SSH agent
   - Verify proper warning messages
   - Test GitHub authentication

3. **Configuration Inheritance**
   - Test with existing OpenCode config
   - Test without config (fresh setup)

4. **Custom Directory Mounting**
   - Single directory with `--add-dir`
   - Multiple directories
   - Verify access inside container

5. **Security**
   - Verify reduced capabilities
   - Test with sensitive file operations
   - Ensure no privilege escalation

### Automated Testing

(Coming soon: GitHub Actions CI/CD)

## 🐛 Reporting Bugs

### Before Reporting

1. Check [existing issues](https://github.com/yourusername/opencode-docker/issues)
2. Try with latest version: `./opencode-docker rebuild`
3. Test on fresh environment if possible

### Bug Report Template

```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce:
1. Run `./opencode-docker ...`
2. Inside container, run `...`
3. See error

**Expected behavior**
What you expected to happen.

**Actual behavior**
What actually happened.

**Environment:**
- OS: [e.g., Ubuntu 22.04, macOS 13]
- Docker version: [e.g., 24.0.5]
- opencode-docker version: [e.g., 1.0.0]

**Logs/Output**
```
Paste relevant command output here
```

**Additional context**
Any other relevant information.
```

## ✨ Feature Requests

### Feature Request Template

```markdown
**Is your feature request related to a problem?**
A clear description of the problem.

**Describe the solution you'd like**
What you want to happen.

**Describe alternatives you've considered**
Other solutions you've thought about.

**Additional context**
Any other relevant information, mockups, etc.
```

## 📚 Documentation

Good documentation is crucial! When contributing:

- Update README.md for user-facing changes
- Add comments in code for complex logic
- Update CHANGELOG.md (once we start it)
- Consider adding examples for new features

## 🤝 Code of Conduct

This project adheres to a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you agree to uphold this code.

## 💬 Getting Help

- **Questions**: [GitHub Discussions](https://github.com/yourusername/opencode-docker/discussions)
- **Chat**: (TBD - Discord/Slack if community grows)
- **Issues**: [GitHub Issues](https://github.com/yourusername/opencode-docker/issues)

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to opencode-docker! 🎉
