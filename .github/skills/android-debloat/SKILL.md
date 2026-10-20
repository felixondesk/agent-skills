---
name: android-debloat
description: Hand-hold a non-technical person through removing bloatware from their Android phone or tablet from a laptop with ADB, no root. Use when someone says "debloat my phone/tablet", "remove bloatware", "my phone is slow / storage full / too many useless apps", or invokes /android-debloat. Covers installing ADB, enabling Developer options, connecting over USB or Wi-Fi, scanning installed apps, explaining what is safe to remove and why, removing with a restore log, and measuring before/after.
---

# Android debloat (hand-held, no root)

The person you are helping is NOT technical. They cannot read shell output and they get scared easily. Your job is to do the technical work yourself and give them only one small, clear action at a time.

## How to talk

- Reply in the language the person writes in (English, Tamil, Tanglish, Hindi...). Keep tech words like "USB debugging" in English, because that is what their screen shows.
- One step per message. Number it. Say exactly what to tap and what they will see. Wait for "done" before the next step.
- Never paste raw command output at them. Summarize it in one line.
- Before anything is removed, say clearly: "Nothing is deleted permanently. Every app can be brought back with one command."
- Use simple names for apps ("Samsung Game Launcher"), not package names, unless they ask.

## Hard safety rules

- Never root, unlock the bootloader, flash anything or run `pm clear` on system apps.
- Remove only with `pm uninstall --user 0 <pkg>`. Never `pm uninstall` without `--user 0`, never `rm` on /system.
- Never remove anything on the NEVER list in `references/bloatware.md`, even if they ask. Explain why in one line.
- Never remove a launcher or keyboard unless a replacement is installed AND opened once.
- On a PHONE (has SIM / calls), never remove the dialer, call screen (incallui), messaging, or telephony apps. On a Wi-Fi-only tablet they are optional.
- Never delete their personal files (photos, PDFs, documents, videos). You may suggest deleting old `.apk` installer files in Download, but list them and ask first.
- Show the full removal list and get a clear "yes" before removing anything.
- Every removed package is appended to the restore log before you move on.

## Workflow

Track progress with these steps. Do not skip ahead.

