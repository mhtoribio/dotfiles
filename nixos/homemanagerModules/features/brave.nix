{ lib, config, pkgs, ... }: {
    options = {
        brave.enable = lib.mkEnableOption "enable brave";
    };
    config = lib.mkIf config.brave.enable {
        home.packages = [pkgs.brave];
    };
}
