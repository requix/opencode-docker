# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-04

### Added
- Initial public release of opencode-docker
- Dedicated Docker container for OpenCode AI development
- Multi-language support (Python, Node.js, Bun)
- Pre-installed development tools (git, gh, glab)
- SSH agent forwarding for private repositories
- OpenCode configuration inheritance from host
- Secure container with minimal capabilities
- Automatic image rebuilding on Dockerfile changes
- Support for mounting additional directories
- Comprehensive documentation and examples

### Fixed
- GitLab CLI (glab) installation with proper architecture mapping
- GitHub Actions workflow for automated testing
- SSH configuration for secure Git operations

### Security
- Container runs as non-root user (opencode)
- Minimal Linux capabilities (CHOWN, FOWNER, SETGID, SETUID)
- No new privileges security option enabled
- Isolated workspace with proper permission management

[1.0.0]: https://github.com/requix/opencode-docker/releases/tag/v1.0.0
