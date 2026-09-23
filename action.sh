#!/system/bin/sh
MODDIR=${0%/*}

if [ -f "$MODDIR/disable" ]; then
  exit 0
fi

sh $MODDIR/inject_columns.sh
sh $MODDIR/inject_colors.sh

echo "Done. Overlays applied without restarting SystemUI."
