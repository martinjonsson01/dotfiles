#
# Firmware for Realtek RTL8761BU.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    rtl8761bu-firmware.enable = mkEnableOption "Enables RTL8761BU firmware";
  };

  config = mkIf config.rtl8761bu-firmware.enable {
    hardware.firmware = [
      (pkgs.rtl8761b-firmware.overrideAttrs (oldAttrs: {
        installPhase =
          (oldAttrs.installPhase or "")
          + ''
            mkdir -p $out/lib/firmware/rtl_bt

            install -m644 bt/rtkbt/Firmware/BT/rtl8761b_fw \
              $out/lib/firmware/rtl_bt/rtl8761bu_fw.bin

            install -m644 bt/rtkbt/Firmware/BT/rtl8761b_config \
              $out/lib/firmware/rtl_bt/rtl8761bu_config.bin
          '';
      }))
    ];
  };
}
