#
# CopyQ is an advanced clipboard manager with powerful editing and scripting features.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    copyq.enable = mkEnableOption "Enables CopyQ";
  };

  config = mkIf config.copyq.enable {
    home.packages = with pkgs; [copyq];

    # Built-in copyq service is broken on wayland, need to
    # create one manually.
    services.copyq.enable = false;
    systemd.user.services.copyq = {
      Unit = {
        Description = "CopyQ clipboard management daemon";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };

      Service = {
        ExecStart = "${getExe pkgs.copyq}";
        Restart = "on-failure";
        Environment = ["QT_QPA_PLATFORM=wayland"];
      };

      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };

    # Add keybind.
    programs.niri.settings.binds = with config.lib.niri.actions;
      mkIf config.niri.enable {
        "Mod+V".action = spawn ["${getExe pkgs.copyq}" "toggle"];
      };

    # Make window floating.
    programs.niri.settings.window-rules = mkIf config.niri.enable [
      {
        matches = [
          {
            app-id = "^com.github.hluk.copyq$";
          }
        ];
        open-floating = true;
        default-column-width = {fixed = 500;};
        default-window-height = {fixed = 800;};
      }
    ];

    home.file.".config/copyq/copyq.conf" = {
      text = ''
        [General]
        plugin_priority=itemimage, itemencrypted, itemnotes, itempinned, itemsync, itemtags, itemtext

        [Options]
        activate_closes=true
        activate_focuses=true
        activate_item_with_single_click=false
        activate_pastes=true
        always_on_top=true
        autocompletion=true
        autostart=false
        change_clipboard_owner_delay_ms=150
        check_clipboard=true
        check_selection=false
        clipboard_notification_lines=0
        clipboard_tab=&clipboard
        close_on_unfocus=false
        close_on_unfocus_delay_ms=500
        command_history_size=100
        confirm_exit=true
        copy_clipboard=false
        copy_selection=false
        disable_tray=false
        edit_ctrl_return=true
        editor=gedit --standalone -- %1
        expire_tab=0
        filter_case_insensitive=true
        filter_regular_expression=false
        hide_main_window=false
        hide_main_window_in_task_bar=false
        hide_tabs=true
        hide_toolbar=false
        hide_toolbar_labels=true
        item_popup_interval=2
        language=en
        max_process_manager_rows=1000
        maxitems=200
        move=true
        native_menu_bar=true
        native_notifications=true
        native_tray_menu=false
        notification_horizontal_offset=10
        notification_maximum_height=100
        notification_maximum_width=300
        notification_position=0
        notification_vertical_offset=10
        number_search=false
        open_windows_on_current_screen=true
        restore_geometry=true
        row_index_from_one=true
        run_selection=true
        save_delay_ms_on_item_added=300000
        save_delay_ms_on_item_edited=1000
        save_delay_ms_on_item_modified=300000
        save_delay_ms_on_item_moved=1800000
        save_delay_ms_on_item_removed=600000
        save_filter_history=false
        save_on_app_deactivated=true
        script_paste_delay_ms=250
        show_advanced_command_settings=false
        show_simple_items=false
        show_tab_item_count=true
        style=
        tab_tree=true
        tabs=&clipboard
        text_tab_width=8
        text_wrap=true
        transparency=0
        transparency_focused=0
        tray_commands=true
        tray_images=true
        tray_item_paste=true
        tray_items=5
        tray_menu_open_on_left_click=false
        tray_tab=
        tray_tab_is_current=true
        vi=false
        window_key_press_time_ms=50
        window_paste_with_ctrl_v_regex=
        window_wait_after_raised_ms=50
        window_wait_before_raise_ms=20
        window_wait_for_modifier_released_ms=2000
        window_wait_raised_ms=150

        [Plugins]
        itemencrypted\enabled=true
        itemimage\enabled=true
        itemimage\image_editor=
        itemimage\max_image_height=240
        itemimage\max_image_width=320
        itemimage\svg_editor=
        itemnotes\enabled=true
        itempinned\enabled=true
        itemsync\enabled=true
        itemtags\enabled=true
        itemtext\enabled=true

        [Shortcuts]
        about=shift+f1
        change_tab_icon=ctrl+shift+t
        commands=f6
        copy_selected_items=ctrl+c
        delete_item=del
        edit=f2
        edit_notes=shift+f2
        editor=ctrl+e
        editor_background=
        editor_bold=ctrl+b
        editor_cancel=esc
        editor_erase_style=
        editor_font=
        editor_foreground=
        editor_italic=ctrl+i
        editor_redo=ctrl+shift+z
        editor_save=f2
        editor_search=ctrl+f
        editor_strikethrough=
        editor_underline=ctrl+u
        editor_undo=ctrl+z
        exit=ctrl+q
        export=ctrl+s
        find_items=f3
        help=f1
        import=ctrl+i
        item-menu=shift+f10
        move_down=ctrl+down
        move_to_bottom=ctrl+end
        move_to_clipboard=
        move_to_top=ctrl+home
        move_up=ctrl+up
        new=ctrl+n
        new_tab=ctrl+t
        next_tab=right
        paste_selected_items=ctrl+v
        preferences=ctrl+p
        previous_tab=left
        process_manager=ctrl+shift+z
        remove_tab=ctrl+w
        rename_tab=ctrl+f2
        reverse_selected_items=ctrl+shift+r
        show-log=f12
        show_clipboard_content=ctrl+shift+c
        show_item_content=f4
        show_item_preview=f7
        sort_selected_items=ctrl+shift+s
        system-run=f5
        toggle_clipboard_storing=ctrl+shift+x

        [Tabs]
        1\icon=
        1\max_item_count=0
        1\name=&clipboard
        1\store_items=true
        size=1
      '';
    };
  };
}
