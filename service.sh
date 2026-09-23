#!/system/bin/sh
MODDIR=${0%/*}
LOG_DIR="/data/local/tmp/sane-oos-qs"

mkdir -p "$LOG_DIR" 2>/dev/null

if [ -f "$MODDIR/disable" ]; then
  echo "OxygenOS QS module safe-disable active; service skipped" > "$LOG_DIR/service-skipped.txt" 2>/dev/null
  chmod 0644 "$LOG_DIR/service-skipped.txt" 2>/dev/null
  exit 0
fi

# Wait until device has finished booting
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 1
done
sleep 3

# 1. Enable RRO overlay APK if mounted
cmd overlay enable --user current com.oxygenos.qs.sixcolumns.overlay 2>/dev/null || cmd overlay enable com.oxygenos.qs.sixcolumns.overlay 2>/dev/null
cmd overlay set-priority com.oxygenos.qs.sixcolumns.overlay highest 2>/dev/null

# 2. Inject all fabricated overlays
sh $MODDIR/inject_columns.sh
sh $MODDIR/inject_colors.sh

# 3. Dynamic Accent Watcher
LAST_ACCENT=$(cmd overlay lookup android android:color/system_accent1_500 2>/dev/null | tail -n 1 | tr -d '\r\n')
while true; do
  sleep 30
  CURRENT_ACCENT=$(cmd overlay lookup android android:color/system_accent1_500 2>/dev/null | tail -n 1 | tr -d '\r\n')
  case "$CURRENT_ACCENT" in
    \#*)
      if [ "$CURRENT_ACCENT" != "$LAST_ACCENT" ]; then
        sh $MODDIR/inject_colors.sh
        LAST_ACCENT="$CURRENT_ACCENT"
      fi
      ;;
  esac
done
