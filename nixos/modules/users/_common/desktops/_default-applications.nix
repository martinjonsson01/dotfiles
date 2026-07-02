{
  xdg = {
    enable = true;
    mime.enable = true;

    configFile."mimeapps.list".force = true;

    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/*" = "nvim.desktop";
        "image/*" = "org.gnome.Loupe.desktop";
        "video/*" = "mpv.desktop";
        "audio/*" = "org.gnome.Decibels.desktop";
        "application/pdf" = "google-chrome.desktop";
        "x-scheme-handler/http" = "google-chrome.desktop";
        "x-scheme-handler/https" = "google-chrome.desktop";
        "application/x-email" = "google-chrome.desktop";
        "x-scheme-handler/mailto" = "google-chrome.desktop";
        "inode/directory" = "thunar.desktop";
        "asinode/directory" = "thunar.desktop";
        # Neovim files
        "application/csv" = "nvim.desktop";
        "application/vnd.ms-excel" = "nvim.desktop";
      };
    };
  };
}
