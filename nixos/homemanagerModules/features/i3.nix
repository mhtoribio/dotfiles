{ lib, config, pkgs, ... }: {
  options = { i3.enable = lib.mkEnableOption "enable i3"; };
  config = lib.mkIf config.i3.enable {

    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        window.border = 1;
        window.titlebar = false;
        gaps = {
          smartBorders = "on";
          smartGaps = true;
          outer = 3;
          inner = 10;
        };
        defaultWorkspace = "workspace number 1";
        terminal = "${pkgs.alacritty}/bin/alacritty";

        # polybar instead of i3bar
        bars = [ ];
        startup = [{
          command = "systemctl --user restart polybar";
          always = true;
          notification = false;
        }];

        keybindings =
          let modifier = config.xsession.windowManager.i3.config.modifier;
          in lib.mkOptionDefault {
            "${modifier}+Mod1+l" = "exec --no-startup-id i3lock";
            "${modifier}+d" = ''
              exec "${pkgs.rofi}/bin/rofi -modi drun,run -show drun -theme Arc-Dark -font 'hack 20'"'';
            "${modifier}+Shift+d" = ''
              exec "${pkgs.rofi}/bin/rofi -modi run,run -show run -theme Arc-Dark -font 'hack 20'"'';
            "${modifier}+w" = "exec ${pkgs.firefox}/bin/firefox";
            "${modifier}+z" =
              "exec --no-startup-id ~/.dotfiles/scripts/toggle-keymap";
            "${modifier}+h" = "focus left";
            "${modifier}+j" = "focus down";
            "${modifier}+k" = "focus up";
            "${modifier}+l" = "focus right";
            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+j" = "move down";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+l" = "move right";
            "${modifier}+t" = "layout tabbed";
            "${modifier}+Shift+s" = "${pkgs.flameshot}/bin/flameshot gui";
          };

        modes = {
          resize = {
            "h" = "resize shrink width 10 px or 10 ppt";
            "j" = "resize grow height 10 px or 10 ppt";
            "k" = "resize shrink height 10 px or 10 ppt";
            "l" = "resize grow width 10 px or 10 ppt";
          };
        };
      };
    };
  };
}