### 1. ADB on the laptop
Check `adb version`. If it's missing, install it yourself:
- Windows: `winget install Google.PlatformTools` (then open a new shell or use the full path under `%LOCALAPPDATA%\Microsoft\WinGet\Packages\Google.PlatformTools*\platform-tools\adb.exe`)
- macOS: `brew install --cask android-platform-tools` (if there's no brew, download from https://developer.android.com/tools/releases/platform-tools)
- Linux: `sudo apt install adb` (or the distro equivalent)

### 2. First message: get the model and Android version
Before anything else, ask them to send the **model name** and **Android version** (a screenshot is fine), and tell them exactly where to look for their brand:
- Samsung: Settings → **About phone** (or About tablet) → model name at the top. Then **Software information** → **Android version**
- Xiaomi / Redmi / POCO: Settings → **About phone** → **Device name / Model**, and **Android version**
- Realme / Oppo / OnePlus: Settings → **About device** (or About phone) → **Model**, then **Version** → **Android version**
- Vivo / iQOO: Settings → **About phone** → **Model**, and **Software version / Android version**
- Motorola / Nokia / Pixel / others: Settings → **About phone** → **Model**, and **Android version**
- Can't find it: Settings → search bar → type **"Android version"**

Also ask: is it a phone (with a SIM) or a Wi-Fi-only tablet? And which apps do they actually use? Anything they name is KEEP, no matter which list it's on.

### 3. Pick the connection method and give the initial steps
Decide from the Android version and tell them which path they're on, in one line:
- **Android 11 or newer → Wi-Fi** (recommended, no cable). They need the phone and laptop on the same Wi-Fi.
- **Android 10 or older → USB debugging with a cable.** Wireless debugging doesn't exist on these versions. Ask them to keep a USB cable ready, the one that came with the phone if possible, because some cables only charge.

Then walk them through the steps below for their brand, one message at a time.

**Unlock Developer options:** tap the number below 7 times (it may ask for their PIN):
- Samsung: Settings → About phone → Software information → **Build number**
- Xiaomi / Redmi / POCO: Settings → About phone → **MIUI version** / **OS version**
- Realme / Oppo / OnePlus: Settings → About device → Version → **Build number**
- Vivo / iQOO: Settings → About phone → Software version → **Software version**
- Motorola / Nokia / Pixel / others: Settings → About phone → **Build number**

**Find Developer options:** Samsung: Settings → bottom of the list. Xiaomi: Settings → Additional settings. Realme/Oppo/OnePlus: Settings → System settings (or Additional settings). Vivo: Settings → System management (or More settings). Others: Settings → System. If it's not there, search Settings for **"Developer options"**.

**Turn on debugging:**
- Android 11+: in Developer options turn on **Wireless debugging**, and also **USB debugging** (some brands require it first).
- Android 10 or older: in Developer options turn on **USB debugging**.
- Xiaomi only: also turn on **USB debugging (Security settings)**. It may need a SIM card and a Mi account. Without it, uninstall fails.

### 4. Connect
- **Android 11 or newer (Wi-Fi, no cable):** Developer options → **Wireless debugging** → tap the words to open it → **Pair device with pairing code**. Ask for the code and IP:port in the popup. Run `adb pair IP:PORT CODE`, then `adb mdns services` to find the connect port and `adb connect IP:PORT` if it doesn't show in `adb devices`.
- **Android 10 or older:** USB cable once. They tap **Allow** (tick "Always allow") on the phone. Then `adb tcpip 5555`, unplug, `adb connect PHONE_IP:5555`. Get the IP from Settings → About phone → Status → IP address. Warn them: Wi-Fi ADB on these versions has no password, so use home Wi-Fi only. It turns off on restart.
- `unauthorized` in `adb devices` → the Allow popup is waiting on the phone screen. `no devices` → try a different cable (some cables only charge), or a different USB port.

Once connected, use `adb -s <serial>` for every command. Confirm the model and version they gave you with `getprop ro.product.model` and `getprop ro.build.version.release`. If they don't match, trust the device and tell them.

### 5. Scan (no changes yet)
Collect quietly:
- `getprop ro.product.model`, `getprop ro.build.version.release`, `getprop ro.product.brand`
- `pm list packages` (all), `pm list packages -s` (system), `pm list packages -3` (user-installed)
- Storage: `df -h /data`. Biggest folders: `du -s /sdcard/* /sdcard/Android/data/* 2>/dev/null | sort -rn | head -15` (toybox `sort` has no `-h`). Big files in Download: `ls -lS /sdcard/Download | head`
- RAM: `grep MemAvailable /proc/meminfo` and `dumpsys meminfo | grep -A15 "Total PSS by process"`

Tell them in plain words what is slowing the device: storage, RAM, or background apps.

### 6. Build the plan
Match every installed package against `references/bloatware.md` for their brand plus the Google/partner sections. Anything not on the list stays: unknown means KEEP. Show three short groups in plain language:

- ✅ **Safe to remove**: name, what it is, one-line why it's safe
- ⚠️ **Your choice**: name, what you lose if it's removed. Ask yes/no for each, or as a group.
- 🔒 **Keeping these**: the important ones only, with a one-line reason each ("this is your home screen, removing it gives a black screen")

Also mention any old `.apk` files or obviously huge forgotten files in Download, with sizes, and ask.

Then ask: "Shall I go ahead and remove the ✅ list and the ⚠️ ones you said yes to?"

### 7. Measure, then remove
1. Baseline: `grep MemAvailable /proc/meminfo`, `df -h /data`, and the package count.
2. Restore log: `~/debloat-<model>-<YYYY-MM-DD>.txt` on the laptop. First line: `# Restore one: adb shell cmd package install-existing <pkg>`
3. For each package: `pm uninstall --user 0 <pkg>`. On `Success`, append it to the log. Collect failures and don't retry blindly.
4. Optional, if they want it snappier: animations to 0.5×
   `settings put global window_animation_scale 0.5; settings put global transition_animation_scale 0.5; settings put global animator_duration_scale 0.5`

### 8. Fair after-measurement
Restart (`adb reboot`). Ask them to unlock, turn Wireless debugging back on if needed (Android 10 and older: cable plus `adb tcpip 5555` again), and **not open any apps**. Wait until `/proc/uptime` is at least 300 seconds, then measure the same things as the baseline.

Be honest:
- Free RAM numbers jump around, and Android fills spare RAM with cache on purpose. Only compare `MemAvailable` readings taken the same way (fresh restart, idle, 5 minutes).
- If the numbers didn't improve, say so. Point to what did change (fewer background apps, storage freed, animations).

Give them a simple before/after table.

### 9. Test and close
- Ask them to open the apps they care about (camera, WhatsApp, banking, calls/SMS on a phone) and confirm they work.
- Tell them where the restore log is and that any app can come back with `adb shell cmd package install-existing <pkg>`. If they're unsure what broke, restore the most recent batch.
- Turn off Wi-Fi debugging: Android 11+ → they switch off **Wireless debugging**. Android 10 or older → `adb usb`, or just restart. Optionally they can turn Developer options off.

## If something goes wrong
- App or feature broke → find the likely package in the log, `cmd package install-existing <pkg>`, then retest.
- Black screen / no home screen → `cmd package install-existing` the launcher (`com.sec.android.app.launcher`, `com.miui.home`, `com.oppo.launcher`, `com.android.launcher3`, `com.bbk.launcher2`...).
- Boot loop (very rare with `--user 0`, mostly Xiaomi security packages) → wait. ADB usually still connects during boot, so restore the last batch. Factory reset is the last resort: it brings back everything, but it also erases their data, so say that plainly first.
