#
# JetBrains IDEs.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  vmOptions = concatStringsSep "\n" [
    "-Dawt.toolkit.name=WLToolkit" # Use native Wayland support
    "-Xms16g" # Give more RAM
    "-Xmx16g"
  ];
in {
  options = {
    jetbrains.enable = mkEnableOption "Enables JetBrains";
  };

  config = mkIf config.jetbrains.enable {
    home.packages = with pkgs; [
      # Rust IDE
      ((jetbrains.rust-rover.overrideAttrs
        (oldAttrs: {
          version = "2025.1.3";
          src = pkgs.fetchurl {
            # https://www.jetbrains.com/rust/nextversion/
            url = "https://download-cdn.jetbrains.com/rustrover/RustRover-252.23892.231.tar.gz"; # 2025.2 EAP 8
            sha256 = "9757560842b3c5e56d784e457b16ee0cf2ef11f03340d3dcdf92e20d0b3b9ab8";
          };
          buildInputs = oldAttrs.buildInputs ++ [pkgs.libGL];
        })).override {
        vmopts = vmOptions;
      })
      # C# IDE
      (jetbrains.rider.override {
        vmopts = vmOptions;
      })
      dotnetCorePackages.sdk_9_0-bin # dotnet 9 SDK
    ];
  };
}
