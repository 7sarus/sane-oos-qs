#!/system/bin/sh
MODDIR=${0%/*}
LOG_DIR="/data/local/tmp/sane-oos-qs"

mkdir -p "$LOG_DIR" 2>/dev/null
chmod 0755 "$LOG_DIR" 2>/dev/null

if [ -f "$MODDIR/disable" ]; then
  echo "OxygenOS QS module safe-disable active" > "$LOG_DIR/safe-mode.txt" 2>/dev/null
  chmod 0644 "$LOG_DIR/safe-mode.txt" 2>/dev/null
fi

exit 0
