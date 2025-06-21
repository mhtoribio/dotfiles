{ pkgs, lib, config, outputs, ... }: {
  imports = [
    ./features/nvim.nix
    ./features/nixvim.nix
    ./features/tmux.nix
    ./features/zsh.nix
    ./features/bash.nix
    ./features/rofi.nix
    ./features/polybar.nix
    ./features/i3.nix
    ./features/discord.nix
    ./features/brave.nix
    ./features/firefox.nix
    ./features/obsidian.nix
    #./features/zathura.nix
    ./bundles/general.nix
    ./bundles/desktop.nix
  ];

  options = {
    stow-base-folder = lib.mkOption { default = ../../stow-configs; };
  };

  config = {
    #zathura.enable = lib.mkDefault true;
    bundles.general.enable = lib.mkDefault true;
    bundles.desktop.enable = lib.mkDefault false;

    nixpkgs = { config = { allowUnfree = true; }; };
  };

}
