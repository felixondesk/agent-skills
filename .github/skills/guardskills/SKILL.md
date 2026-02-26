---
name: guardskills
description: Security gate for agent skill installations. Use this skill BEFORE installing any skill from GitHub, skills.sh, ClawHub, or local sources. guardskills scans skill content for malicious patterns (credential exfil, remote code exec, destructive ops, privilege escalation) and produces a risk decision (SAFE/WARNING/UNSAFE/CRITICAL/UNVERIFIABLE) before allowing install to proceed. Always run guardskills first; never run a skill installer directly.
license: MIT
metadata:
  author: felixondesk
  version: "1.2.1"
---

<div align="center">

# 🛡️ GuardSkills

### Security Gate for Agent Skill Installations

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![npm](https://img.shields.io/badge/npm-guardskills-red.svg)](https://www.npmjs.com/package/guardskills)
[![GitHub](https://img.shields.io/badge/GitHub-felixondesk/guardskills-blue.svg)](https://github.com/felixondesk/guardskills)

**Scan before you install. Every time.**

[When to Use](#-when-to-use) • [Scan Commands](#-scan-commands) • [Interpret Results](#-interpret-results) • [Gate Flags](#-gate-flags) • [Scoring](#-scoring-logic)

</div>

---

## 🚨 When to Use

**Always run guardskills BEFORE installing any skill.** This includes:

- Installing via `skills add` (skills.sh)
- Installing via `playbooks add skill`
- Installing via `openskills install`
- Installing via `skillkit install`
- Running any skill from a local path
- Installing from ClawHub

**Never run a skill installer directly without scanning first.**

---

## 📥 Installation

guardskills is available as an npm package:

```bash
npx guardskills --help
```

Or install globally:

```bash
npm install -g guardskills
```

---

## 🔍 Scan Commands

### 1. GitHub Skills (Most Common)

Scan a GitHub-hosted skill without installing:

```bash
npx guardskills add owner/repo --skill <skill-name> --dry-run
```

Also accepts full URLs:

```bash
npx guardskills add https://github.com/owner/repo --skill <skill-name> --dry-run
```

### 2. Local Skills

Scan a skill folder on disk:

```bash
npx guardskills scan-local <path-to-skill-folder>
```

If the path contains multiple skills:

```bash
npx guardskills scan-local <path-to-skills-root> --skill <skill-folder-name>
```

### 3. ClawHub Skills

Scan by identifier or full URL:

```bash
npx guardskills scan-clawhub owner/skill-slug
npx guardskills scan-clawhub https://clawhub.ai/owner/skill-slug
```

### 4. Guarded Install (After Scan Passes)

If the scan result is acceptable, run the guarded install:

```bash
# skills.sh
npx guardskills add owner/repo --skill <skill-name>

# Or with provider prefix
npx guardskills skills add owner/repo --skill <skill-name>
npx guardskills playbooks add skill owner/repo --skill <skill-name>
npx guardskills openskills install owner/repo <skill-name>
npx guardskills skillkit install owner/repo <skill-name>
```

guardskills will scan first, then hand off to the underlying installer only if the gate allows.

---

## 🎯 Interpret Results

guardskills produces one of five risk decisions:

| Decision | Meaning | Action |
|----------|---------|--------|
| **SAFE** | No known high-risk patterns detected | ✅ Proceed |
| **WARNING** | Some medium-risk patterns found | ⚠️ Ask user for confirmation |
| **UNSAFE** | High-risk patterns detected | 🚫 Block unless user explicitly overrides with `--force` |
| **CRITICAL** | Hard-blocked — credential exfil, RCE, destructive ops, or priv escalation | 🛑 Always block |
| **UNVERIFIABLE** | Content could not be fully analyzed | 🚫 Block unless user explicitly allows with `--allow-unverifiable` |

### How to Respond to Each Decision

```
SAFE       → Proceed with the install.
WARNING    → Tell the user what was found. Ask if they want to continue.
UNSAFE     → Tell the user the skill is high-risk. Do NOT install unless they explicitly say to override.
CRITICAL   → Tell the user the skill is blocked. Do NOT install. No override available.
UNVERIFIABLE → Tell the user the content couldn't be fully scanned. Do NOT install unless they explicitly allow.
```

---

## 🏁 Gate Flags

| Flag | Purpose |
|------|---------|
| `--dry-run` | Scan + decision only, no install handoff |
| `--ci` | Deterministic gate mode, no install handoff, for CI pipelines |
| `--json` | Machine-readable JSON output |
| `--yes` | Accept WARNING without prompting |
| `--force` | Accept UNSAFE (use with extreme caution) |
| `--allow-unverifiable` | Accept UNVERIFIABLE results |
| `--strict` | Use stricter scoring thresholds |

---

## 🔧 Resolver Controls

Fine-tune GitHub API behavior:

```bash
npx guardskills add owner/repo --skill name \
  --github-timeout-ms 15000 \
  --github-retries 2 \
  --github-retry-base-ms 300 \
  --max-file-bytes 250000 \
  --max-aux-files 40 \
  --max-total-files 120
```

---

## 📊 Scoring Logic

guardskills uses a two-layer model:

### Layer 1: Hard-Block Guardrails

A finding triggers an automatic hard block when **all** of these are true:
- Severity is `CRITICAL`
- Confidence is `high`
- Type is `CREDENTIAL_EXFIL`, `DESTRUCTIVE_OP`, `REMOTE_CODE_EXEC`, or `PRIV_ESCALATION`

### Layer 2: Weighted Risk Score (0–100)

```
risk_score = clamp(
  sum(base_points × confidence_multiplier)
  + chain_bonuses
  − trust_credits,
  0, 100
)
```

**Severity base points:** CRITICAL=50, HIGH=25, MEDIUM=12, LOW=5, INFO=0

**Confidence multipliers:** high=1.0, medium=0.7, low=0.4

**Standard thresholds:**

| Score | Decision |
|-------|----------|
| 0–29 | SAFE |
| 30–59 | WARNING |
| 60–79 | UNSAFE |
| 80–100 | CRITICAL |

**Strict thresholds** (`--strict`):

| Score | Decision |
|-------|----------|
| 0–19 | SAFE |
| 20–39 | WARNING |
| 40–59 | UNSAFE |
| 60–100 | CRITICAL |

---

## 📋 Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Allowed / success |
| `10` | Warning not confirmed |
| `20` | Blocked (UNSAFE, CRITICAL, or UNVERIFIABLE without override) |
| `30` | Runtime / internal error |

---

## 🔄 Recommended Workflow

Follow this workflow every time you install a skill:

1. **Scan first** — choose the right command for the source type:
   ```bash
   # GitHub
   npx guardskills add owner/repo --skill <name> --dry-run
   # Local
   npx guardskills scan-local <path>
   # ClawHub
   npx guardskills scan-clawhub owner/slug
   ```

2. **Read the decision** — check if it's SAFE, WARNING, UNSAFE, CRITICAL, or UNVERIFIABLE.

3. **Act on the decision:**
   - SAFE → proceed with guarded install
   - WARNING → inform user, ask for confirmation
   - UNSAFE/CRITICAL → block and explain findings
   - UNVERIFIABLE → block and explain

4. **Install through guardskills** (never directly):
   ```bash
   npx guardskills add owner/repo --skill <name>
   ```

---

## ⚙️ Configuration

guardskills supports a config file (`guardskills.config.json`) for repository-level policy:

```json
{
  "defaults": {
    "strict": false,
    "ci": false,
    "json": false,
    "yes": false,
    "dryRun": false,
    "force": false,
    "allowUnverifiable": false
  },
  "resolver": {
    "githubTimeoutMs": 15000,
    "githubRetries": 2,
    "githubRetryBaseMs": 300,
    "maxFileBytes": 250000,
    "maxAuxFiles": 40,
    "maxTotalFiles": 120
  },
  "policy": {
    "allowForce": true,
    "allowUnverifiableOverride": true,
    "allowedOwners": [],
    "blockedOwners": [],
    "allowedRepos": [],
    "blockedRepos": []
  }
}
```

---

## 📚 References

- [guardskills on npm](https://www.npmjs.com/package/guardskills)
- [guardskills on GitHub](https://github.com/felixondesk/guardskills)
- [Scanner Rule Matrix](references/RULES.md)

---

## 📄 License

MIT License — see [LICENSE](../../LICENSE) for details.

---

<div align="center">

**🛡️ Scan before you install. Every time.**

**[guardskills on GitHub](https://github.com/felixondesk/guardskills) · [guardskills on npm](https://www.npmjs.com/package/guardskills)**

</div>
