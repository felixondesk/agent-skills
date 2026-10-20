# Bloatware reference

Tiers:
- **SAFE**: removing it loses nothing most people use.
- **CAUTION**: it's a real feature. Ask the person, and tell them what they lose.
- **NEVER**: removing it breaks the device (black screen, boot loop, no calls, no app installs). Don't remove it, even on request.

A package that isn't listed is KEEP. If a package's name looks like a framework, provider, overlay or resource (`*.providers.*`, `*overlay*`, `*.resources`, `*framework*`, `*service*` you don't recognise), it's KEEP.

---

## NEVER (all brands)

| Package | Why |
|---|---|
| `android`, `com.android.systemui`, `com.android.settings` | Core OS, status bar, Settings. The device won't work. |
| `com.android.phone`, `com.android.server.telecom`, `com.android.providers.telephony` | Calls and SMS stop, and the phone may restart in a loop |
| `com.android.providers.*`, `com.google.android.providers.*`, `com.samsung.android.providers.*` | Storage for contacts, media, settings and downloads. Apps lose their data. |
| `com.android.vending`, `com.google.android.gms`, `com.google.android.gsf` | Play Store and Play Services. Most apps (WhatsApp, banking) stop working. |
| `com.google.android.webview` / `com.android.webview` | Many apps can't show web pages, logins or ads, and they crash |
| `com.google.android.packageinstaller`, `com.android.packageinstaller`, `*permissioncontroller*` | You can't install apps or grant permissions |
| `com.android.externalstorage`, `com.android.mtp`, `com.google.android.documentsui` | File access and USB file transfer break |
| `com.android.shell` | ADB itself. It would cut off our connection. |
| `com.android.bluetooth`, `com.android.nfc`, `*.wifi.*`, `com.google.android.networkstack*`, `com.android.networkstack*` | Bluetooth, NFC, Wi-Fi or networking breaks |
| `*setupwizard*`, `com.google.android.setupwizard` | It can break factory reset and new-user setup |
| `com.google.android.ext.services`, `com.google.android.ext.shared`, `com.google.android.modulemetadata` | System modules |
| Any home-screen launcher (see the brand sections) | Black screen with no home screen. Only remove it after a replacement launcher is installed and opened. |
| Any keyboard that's the only keyboard | You can't type, even your PIN on some devices |
| Dialer / incallui / messaging **on a phone** | You can't make or answer calls or read SMS (OTP). On a Wi-Fi-only tablet these are CAUTION instead. |

---

## Google apps

| Package | Tier | Notes |
|---|---|---|
| `com.google.android.apps.tachyon` | SAFE | Duo / Meet preinstall |
| `com.google.android.feedback` | SAFE | Sends feedback reports to Google |
| `com.google.android.apps.turbo` | SAFE | "Device Health Services". Adaptive battery predictions are a minor loss. |
| `com.google.ar.core` | SAFE | AR. Only some games and Google Lens AR use it. |
| `com.google.android.apps.subscriptions.red` | SAFE | Google One promo |
| `com.google.android.apps.podcasts`, `com.google.android.music`, `com.google.android.videos`, `com.google.android.apps.magazines` | SAFE | Old media apps |
| `com.google.android.apps.wellbeing` | CAUTION | Digital Wellbeing / screen time / bedtime mode |
| `com.google.android.googlequicksearchbox` | CAUTION | Google app: search bar, Assistant, "Hey Google", Discover. Uses about 100 MB RAM. Search still works in Chrome. |
| `com.google.android.apps.photos` | CAUTION | Google Photos backup. The phone's gallery still shows photos. |
| `com.google.android.youtube` | CAUTION | YouTube. Keep it unless they use an alternative (TizenTube, a browser). |
| `com.google.android.apps.youtube.music` | CAUTION | YouTube Music |
| `com.google.android.gm` | CAUTION | Gmail (about 100 MB RAM while syncing). Mail works in a browser. |
| `com.google.android.apps.maps` | CAUTION | Maps. Also used by apps that show maps and by location sharing. |
| `com.google.android.apps.docs*`, `com.google.android.keep` | CAUTION | Drive / Docs / Keep |
| `com.android.chrome` | CAUTION | Only remove it if another browser is installed and set as default |
| `com.google.android.tts` | CAUTION | Text-to-speech, used by Maps voice and accessibility |
| `com.google.android.marvin.talkback` | CAUTION | Screen reader. Keep it for anyone who needs accessibility. |
| `com.google.android.inputmethod.latin` | NEVER if it's the only keyboard | Gboard |
| `com.google.android.apps.nexuslauncher` | NEVER | Pixel home screen |

## Partner / preinstalled third-party (any brand)

| Package | Tier | Notes |
|---|---|---|
| `com.facebook.katana`, `com.facebook.appmanager`, `com.facebook.services`, `com.facebook.system` | SAFE | Facebook and its hidden background updaters. Keep `com.facebook.katana` if they use Facebook. |
| `com.netflix.partner.activation` | SAFE | Netflix preinstall stub. It isn't the Netflix app. |
| `com.netflix.mediaclient`, `in.startv.hotstar`, `com.amazon.*`, `com.spotify.music` | CAUTION | Real apps. Ask. |
| `com.microsoft.skydrive`, `com.microsoft.office.*`, `com.linkedin.android` | SAFE unless used | OneDrive / Office / LinkedIn preinstalls |
| `com.hiya.star` | SAFE on a tablet, CAUTION on a phone | Samsung's caller ID / spam detection |
| `com.booking`, `com.tripadvisor.*`, `com.agoda.*`, `com.dailyhunt.*`, `com.glance.*`, `com.inmobi.*`, `com.moj.*`, `com.sharechat.*`, `in.mohalla.*` | SAFE | Ads and preinstalled promos, very common in India |
| Carrier apps (`com.jio.*`, `com.airtel.*`, `com.vodafone.*`, `com.myairtelapp`) | CAUTION | Carrier self-care apps. Usually safe, but ask. |

---

## Samsung (One UI)

**NEVER:** `com.sec.android.app.launcher` (home screen), `com.samsung.android.honeyboard` (keyboard, unless replaced), `com.samsung.android.knox.containercore`, `com.samsung.android.knox.attestation` (Knox core, which many system features check), `com.samsung.android.biometrics.app.setting`, `com.samsung.android.providers.*`, `com.sec.android.provider.*`, `com.samsung.android.lool` (Device Care, which Settings depends on), `com.samsung.android.themecenter` (wallpapers and themes break), `com.sec.android.app.SecSetupWizard`, `com.samsung.android.incallui` / `com.samsung.android.dialer` / `com.samsung.android.messaging` **on phones**, `com.samsung.android.app.telephonyui`, `com.sec.imsservice` (VoLTE calls on phones), `com.samsung.android.app.galaxyfinder` (Settings search), `com.samsung.android.scs` (search core), `com.sec.android.app.myfiles`, `com.sec.android.app.camera`, `com.samsung.android.app.updatecenter`, `com.wssyncmldm` (software update), `com.samsung.android.bluelightfilter`, `com.samsung.android.wallpaper.res`, `com.android.wallpaper.livepicker`.

| Package | Tier | What it is |
|---|---|---|
| `com.samsung.android.app.settings.bixby`, `com.samsung.android.bixby.*`, `com.samsung.android.visionintelligence`, `com.samsung.systemui.bixby2` | SAFE | Bixby |
| `com.samsung.android.rubin.app` | SAFE | "Customization Service" (usage profiling) |
| `com.samsung.storyservice` | SAFE | Gallery auto-stories |
| `com.samsung.android.stickercenter`, `com.sec.android.app.camera.sticker`, `com.samsung.android.app.dressroom` | SAFE | Stickers, AR Zone, wallpaper "dress room" |
| `com.samsung.android.dynamiclock`, `com.samsung.android.service.peoplestripe` | SAFE | Dynamic lock screen, People edge |
| `com.samsung.android.game.gamehome`, `com.samsung.android.game.gametools`, `com.samsung.android.game.gos` | SAFE | Game Launcher, Game Booster, Game Optimizing Service (known to throttle) |
| `com.samsung.android.app.appsedge`, `com.samsung.android.app.taskedge`, `com.samsung.android.app.clipboardedge`, `com.samsung.android.app.cocktailbarservice` | CAUTION | Edge panels. Some people like them. |
| `com.sec.android.app.kidshome`, `com.samsung.android.kidsinstaller` | SAFE unless kids use it | Samsung Kids |
| `com.sec.android.diagmonagent`, `com.samsung.android.dqagent`, `com.samsung.android.knox.analytics.uploader`, `com.samsung.android.bbc.bbcagent`, `com.samsung.android.beaconmanager` | SAFE | Telemetry and diagnostics |
| `com.samsung.android.app.watchmanagerstub` | SAFE | Galaxy Wearable stub |
| `com.samsung.android.scloud` | CAUTION | Samsung Cloud backup |
| `com.sec.android.easyMover.Agent`, `com.samsung.android.smartswitchassistant` | SAFE | Smart Switch (only needed when moving to a new phone) |
| `com.samsung.android.easysetup` | SAFE | Nearby device setup popups |
| `com.sec.android.widgetapp.webmanual` | SAFE | User manual |
| `com.samsung.android.video`, `com.sec.android.mimage.photoretouching`, `com.sec.android.app.ve.vebgm` | CAUTION | Samsung video player, photo editor, video editor music. Gallery "Edit" uses the photo editor. |
| `com.sec.android.app.voicenote` | CAUTION | Voice Recorder |
| `com.samsung.android.app.notes`, `com.samsung.android.app.notes.addons` | CAUTION | Samsung Notes (keep it for S Pen users) |
| `com.samsung.SMT` | SAFE if Google TTS is present | Samsung text-to-speech |
| `com.sec.android.app.chromecustomizations` | SAFE | Chrome bookmarks preset |
| `com.samsung.android.mdx.kit`, `com.samsung.android.mdx.quickboard`, `com.samsung.android.mdecservice` | CAUTION | Link to Windows, call/text on other devices |
| `com.samsung.knox.securefolder` | CAUTION | Secure Folder. **Ask first: anything stored inside it is lost.** |
| `com.sec.android.app.samsungapps` | CAUTION | Galaxy Store. Samsung's own apps then only update through system updates. |
| `com.samsung.android.mobileservice` | CAUTION | Samsung Experience Service (needed for a Samsung account, Together, sharing) |
| `com.samsung.android.app.sharelive`, `com.samsung.android.privateshare` | CAUTION | Quick Share / Private Share |
| `com.samsung.android.smartmirroring` | CAUTION | Smart View (cast screen to TV) |
| `com.samsung.android.fmm` | CAUTION | Find My Mobile (anti-theft). Recommend KEEP on phones. |
| `com.samsung.android.forest` | CAUTION | Digital Wellbeing |
| `com.samsung.android.app.contacts`, `com.samsung.android.calendar` | CAUTION | Contacts / Calendar apps. The data stays in the providers. |
| `com.samsung.android.app.tips`, `com.samsung.android.app.spage` | SAFE | Tips, Samsung Free / Bixby Home |
| `com.samsung.android.ardrawing`, `com.samsung.android.aremoji`, `com.samsung.android.livestickers` | SAFE | AR Doodle, AR Emoji |
| `com.samsung.android.spay`, `com.samsung.android.samsungpass` | CAUTION | Samsung Pay/Wallet, Samsung Pass (passwords) |
| `com.samsung.android.app.routines` | CAUTION | Modes & Routines |
| `com.samsung.android.oneconnect` | CAUTION | SmartThings |
| `com.android.egg`, `com.android.dreams.phototable` | SAFE | Easter egg, photo screensaver |

## Xiaomi / Redmi / POCO (MIUI / HyperOS)

**Xiaomi is the brand where mistakes cause boot loops.** Be extra careful.

**NEVER:** `com.miui.home` (home screen), `com.miui.securitycenter` (boot loop), `com.miui.securitycore`, `com.miui.guardprovider`, `com.lbe.security.miui` (permissions), `com.miui.core`, `com.miui.system`, `com.miui.rom`, `com.xiaomi.misettings`, `com.android.thememanager` on HyperOS (wallpaper and lock screen break), `com.miui.powerkeeper` (battery manager, may boot loop), `com.miui.securityadd`, `com.xiaomi.xmsf`, `com.miui.miwallpaper`, `com.miui.gallery` (the system photo picker on some versions), `com.android.updater`.

| Package | Tier | What it is |
|---|---|---|
| `com.miui.msa.global`, `com.miui.analytics`, `com.miui.daemon`, `com.xiaomi.joyose` | SAFE | MIUI System Ads, analytics, profiling. `msa` is the ads engine. |
| `com.miui.hybrid`, `com.miui.hybrid.accessory` | SAFE | Quick Apps (ads) |
| `com.mi.globalbrowser`, `com.android.browser` | SAFE if Chrome is present | Mi Browser (ads) |
| `com.miui.videoplayer`, `com.miui.player` | CAUTION | Mi Video / Mi Music (ads) |
| `com.xiaomi.glgm` | SAFE | Games |
| `com.mi.global.bbs`, `com.mi.global.shop`, `com.xiaomi.mipicks` | SAFE | Mi Community, Mi Store, GetApps (ads) |
| `com.miui.yellowpage`, `com.miui.compass` | SAFE | Yellow pages, compass |
| `com.miui.bugreport`, `com.miui.miservice` | SAFE | Feedback, services and feedback |
| `com.miui.weather2`, `com.miui.notes`, `com.miui.cleanmaster`, `com.miui.fm` | CAUTION | Weather, Notes, Cleaner (part of Security on some versions, so if unsure KEEP), FM radio |
| `com.miui.cloudservice`, `com.miui.cloudbackup`, `com.miui.micloudsync` | CAUTION | Mi Cloud |
| `com.xiaomi.finddevice` | CAUTION | Find Device (anti-theft). Recommend KEEP. |
| `com.xiaomi.payment`, `com.mipay.wallet.in` | CAUTION | Mi Pay |
| `com.miui.android.fashiongallery` | SAFE | Wallpaper carousel / Glance lock screen ads |
| `com.facebook.*` preinstalls | SAFE | See the partner section |

## Realme / Oppo / OnePlus (ColorOS / Realme UI / OxygenOS 12+)

**NEVER:** `com.oppo.launcher` / `com.android.launcher` / `net.oneplus.launcher` (home screen), `com.coloros.safecenter` (security, boot loop risk), `com.coloros.securitypermission`, `com.oplus.securitypermission`, `com.coloros.oppoguardelf` / `com.oplus.battery` (battery manager), `com.oppo.ota` / `com.oplus.ota` (updates), `com.coloros.filemanager`, `com.android.settings`, `com.oplus.appplatform`, `com.heytap.openid`, `com.coloros.phonemanager` on some versions (if unsure KEEP), `com.oplus.wallpapers`.

| Package | Tier | What it is |
|---|---|---|
| `com.heytap.market`, `com.oppo.market` | CAUTION | App Market (ads, but it updates system apps on some versions) |
| `com.heytap.browser`, `com.nearme.browser` | SAFE if Chrome is present | Browser (ads) |
| `com.heytap.music`, `com.oppo.music`, `com.coloros.video`, `com.heytap.yoli` | CAUTION | Music / video players |
| `com.nearme.gamecenter`, `com.coloros.gamespace`, `com.oplus.games` | SAFE | Game Center / Game Space |
| `com.heytap.pictorial`, `com.coloros.pictorial` | SAFE | Lock screen magazine / wallpaper ads |
| `com.coloros.assistantscreen`, `com.oplus.assistantscreen` | SAFE | Smart Assistant (left swipe panel) |
| `com.coloros.weather2`, `com.coloros.compass2`, `com.coloros.soundrecorder`, `com.coloros.note` | CAUTION | Weather, compass, recorder, notes |
| `com.heytap.cloud`, `com.coloros.cloud` | CAUTION | HeyTap Cloud |
| `com.coloros.findmyphone`, `com.oplus.findphone` | CAUTION | Find My Phone. Recommend KEEP. |
| `com.heytap.usercenter` | CAUTION | HeyTap / Realme account |
| `com.realme.link`, `com.oppo.store`, `com.heytap.store` | SAFE | Store / community |
| `com.coloros.feedback`, `com.oplus.logkit` | SAFE | Feedback and logs |

## Vivo / iQOO (Funtouch OS / OriginOS)

**NEVER:** `com.bbk.launcher2` (home screen), `com.iqoo.secure` (security, boot loop risk), `com.vivo.permissionmanager`, `com.vivo.abe` (battery), `com.bbk.updater` (updates), `com.vivo.daemonService`, `com.android.bbkmusic` on some versions (if unsure KEEP), `com.vivo.appfilter`.

| Package | Tier | What it is |
|---|---|---|
| `com.vivo.appstore` | CAUTION | V-Appstore (ads, but it updates some system apps) |
| `com.vivo.browser` | SAFE if Chrome is present | Browser (ads) |
| `com.vivo.hiboard` | SAFE | Jovi / left panel |
| `com.vivo.gamecube`, `com.vivo.game` | SAFE | Game space |
| `com.vivo.easyshare` | CAUTION | EasyShare |
| `com.vivo.weather`, `com.vivo.compass`, `com.android.bbksoundrecorder`, `com.android.notes` | CAUTION | Weather, compass, recorder, notes |
| `com.vivo.findphone` | CAUTION | Find Phone. Recommend KEEP. |
| `com.vivo.globalsearch` | CAUTION | Search |
| `com.vivo.wallet`, `com.vivo.space` | SAFE | Wallet, vivo Community |

## Motorola

**NEVER:** `com.motorola.launcher3` / `com.android.launcher3` (home screen), `com.motorola.ccc.ota` (updates), `com.motorola.motosignature.app`, `com.motorola.android.providers.*`.

| Package | Tier | What it is |
|---|---|---|
| `com.motorola.help`, `com.motorola.genie`, `com.motorola.demo` | SAFE | Help, Device Help, demo mode |
| `com.motorola.ccc.notification` | SAFE | Moto promotional notifications |
| `com.motorola.motocare`, `com.motorola.moto` | CAUTION | Moto app (gestures like chop for the torch and twist for the camera) |
| `com.motorola.gamemode` | SAFE | Gametime |

## Nokia / near-stock Android
Usually light. Remove only the Google/partner SAFE items above. NEVER: `com.android.launcher3` / `com.google.android.apps.nexuslauncher`.
