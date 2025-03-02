{inputs, ...}: final: prev: {
  # GNOME 47: triple-buffering-v4-47
  mutter = prev.mutter.overrideAttrs (old: {
    src = inputs.mutter-triple-buffering-src;
    preConfigure = ''
      cp -a "${inputs.gvdb-src}" ./subprojects/gvdb
    '';
  });
}
