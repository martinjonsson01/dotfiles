#
# Default applications for opening files and links (MIME associations).
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.default-applications.enable = mkEnableOption "Enables default application associations";

  config = mkIf config.eclipse.default-applications.enable {
    eclipse.hm = {
      xdg = {
        enable = true;
        mime.enable = true;

        configFile."mimeapps.list".force = true;

        mimeApps = {
          enable = true;
          # mimeapps.list does not support glob patterns like image/*, so
          # each type is enumerated per handler.
          defaultApplications = let
            imageTypes = [
              "image/avif"
              "image/bmp"
              "image/gif"
              "image/heic"
              "image/heif"
              "image/jpeg"
              "image/jxl"
              "image/pjpeg"
              "image/png"
              "image/qoi"
              "image/svg+xml"
              "image/svg+xml-compressed"
              "image/tiff"
              "image/vnd.microsoft.icon"
              "image/webp"
              "image/x-bmp"
              "image/x-exr"
              "image/x-icon"
              "image/x-png"
              "image/x-portable-anymap"
              "image/x-portable-bitmap"
              "image/x-portable-graymap"
              "image/x-portable-pixmap"
              "image/x-targa"
              "image/x-tga"
            ];
            videoTypes = [
              "video/3gpp"
              "video/mp2t"
              "video/mp4"
              "video/mpeg"
              "video/ogg"
              "video/quicktime"
              "video/webm"
              "video/x-flv"
              "video/x-matroska"
              "video/x-ms-wmv"
              "video/x-msvideo"
            ];
            audioTypes = [
              "audio/aac"
              "audio/flac"
              "audio/mp4"
              "audio/mpeg"
              "audio/ogg"
              "audio/wav"
              "audio/webm"
              "audio/x-opus+ogg"
              "audio/x-vorbis+ogg"
              "audio/x-wav"
            ];
            textTypes = [
              "application/json"
              "application/xml"
              "text/csv"
              "text/markdown"
              "text/plain"
              "text/xml"
            ];
          in
            genAttrs imageTypes (_: "swayimg.desktop")
            // genAttrs videoTypes (_: "mpv.desktop")
            // genAttrs audioTypes (_: "org.gnome.Decibels.desktop")
            // genAttrs textTypes (_: "nvim.desktop")
            // {
              "application/pdf" = "google-chrome.desktop";
              "x-scheme-handler/http" = "google-chrome.desktop";
              "x-scheme-handler/https" = "google-chrome.desktop";
              "application/x-email" = "google-chrome.desktop";
              "x-scheme-handler/mailto" = "google-chrome.desktop";
              "inode/directory" = "thunar.desktop";
              "application/csv" = "nvim.desktop";
              "application/vnd.ms-excel" = "nvim.desktop";
            };
        };
      };
    };
  };
}
