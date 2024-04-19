{ lib, config, pkgs, ... }: {
    options = {
        zsh.enable = lib.mkEnableOption "enable zsh";
    };
    config = lib.mkIf config.zsh.enable {
        home.file.".config/zsh/".source = "${config.stow-base-folder}/zsh/.config/zsh/";

        programs.zsh = {
            enable = true;
            # dotDir = ".config/zsh";
            envExtra = ''
            export ZDOTDIR=~/.config/zsh
            export XDG_PROFILE_HOME=~/.config
            export XDG_CONFIG_HOME=~/.config
            export XDG_CACHE_HOME=~/.cache
            '';
        };
    };
}
