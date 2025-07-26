{
  xdg.mime.defaultApplications = {
    "text/*" = "org.gnome.TextEditor.desktop";
    "image/*" = "org.gnome.Loupe.desktop";
    "video/*" = "mpv.desktop";
    "audio/*" = "mpv.desktop";
    "application/pdf" = "google-chrome.desktop";
    "x-scheme-handler/http" = "google-chrome.desktop";
    "x-scheme-handler/https" = "google-chrome.desktop";
    "application/x-email" = "google-chrome.desktop";
    "x-scheme-handler/mailto" = "google-chrome.desktop";
    "inode/directory" = "thunar.desktop";
  };

  # Override which file manager is used by dbus.
  xdg.dataFile."dbus-1/services/org.freedesktop.FileManager1.service".text = ''
    [D-BUS Service]
    Name=org.freedesktop.FileManager1
    Exec=thunar
  '';
}
