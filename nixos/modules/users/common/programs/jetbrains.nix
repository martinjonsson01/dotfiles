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
            url = "https://download.jetbrains.com/rustrover/RustRover-2025.2.1.tar.gz"; # 2025.2.1
            sha256 = "19fde47a5c3c8e1b21b402c3351018eed64e2cff575f32a86c884168b522074a";
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
