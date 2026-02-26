# Agent Skills

> A collection of agent skills for AI coding assistants (Claude, Cursor, Copilot, etc.)

## Skills Included

### 🛡️ guardskills

Security gate for agent skill installations. Scans skill content for malicious patterns before allowing install.

```bash
npx skills add felixondesk/agent-skills --skill guardskills
```

- Scans for credential exfil, RCE, destructive ops, privilege escalation
- Produces risk decisions: SAFE / WARNING / UNSAFE / CRITICAL / UNVERIFIABLE
- Supports GitHub, local, ClawHub, and skills.sh sources
- [npm package](https://www.npmjs.com/package/guardskills) · [GitHub](https://github.com/felixondesk/guardskills)

---

### 🐦 x-algo-post

Expert guidance on X's (Twitter's) open-sourced recommendation algorithm for creating viral content.

```bash
npx skills add felixondesk/agent-skills --skill x-algo-post
```

- 15 engagement signals from the Phoenix ML model
- Two-tower retrieval and scoring formula
- Author diversity penalty and network effects
- Based on [xai-org/x-algorithm](https://github.com/xai-org/x-algorithm)

---

### ✍️ x-tech-articlewriter

Create long-form technical articles optimized for X's algorithm and audience engagement.

```bash
npx skills add felixondesk/agent-skills --skill x-tech-articlewriter
```

---

## Installation

### Using skills.sh (Recommended)

```bash
# Install a specific skill
npx skills add felixondesk/agent-skills --skill <skill-name>

# Browse all skills in this repo
npx skills add felixondesk/agent-skills
```

### Manual Installation

```bash
git clone https://github.com/felixondesk/agent-skills.git
# Copy the desired skill folder to your agent's skills directory
```

## Listing on skills.sh

skills.sh only lists skills that have been installed using the official `npx skills add` command.
If you want this repo to appear on the leaderboard, make sure installs use the command above.

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) for details.

---

**Built with ❤️ by [felixondesk](https://github.com/felixondesk)**
