{ lib, config, pkgs, ... }: {
  options = { polybar.enable = lib.mkEnableOption "enable polybar"; };
  config = lib.mkIf config.polybar.enable {
    home.file.".config/polybar/".source =
      "${config.stow-base-folder}/polybar/.config/polybar/";
    services.polybar = {
      enable = true;
      script = ''
        polybar --reload top &
      '';
    };
  };
}
