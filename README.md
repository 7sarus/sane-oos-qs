The QS situation on OxygenOS is messy and getting worse.

# sane-oos-qs

`sane-oos-qs` is a KernelSU module that keeps the OxygenOS Quick Settings panel focused and predictable:

- Sets Quick Settings and QQS columns to 6 in portrait and landscape.
- Applies a consistent system-accent color path for active QS tiles and sliders.
- Keeps brightness and volume theming inside the QS scope.
- Does not include the removed iOS/status-bar icon overlay scope.
- Does not reboot or restart SystemUI from its scripts.

Maintainer: `7sarus <63068332+7sarus@users.noreply.github.com>`

## Build

```sh
./build.sh
```

The output archive is:

```text
sane-oos-qs.zip
```

## Install With ADB

```sh
adb devices -l
adb push sane-oos-qs.zip /data/local/tmp/sane-oos-qs.zip
adb shell su -c '/data/adb/ksud module install /data/local/tmp/sane-oos-qs.zip'
```

If KernelSU reports a disabled metamodule blocker, re-enable that metamodule first from KernelSU Manager or with `ksud module enable <id>`, then rerun the install command.

## Verify

```sh
adb shell su -c '/data/adb/ksud module list'
adb shell su -c 'cmd overlay lookup com.android.systemui com.android.systemui:integer/quick_settings_num_columns'
adb shell su -c 'cmd overlay lookup com.android.systemui com.android.systemui:color/status_bar_qs_brightness_slider_bg_color'
```

Expected quick checks:

- Module ID: `sane-oos-qs`
- QS columns lookup: `6`
- Brightness inactive track lookup: `#33ffffff`
