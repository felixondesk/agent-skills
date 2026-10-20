# android-debloat — a Claude Code skill

Make an old, slow Android phone or tablet feel faster by removing bloatware from your laptop. **No root**, and every removed app can be restored with one command.

It's built for **non-technical people**. Claude does the technical work and walks you through it one step at a time, in your own language (English, Tamil, Tanglish, Hindi...).

## What it does

1. Asks for your phone's **model and Android version**, and tells you where to find them
2. Picks the connection method:
   - **Android 11+** → over **Wi-Fi** (wireless debugging, no cable)
   - **Android 10 and older** → **USB debugging** with a cable
3. Guides you to turn on Developer options and debugging, with steps for your brand
4. Installs ADB on your laptop if it's missing
5. Scans your phone and shows the apps in three groups:
   - ✅ **Safe to remove**, and why
   - ⚠️ **Your choice**, and what you'd lose
   - 🔒 **Keeping**, and why removing it would break things
6. Removes only what you approve, and saves a **restore list** on your laptop
7. Measures storage and RAM **before and after** (a fair, idle test after a restart)

The brand lists cover Samsung, Xiaomi / Redmi / POCO, Realme / Oppo / OnePlus, Vivo / iQOO, Motorola, Google apps and common preinstalls.

## Safety

All removals go through `scripts/debloat.sh`, which enforces the rules in code so they don't depend on the AI remembering them:

- It removes only apps that the list marks SAFE or CAUTION. Unknown apps are never touched.
- It has a hard-coded block list of core apps (System UI, Settings, Play Services, launchers, keyboards, security apps, updaters), and on phones it also blocks calls/SMS/VoLTE apps.
- It checks the device after **every** removal. If anything looks wrong, it puts that app back and stops.
- `bash scripts/debloat.sh selftest` checks the safety rules offline.

- Uses `pm uninstall --user 0` only. The app is hidden for your user, not deleted from the system.
- Never removes core system apps (Settings, Play Store, launcher, keyboard, and calls/SMS on phones), even if asked.
- Never deletes your photos or documents.
- Asks before every removal.
- Restore any app: `adb shell pm install-existing <package>`. A factory reset also brings everything back.

## Install

You need [Claude Code](https://claude.com/claude-code).

**Recommended: scan it with [GuardSkills](https://guardskills.felixondesk.chatgpt.site/) first.** This skill runs ADB commands on your phone, so check what you're installing. GuardSkills scans the skill, gives it a risk verdict, and installs it only if it passes:
```
npx guardskills skills add felixondesk/agent-skills --skill android-debloat
```
Preview the verdict without installing:
```
npx guardskills add felixondesk/agent-skills --skill android-debloat --dry-run
```

**Without the scan:**
```
npx skills add felixondesk/agent-skills --skill android-debloat
```

**Or manually:** copy `.github/skills/android-debloat` into `~/.claude/skills/`.

## Use

Open Claude Code and say:

```
/android-debloat my phone is slow
```

## Disclaimer

Use at your own risk. Removing system apps with `--user 0` is reversible and doesn't need root, but OEM firmware varies. Xiaomi, Oppo and Vivo can boot loop if you remove their security apps, which this skill refuses to do. Package lists are community knowledge, so check before relying on them for a device you can't afford to break.

## License

MIT
