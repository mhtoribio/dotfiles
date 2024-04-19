{ lib, config, pkgs, ... }: {
    options = {
        i3.enable = lib.mkEnableOption "enable i3";
    };
    config = lib.mkIf config.i3.enable {
        home.file.".config/i3/".source = "${config.stow-base-folder}/i3/.config/i3/";
    };
}
