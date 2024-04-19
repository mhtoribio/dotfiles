{ lib, config, pkgs, ... }: {
    options = {
        tmux.enable = lib.mkEnableOption "enable tmux";
    };
    config = lib.mkIf config.tmux.enable {
        programs.tmux = {
            enable = true;
            plugins = [
                pkgs.tmuxPlugins.tmux-fzf
                pkgs.tmuxPlugins.gruvbox
            ];
        };
        home.file.".config/tmux/".source = "${config.stow-base-folder}/tmux/.config/tmux/";
    };
}
