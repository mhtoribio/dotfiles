{ lib, config, pkgs, ... }: {
  options = { rofi.enable = lib.mkEnableOption "enable rofi"; };
  config = lib.mkIf config.rofi.enable { home.packages = [ pkgs.rofi ]; };
}
