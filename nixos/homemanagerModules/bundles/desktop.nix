{ pkgs, lib, config, inputs, ... }: {
    options = {
        bundles.desktop.enable = lib.mkEnableOption "enable desktop bundle";
    };
    config = lib.mkIf config.bundles.desktop.enable {

        rofi.enable = lib.mkDefault true;
        i3.enable = lib.mkDefault true;
        polybar.enable = lib.mkDefault true;
        discord.enable = lib.mkDefault true;

        home.packages = with pkgs; [
            alacritty
            firefox
            xclip
            xsel
            feh
            pavucontrol
        ];
    };
}
