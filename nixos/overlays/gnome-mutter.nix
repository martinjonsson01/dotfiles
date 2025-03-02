{inputs, ...}: final: prev: {
  # Fixes triple-buffering for Gnome 47.3 (should be included by default in Gnome 48)
  # https://nixos.wiki/wiki/GNOME#:~:text=specific%20dbus%20session.-,Dynamic%20triple%20buffering,-Big%20merge%20request
  mutter = prev.mutter.overrideAttrs (old: {
    src = inputs.mutter-triple-buffering-src;
    preConfigure = ''
      cp -a "${inputs.gvdb-src}" ./subprojects/gvdb
    '';
  });
}
