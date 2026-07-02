#
# Fork of Searx, a privacy-respecting, hackable metasearch engine.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.eclipse.searxng.enable = mkEnableOption "Enables Searxng";

  config = mkIf config.eclipse.searxng.enable {
    sops.secrets."searx.env" = {
      sopsFile = ./../../secrets/searx.env;
      format = "binary";
      owner = "searx";
    };

    services.searx = {
      enable = true;
      package = pkgs.unstable.searxng;
      environmentFile = config.sops.secrets."searx.env".path;

      settings = {
        server = {
          base_url = "http://localhost:42424";
          secret_key = "@SEARXNG_SECRET_KEY@"; # Use env var
          port = 42424;
          bind_address = "0.0.0.0";
          image_proxy = true;
          default_http_headers = {
            X-Content-Type-Options = "nosniff";
            X-XSS-Protection = "1; mode=block";
            X-Download-Options = "noopen";
            X-Robots-Tag = "noindex, nofollow";
            Referrer-Policy = "no-referrer";
          };
        };

        search = {
          formats = [
            "html"
            "json" # Open WebUI needs JSON API access
          ];
        };

        engines = [
          {
            name = "google";
            engine = "google";
            shortcut = "go";
          }
          {
            name = "duckduckgo";
            engine = "duckduckgo";
            shortcut = "ddg";
          }
          {
            name = "wikipedia";
            engine = "wikipedia";
            shortcut = "w";
          }
          {
            name = "github";
            engine = "github";
            shortcut = "gh";
          }
        ];
      };
    };
  };
}
