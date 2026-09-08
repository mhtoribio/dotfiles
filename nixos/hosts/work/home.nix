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

    # Disable everything
    bundles.general.enable = false;
    bundles.xdesktop.enable = false;
    bundles.wayland_desktop.enable = false;

    # Only want nixvim
    nixvim.enable = true;
  };
}
