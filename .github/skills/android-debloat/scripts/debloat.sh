#!/usr/bin/env bash
# Safe Android debloat. Removes ONLY packages that references/bloatware.md marks SAFE/CAUTION,
# refuses NEVER and unknown packages, and health-checks the device after every single removal
# (it restores that package and stops if the device looks unhealthy).
#
#   debloat.sh -s SERIAL check   pkg...          # dry run: ALLOW / DENY / UNKNOWN per package
#   debloat.sh -s SERIAL remove  LOGFILE pkg...  # remove allowed packages, append each to LOGFILE
#   debloat.sh -s SERIAL restore LOGFILE [pkg...]# bring back everything in LOGFILE (or just pkg...)
#   debloat.sh selftest                          # offline test of the safety rules
set -f  # package globs must never expand against the filesystem

HERE="$(cd "$(dirname "$0")" && pwd)"
LIST="$HERE/../references/bloatware.md"

# Hard floor, applied even if bloatware.md is edited badly: removing these breaks the device.
CORE_DENY='android com.android.systemui com.android.settings com.android.shell com.android.phone
com.android.vending com.google.android.gms com.google.android.gsf com.android.externalstorage
com.android.mtp com.android.bluetooth com.android.nfc com.miui.home *launcher* *packageinstaller*
*permissioncontroller* *webview* *setupwizard* *SetupWizard* *providers* *provider.* *inputmethod*
*honeyboard* *keyboard* *securitycenter* *securitycore* *safecenter* *securitypermission*
*iqoo.secure* *guardprovider* *lbe.security* *.ota *updater* *knox.containercore* *networkstack*
*.wifi.* *ext.services *ext.shared *modulemetadata* *documentsui* *wssyncmldm* *powerkeeper*'
# Extra floor on devices with a SIM: calls, SMS (OTP) and VoLTE must keep working.
PHONE_DENY='*dialer* *incallui* *messaging* *.mms* *telephony* *telecom* *contacts* *imsservice* *.ims* *hiya*'

die() { echo "ERROR: $*" >&2; exit 1; }

