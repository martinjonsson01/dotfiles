{
  windowrulev2 = [
    # Window floating and layout
    "float, class:^(pavucontrol)$"
    "float, class:^(thunar)$"
    "float, class:^(obs)$"
    "float, class:^(eog)$"
    "float, class:^(blueman-manager)$"
    "float, class:^(nm-connection-editor)$"
    "float, class:^(rhythmbox)$"
    "size 1000 640, class:^(rhythmbox)$"
    "float, title:^(File Transfer*)$"
    "float, title:^(Lxappearance)$"
    "pin, title:^(Lxappearance)$"
    "idleinhibit focus, fullscreen:1"

    # Make context menus opaque
    "opaque,class:(),title:()"
    "noshadow,class:(),title:()"
    "noblur,class:(),title:()"

    # Window placement
    "workspace silent special, title:^(updater)$, class:^(kitty)$"
    "workspace 5, class:^(rhythmbox)$"
    "workspace 7, class:^(Gimp)$"
    "workspace 9, class:^(obs)$"
    # "noborder, title:^(Syncthing Tray( \(.*\))?)$"
    # "size 550 400, title:^(Syncthing Tray( \(.*\))?)$"
    # "move 1365 30, title:^(Syncthing Tray( \(.*\))?)$"
    # "move 1465 30, title:^(Nextcloud)$, class:^(Nextcloud)$"
  ];
}
