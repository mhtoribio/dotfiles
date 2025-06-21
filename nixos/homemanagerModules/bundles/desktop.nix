{ pkgs, lib, config, inputs, ... }: {
  options = {
    bundles.desktop.enable = lib.mkEnableOption "enable desktop bundle";
  };
  config = lib.mkIf config.bundles.desktop.enable {

    rofi.enable = lib.mkDefault true;
    i3.enable = lib.mkDefault true;
    polybar.enable = lib.mkDefault true;
    discord.enable = lib.mkDefault true;
    brave.enable = lib.mkDefault true;
    firefox.enable = lib.mkDefault true;
    obsidian.enable = lib.mkDefault true;

    home.packages = with pkgs; [
      alacritty
      xclip
      xsel
      feh
      pavucontrol
      wine
      zathura
    ];
  };
}