# Prints "DENY<TAB>glob" / "ALLOW<TAB>glob" from the tables and **NEVER:** lines in bloatware.md.
rules() {
  awk '
    function emit(cell, verdict,   s) {
      s = cell
      while (match(s, /`[^`]+`/)) { print verdict "\t" substr(s, RSTART + 1, RLENGTH - 2); s = substr(s, RSTART + RLENGTH) }
    }
    /^## /            { never_sec = ($0 ~ /^## NEVER/) }
    /^\*\*NEVER:\*\*/ { emit($0, "DENY"); next }
    /^\| / {
      split($0, c, "|"); tier = c[3]; sub(/^ +/, "", tier); split(tier, w, " ")
      emit(c[2], (!never_sec && (w[1] == "SAFE" || w[1] == "CAUTION")) ? "ALLOW" : "DENY")
    }' "$LIST"
}

matches_any() { # pkg "glob glob ..."
  local p="$1" g
  for g in $2; do [[ $p == $g ]] && return 0; done
  return 1
}

RULES=""
classify() { # pkg -> "ALLOW" | "DENY <why>" | "UNKNOWN"
  local p="$1" verdict glob allow=""
  matches_any "$p" "$CORE_DENY" && { echo "DENY core system app"; return; }
  [ "$PHONE" = 1 ] && matches_any "$p" "$PHONE_DENY" && { echo "DENY needed for calls/SMS on a phone"; return; }
  while IFS="$(printf '\t')" read -r verdict glob; do
    [[ $p == $glob ]] || continue
    [ "$verdict" = DENY ] && { echo "DENY on the NEVER list"; return; }
    allow=1
  done <<< "$RULES"
  [ -n "$allow" ] && echo ALLOW || echo UNKNOWN
}

a() { adb -s "$SERIAL" "$@" 2>&1 | tr -d '\r'; }

healthy() { # device responds, System UI is running, a real home screen resolves
  local out
  out=$(a shell 'echo ALIVE; { ps -A; ps; } 2>/dev/null | grep -c com.android.systemui;
    cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME 2>/dev/null | tail -n 1')
  echo "$out" | grep -q '^ALIVE$' || { echo "device not responding"; return 1; }
  [ "$(echo "$out" | sed -n 2p)" -gt 0 ] 2>/dev/null || { echo "System UI not running"; return 1; }
  if [ "$SDK" -ge 24 ]; then
    echo "$out" | sed -n 3p | grep -qiE 'FallbackHome|ResolverActivity|No activity|^$' && { echo "no home screen"; return 1; }
  fi
  return 0
}

device_setup() {
  [ -n "$SERIAL" ] || die "pass -s SERIAL (see: adb devices)"
  [ "$(a get-state)" = device ] || die "device $SERIAL not connected or not authorized"
  SDK=$(a shell getprop ro.build.version.sdk)
  [ "$SDK" -ge 21 ] 2>/dev/null || die "Android 5.0+ needed (sdk=$SDK)"
  a shell pm list features | grep -q 'feature:android.hardware.telephony$' && PHONE=1 || PHONE=0
  INSTALLED=$(a shell pm list packages | sed 's/^package://')
}

selftest() {
  local fails=0
  t() { local got; got=$(classify "$1"); [ "${got%% *}" = "$2" ] || { echo "FAIL $1 (phone=$PHONE): want $2, got $got"; fails=$((fails+1)); }; }
  PHONE=0
  t com.samsung.android.game.gamehome ALLOW;  t com.miui.msa.global ALLOW;  t com.facebook.appmanager ALLOW
  t com.amazon.mShop.android.shopping ALLOW; t com.samsung.android.messaging DENY
  t com.sec.android.app.launcher DENY;        t com.miui.securitycenter DENY; t com.coloros.safecenter DENY
  t com.android.systemui DENY;                t com.google.android.gms DENY;  t com.samsung.android.honeyboard DENY
  t com.google.android.inputmethod.latin DENY; t com.android.providers.media DENY; t com.samsung.android.lool DENY
  t com.example.unknownthing UNKNOWN
  PHONE=1
  t com.samsung.android.dialer DENY;          t com.samsung.android.app.contacts DENY; t com.hiya.star DENY
  t com.samsung.android.game.gamehome ALLOW
  [ $fails = 0 ] && echo "selftest: all passed" || { echo "selftest: $fails failed"; exit 1; }
}

SERIAL=""
[ "$1" = "-s" ] && { SERIAL="$2"; shift 2; }
CMD="$1"; shift
[ -f "$LIST" ] || die "missing $LIST"
RULES=$(rules)

case "$CMD" in
  selftest) selftest ;;

  check)
    device_setup
    for p in "$@"; do
      echo "$INSTALLED" | grep -qx "$p" || { echo "NOT-INSTALLED  $p"; continue; }
      printf '%-14s %s\n' "$(classify "$p")" "$p"
    done ;;

  remove)
    LOG="$1"; shift; [ -n "$LOG" ] || die "remove needs LOGFILE"
    device_setup
    why=$(healthy) || die "device unhealthy BEFORE starting ($why). Not touching anything."
    [ -f "$LOG" ] || echo "# Restore one: adb shell pm install-existing <pkg>   (or: debloat.sh -s SERIAL restore $LOG)" > "$LOG"
    ok=0; skipped=0
    for p in "$@"; do
      echo "$INSTALLED" | grep -qx "$p" || { echo "skip (not installed)  $p"; continue; }
      v=$(classify "$p")
      [ "$v" = ALLOW ] || { echo "REFUSED ($v)  $p"; skipped=$((skipped+1)); continue; }
      r=$(a shell pm uninstall --user 0 "$p")
      [ "$r" = Success ] || { echo "failed ($r)  $p"; continue; }
      echo "$p" >> "$LOG"
      if why=$(healthy); then echo "removed  $p"; ok=$((ok+1)); continue; fi
      echo "!! device unhealthy after removing $p ($why). Restoring it and STOPPING."
      a shell pm install-existing "$p" >/dev/null; sed -i.bak "/^$p\$/d" "$LOG" && rm -f "$LOG.bak"
      healthy >/dev/null && echo "restored $p, device healthy again" || echo "!! still unhealthy: run restore on $LOG"
      echo "removed=$ok refused=$skipped (stopped early)"; exit 2
    done
    echo "removed=$ok refused=$skipped log=$LOG" ;;

  restore)
    LOG="$1"; shift; device_setup
    pkgs="$*"; [ -n "$pkgs" ] || pkgs=$(grep -v '^#' "$LOG")
    for p in $pkgs; do echo "$p  $(a shell pm install-existing "$p" | tail -n 1)"; done ;;

  *) sed -n 2,9p "$0"; exit 1 ;;
esac
