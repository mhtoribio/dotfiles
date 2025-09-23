{ pkgs, lib, config, inputs, ... }: {
  options = {
    bundles.wayland_desktop.enable =
      lib.mkEnableOption "enable wayland desktop bundle";
  };
  config = lib.mkIf config.bundles.wayland_desktop.enable {

    hyprland.enable = lib.mkDefault true;
    discord.enable = lib.mkDefault true;
    brave.enable = lib.mkDefault true;
    firefox.enable = lib.mkDefault true;
    obsidian.enable = lib.mkDefault true;

    home.packages = with pkgs; [
      alacritty
      feh
      pavucontrol
      wineWowPackages.stable
      zathura
    ];
  };
}
