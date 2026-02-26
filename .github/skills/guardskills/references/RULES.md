# Scanner Rule Matrix

Reference for guardskills scanner rules, attack chain bonuses, and false-positive controls.

## Rule Matrix

| Rule ID | Type | Severity | Confidence | Intent |
|---|---|---:|---:|---|
| `R001_CREDENTIAL_EXFIL` | `CREDENTIAL_EXFIL` | `CRITICAL` | `high` | Credential read + outbound transfer |
| `R002_RCE_PIPE` | `REMOTE_CODE_EXEC` | `CRITICAL` | `high` | `download \| interpreter` patterns |
| `R003_DESTRUCTIVE_FS` | `DESTRUCTIVE_OP` | `CRITICAL` | `high` | Destructive wipe/delete commands |
| `R004_PRIV_ESC` | `PRIV_ESCALATION` | `CRITICAL` | `high` | Risky `sudo` command execution |
| `R005_SECRET_READ` | `SECRET_READ` | `HIGH` | `medium` | Secret/token source access |
| `R006_NETWORK_POST` | `NETWORK_POST` | `MEDIUM` | `medium` | Outbound requests with payload/body |
| `R007_DECODE_EXEC` | `DECODE_EXEC` | `HIGH` | `medium` | Decode/deobfuscation + execution sink |
| `R008_ENV_ACCESS` | `ENV_ACCESS` | `LOW` | `low` | Env reads |
| `R009_FILE_STAGE` | `FILE_STAGE` | `LOW` | `low` | Temp/staging writes |
| `R010_DYNAMIC_EXEC` | `REMOTE_CODE_EXEC` | `HIGH` | `medium` | Dynamic execution primitives |
| `R011_IEX_DOWNLOAD` | `REMOTE_CODE_EXEC` | `CRITICAL` | `high` | PowerShell download-and-execute |
| `R012_DOWNLOAD_THEN_EXEC` | `REMOTE_CODE_EXEC` | `HIGH` | `medium` | Downloaded artifact executed unverified |
| `R013_ENCODED_EXFIL` | `NETWORK_POST` | `HIGH` | `medium` | Encoded data sent externally |
| `R014_ARCHIVE_FETCH_EXEC` | `REMOTE_CODE_EXEC` | `HIGH` | `medium` | Archive download/extract then execute |
| `R015_CHMOD_THEN_EXEC` | `REMOTE_CODE_EXEC` | `HIGH` | `medium` | `chmod +x` followed by execution |
| `R016_SPLIT_TOKEN_RCE` | `REMOTE_CODE_EXEC` | `CRITICAL` | `high` | Obfuscated split-token download-exec |

## Attack Chain Matrix

| Chain ID | Required Findings | Bonus | Intent |
|---|---|---:|---|
| `CHAIN_SECRET_EXFIL` | `SECRET_READ` + `NETWORK_POST` | `+25` | Credential/data exfil flow |
| `CHAIN_DECODE_EXEC` | `DECODE_EXEC` + `REMOTE_CODE_EXEC` | `+30` | Obfuscated payload execution |
| `CHAIN_ENV_STAGE_EXFIL` | `ENV_ACCESS` + `FILE_STAGE` + `NETWORK_POST` | `+20` | Staged environment exfiltration |

## False-Positive Controls

Markdown is scanned as executable content only in:
- Fenced code blocks
- Inline code snippets that look command-like
- Command-style lines (`$`, `PS>`, `>`, list-item commands)

Prose-only markdown text is ignored for high-risk matching.

## Source

Full documentation: [github.com/felixondesk/guardskills](https://github.com/felixondesk/guardskills)
