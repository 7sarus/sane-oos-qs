SKIPUNZIP=0

if [ -f "$MODPATH/disable" ]; then
  ui_print "- Safe-disable flag found; runtime overlay apply skipped"
  exit 0
fi

ui_print "- Installing sane-oos-qs module"
ui_print "- Applying permissions..."
set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/post-fs-data.sh" 0 0 0755
set_perm "$MODPATH/service.sh" 0 0 0755
set_perm "$MODPATH/action.sh" 0 0 0755
set_perm "$MODPATH/uninstall.sh" 0 0 0755
set_perm "$MODPATH/inject_columns.sh" 0 0 0755
set_perm "$MODPATH/inject_colors.sh" 0 0 0755

ui_print "- Applying unified overlay injections..."
sh $MODPATH/inject_columns.sh
sh $MODPATH/inject_colors.sh

ui_print "- Full accent theme applied without restarting SystemUI"
