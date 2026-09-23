#!/system/bin/sh
# 6 Columns Layout Injection

apply_overlay() {
  local target="$1"
  local name="$2"
  local res_path="$3"
  local val_type="$4"
  local val="$5"

  cmd overlay fabricate --target "$target" --name "$name" "$res_path" "$val_type" "$val" 2>/dev/null
  cmd overlay enable --user current "com.android.shell:$name" 2>/dev/null || cmd overlay enable "com.android.shell:$name" 2>/dev/null
  cmd overlay set-priority "com.android.shell:$name" highest 2>/dev/null
}

for col in quick_settings_num_columns quick_settings_dual_shade_num_columns quick_settings_infinite_grid_num_columns quick_settings_split_shade_num_columns; do
  apply_overlay com.android.systemui "qs6_${col}" "com.android.systemui:integer/$col" 0x10 6
done
apply_overlay com.android.systemui "qs6_qqs_tiles" "com.android.systemui:integer/quick_qs_panel_max_tiles" 0x10 6
