# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Security Model

opencode-docker is designed as a **development container**, not a production security sandbox. The security model prioritizes developer productivity while maintaining reasonable isolation.

### Security Boundaries

**Primary Boundary: Container Isolation**
- The main security boundary is the Docker container itself
- Host system is protected from container compromise
- Container has limited access to host resources

**What's Protected:**
- ✅ Host system files (except mounted directories)
- ✅ Host system processes
- ✅ SSH keys (via agent forwarding, never copied)
- ✅ Other containers and projects

**What's Not Protected:**
- ❌ Mounted workspace directory (container has full read-write access)
- ❌ Execution of malicious code (if you run it, it executes)
- ❌ Network access (container can make outbound connections)

### Security Features

**Container Hardening:**
- Runs on Debian Bookworm (stable) for security updates
- Drops all Linux capabilities, adds only essential ones
- Enforces `no-new-privileges` security option
- Non-root user execution (with sudo for development needs)
- Ephemeral containers (destroyed on exit)

**SSH Security:**
- Agent forwarding (keys never enter container)
- Pre-configured GitHub host keys
- `accept-new` policy for MITM protection
- Read-only mounts for sensitive data

**Build Security:**
- Pinned package versions for reproducibility
- Health checks for container integrity
- OCI-compliant metadata labels
- Minimal attack surface

### Threat Model

**Designed to protect against:**
- Accidental damage to host system
- Dependency conflicts
- SSH key exposure
- Container escape (via standard Docker isolation)

**Not designed to protect against:**
- Intentionally malicious code execution
- Sophisticated container escape exploits
- Network-based attacks
- Social engineering

## Git Authentication for AI Agents

### Security Recommendation

OpenCode AI can make commits and push code. **Use dedicated credentials, not your personal SSH key.**

**Why?**
- ✅ Revoke AI access without affecting yours
- ✅ Limit AI to specific repositories
- ✅ Clear audit trail of AI actions
- ✅ Set expiration dates (for tokens)

**Methods (by security)**:
1. **GitHub Token** - Most secure, granular permissions
2. **Dedicated SSH Key** - Good security, no expiration
3. **Personal SSH Key** - ❌ Not recommended, full access to all repos

See README.md for setup instructions.

## Best Practices

1. **Review AI-generated code** before executing (especially system commands)
2. **Don't mount sensitive directories** like `~/.ssh` or `~/.aws`
3. **Use SSH agent forwarding** instead of copying keys
4. **Keep Docker updated** for latest security patches
5. **Use dedicated git credentials** for AI (see above)

### For Developers

If modifying this project:
1. Never add unnecessary capabilities (current: CHOWN, FOWNER, SETGID, SETUID)
2. Keep base image updated (Debian stable)
3. Pin package versions (at least major versions)
4. Test security changes before committing

## Reporting a Vulnerability

**Please report security vulnerabilities privately.**

### How to Report

**GitHub Security Advisories** (preferred):
   - Go to: https://github.com/requix/opencode-docker/security/advisories
   - Click "Report a vulnerability"
   - Fill in the details


### What to Include

- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if you have one)
- Your contact information


### Disclosure Policy

- We follow coordinated disclosure
- We'll work with you on disclosure timeline
- We'll credit you in release notes (unless you prefer anonymity)
- We won't take legal action against good-faith researchers

## Security Updates

Security updates are released as:
- Patch versions (1.0.x) for security fixes
- Minor versions (1.x.0) for security improvements
- Documented in CHANGELOG

Subscribe to releases: https://github.com/requix/opencode-docker/releases

## Known Limitations

**By Design** (development container trade-offs):
- Passwordless sudo (standard for dev containers)
- Workspace write access (required for AI to work)
- Network access (needed for packages, git)

**Technical** (inherent to containers):
- Relies on Docker's security model
- No resource limits by default
- Shares host kernel

## Security Checklist

- [ ] Use dedicated git credentials (not personal)
- [ ] Configure SSH agent forwarding (don't copy keys)
- [ ] Don't mount sensitive directories (~/.ssh, ~/.aws)
- [ ] Review AI-generated code before execution
- [ ] Keep Docker and opencode-docker updated

## References

- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [Linux Capabilities](https://man7.org/linux/man-pages/man7/capabilities.7.html)
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
- [OWASP Container Security](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)

---

**Last Updated**: December 3, 2025
**Version**: 1.0.0
