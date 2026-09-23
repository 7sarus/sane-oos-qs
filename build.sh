#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "=== Building sane-oos-qs KernelSU Module ==="

# Tool discovery
AAPT2="${AAPT2:-$HOME/Android/Sdk/build-tools/36.1.0/aapt2}"
ZIPALIGN="${ZIPALIGN:-$HOME/Android/Sdk/build-tools/36.1.0/zipalign}"
APKSIGNER="${APKSIGNER:-$HOME/Android/Sdk/build-tools/36.1.0/apksigner}"
ANDROID_JAR="${ANDROID_JAR:-$HOME/Android/Sdk/platforms/android-34/android.jar}"

for tool in "$AAPT2" "$ZIPALIGN" "$APKSIGNER" "$ANDROID_JAR"; do
    if [ ! -e "$tool" ]; then
        echo "Error: Required tool/file not found: $tool" >&2
        exit 1
    fi
done

# Prepare build directories
rm -rf build system sane-oos-qs.zip OxygenOS-QS-6-Columns.zip
mkdir -p build system/product/overlay

echo "[1/5] Compiling resources with aapt2..."
"$AAPT2" compile --dir src/res -o build/compiled_res.zip

echo "[2/5] Linking overlay APK..."
"$AAPT2" link -I "$ANDROID_JAR" \
    --manifest src/AndroidManifest.xml \
    -o build/unaligned.apk \
    build/compiled_res.zip

echo "[3/5] Aligning APK..."
"$ZIPALIGN" -f -p 4 build/unaligned.apk build/aligned.apk

echo "[4/5] Signing overlay APK..."
if [ ! -f testkey.keystore ]; then
    echo "  -> Generating local debug keystore..."
    keytool -genkeypair -v -keystore testkey.keystore \
        -storepass android -alias androiddebugkey -keypass android \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -dname "CN=Android Debug,O=Android,C=US" >/dev/null 2>&1
fi
"$APKSIGNER" sign --ks testkey.keystore --ks-pass pass:android --key-pass pass:android \
    --out build/OxygenOSQSSixColumns.apk build/aligned.apk

cp build/OxygenOSQSSixColumns.apk system/product/overlay/

echo "[5/5] Packaging KernelSU flashable zip..."
chmod 755 customize.sh post-fs-data.sh service.sh action.sh uninstall.sh inject_columns.sh inject_colors.sh
chmod 644 module.prop system/product/overlay/OxygenOSQSSixColumns.apk

zip -q -r sane-oos-qs.zip module.prop README.md customize.sh post-fs-data.sh service.sh action.sh uninstall.sh inject_columns.sh inject_colors.sh system

echo ""
echo "=== Build Complete! ==="
echo "Module archive: $(pwd)/sane-oos-qs.zip"

if [ "${1:-}" = "--install" ]; then
    if [ "${ALLOW_LIVE_INSTALL:-}" != "1" ]; then
        echo "Refusing live install by default. Set ALLOW_LIVE_INSTALL=1 to push/install manually." >&2
        exit 2
    fi
    echo ""
    echo "=== Flashing to connected device via KernelSU ==="
    adb push sane-oos-qs.zip /data/local/tmp/
    adb shell su -c "/data/adb/ksud module install /data/local/tmp/sane-oos-qs.zip"
    echo "Installed successfully!"
fi
