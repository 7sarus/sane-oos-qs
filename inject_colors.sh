#!/system/bin/sh
# Color / Accent Injection

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

# Theme Hooks
apply_overlay com.android.systemui qs_theme_bool "com.android.systemui:bool/status_bar_qs_icon_bg_drawable_global_theme" 0x12 1

# Static Whites & AMOLED Tones
for res in dark_mode_qs_icon_color_single_tone light_mode_qs_icon_color_single_tone notification_color_primary_neutral_default smart_reply_button_text op_pm_tint_color op_pm_turquoise; do
  apply_overlay com.android.systemui "qs_white_$res" "com.android.systemui:color/$res" 0x1c 0xffffffff
done

for res in status_bar_qs_brightness_slider_bg_color status_bar_qs_brightness_slider_mirror_bg_color status_bar_qs_brightness_toggle_normal_bg_color status_bar_qs_tile_bg_color_inactive; do
  apply_overlay com.android.systemui "qs_amoled_$res" "com.android.systemui:color/$res" 0x1c 0x33ffffff
done

for res in system_neutral1_900 system_neutral2_900 system_neutral1_800 system_neutral2_800 system_neutral1_1000 system_neutral2_1000; do
  apply_overlay android "md3_amoled_$res" "android:color/$res" 0x1c 0xff000000
done

# Dynamic Accent Overlays
ACCENT_HEX=$(cmd overlay lookup android android:color/system_accent1_500 2>/dev/null | tail -n 1 | tr -d '\r\n')
case "$ACCENT_HEX" in
  \#*)
    ACCENT_INT="0x${ACCENT_HEX#\#}"
    ACCENT_RGB=$(printf "%s" "$ACCENT_HEX" | sed "s/^#..//")
    ACCENT_SOFT_INT="0x66$ACCENT_RGB"
    ACCENT_FAINT_INT="0x33$ACCENT_RGB"

    for res in \
      status_bar_qs_tile_bg_color_active \
      status_bar_qs_tile_accent_color_default \
      status_bar_qs_tile_accent_color_default_one_plus_ext \
      coui_color_primary_blue \
      coui_color_primary_blue_dark \
      couiBlueTintControlNormal \
      brightness_slider_track \
      brightness_slider_overlay_color \
      status_bar_qs_brightness_slider_progress_color \
      status_bar_qs_brightness_slider_mirror_progress_color \
      status_bar_qs_brightness_toggle_checked_bg_color \
      qs_seekbar_progress_color \
      oplus_volume_seekbar_progress \
      oplus_volume_bar_progress_background \
      oplus_super_volume_seekbar_progress_start \
      oplus_super_volume_seekbar_progress_end \
      coui_button_sub_disable \
      notification_action_rounded_bg_color \
      smart_reply_button_stroke \
      smart_reply_button_background; do
        apply_overlay com.android.systemui "qs_accent_${res}" "com.android.systemui:color/$res" 0x1c "$ACCENT_INT"
    done

    for res in m3_slider_active_track_color material_slider_active_track_color; do
      apply_overlay com.android.systemui "qs_accent_${res}" "com.android.systemui:color/$res" 0x1c "$ACCENT_INT"
    done

    for res in m3_slider_thumb_color m3_slider_active_tick_marks_color material_slider_thumb_color material_slider_active_tick_marks_color; do
      apply_overlay com.android.systemui "qs_accent_${res}" "com.android.systemui:color/$res" 0x1c "$ACCENT_INT"
    done

    for res in m3_slider_inactive_track_color material_slider_inactive_track_color material_slider_halo_color; do
      apply_overlay com.android.systemui "qs_accent_${res}" "com.android.systemui:color/$res" 0x1c "$ACCENT_FAINT_INT"
    done

    for res in m3_slider_inactive_tick_marks_color material_slider_inactive_tick_marks_color; do
      apply_overlay com.android.systemui "qs_accent_${res}" "com.android.systemui:color/$res" 0x1c "$ACCENT_SOFT_INT"
    done
    ;;
esac
