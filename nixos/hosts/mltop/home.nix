{
  config,
  pkgs,
  inputs,
  ...
}:
{
  config = {
    # imports = [
    #     inputs.self.outputs.homeModules.default
    # ];
    home.username = "markus";
    home.homeDirectory = "/home/markus";
    home.stateVersion = "23.11";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    bundles.xdesktop.enable = false;
    bundles.general.enable = true;

    # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
  };
}
