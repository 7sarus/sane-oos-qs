#!/system/bin/sh
LOG_DIR="/data/local/tmp/sane-oos-qs"

mkdir -p "$LOG_DIR" 2>/dev/null
cat > "$LOG_DIR/removed.txt" <<EOF
sane-oos-qs removed
Rollback status: module uninstall requested
Systemless cleanup: overlay module removed by root manager
EOF
chmod 0644 "$LOG_DIR/removed.txt" 2>/dev/null

exit 0
