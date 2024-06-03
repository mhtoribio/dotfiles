{ pkgs, lib, config, inputs, ... }: {
  options = {
    bundles.general.enable = lib.mkEnableOption "enable general bundle";

    gitName = lib.mkOption { default = "mhtoribio"; };
    gitEmail =
      lib.mkOption { default = "23717111+mhtoribio@users.noreply.github.com"; };
  };
  config = lib.mkIf config.bundles.general.enable {

    nixvim.enable = lib.mkDefault true;
    tmux.enable = lib.mkDefault true;
    bash.enable = lib.mkDefault true;

    nixpkgs = {
      config = {
        allowUnfree = true;
        experimental-features = "nix-command flakes";
      };
    };

    home.packages = with pkgs; [
      xclip
      xsel
      file
      fzf
      htop
      killall
      lf
      neofetch
      nh
      nil
      ripgrep
      tmux
      tree-sitter
      unzip
      wget
      zip
      python3
      bat
    ];

    programs.git = {
      enable = true;
      #config.init.defaultbranch = "master"; does not exist for some reason
      userName = config.gitName;
      userEmail = config.gitEmail;
    };
  };
}
