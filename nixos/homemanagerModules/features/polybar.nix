{ lib, config, pkgs, ... }: {
    options = {
        polybar.enable = lib.mkEnableOption "enable polybar";
    };
    config = lib.mkIf config.polybar.enable {
        home.packages = [pkgs.polybar];
        home.file.".config/polybar/".source = "${config.stow-base-folder}/polybar/.config/polybar/";
    };
}
