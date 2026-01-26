{
  description = "FHSEnv-based dev shell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

  outputs = inputs: let
    supportedSystems = [
      "x86_64-linux" # 64-bit Intel/AMD Linux
      "aarch64-linux" # 64-bit ARM Linux
      "x86_64-darwin" # 64-bit Intel macOS
      "aarch64-darwin" # 64-bit ARM macOS
    ];

    # Helper to provide system-specific attributes
    forEachSupportedSystem = f:
      inputs.nixpkgs.lib.genAttrs supportedSystems (
        system:
          f {
            pkgs = import inputs.nixpkgs {inherit system;};
          }
      );
  in {
    devShells = forEachSupportedSystem (
      {pkgs}: {
        default =
          (pkgs.buildFHSEnv {
            name = "fhs";
            targetPkgs = pkgs:
              with pkgs; [
                curl
                zlib
                util-linux
                gcc
                glibc
                libsForQt5.full
              ];
            profile = ''
              # Fix QT lib path
              export QT_QPA_PLATFORM_PLUGIN_PATH="${pkgs.libsForQt5.qt5.qtbase.bin}/lib/qt-${pkgs.libsForQt5.qt5.qtbase.version}/plugins";
            '';
          }).env;
      }
    );
  };
}
