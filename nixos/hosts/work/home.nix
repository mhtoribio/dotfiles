{
  config,
  pkgs,
  inputs,
  ...
}:
{
  config = {
    home.username = "mato";
    home.homeDirectory = "/home/mato";
    home.stateVersion = "23.11";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Since this is not NixOS
    targets.genericLinux.enable = true;

    bundles.general.enable = false;
    bundles.xdesktop.enable = false;
    bundles.wayland_desktop.enable = false;

    nixvim.enable = true;
    tmux.enable = true;

    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      font-awesome
      noto-fonts-color-emoji
    ];
  };
}
