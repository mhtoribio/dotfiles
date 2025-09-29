{ config, lib, pkgs, ... }: {
  options = { hyprland.enable = lib.mkEnableOption "enable hyprland"; };
  config = lib.mkIf config.hyprland.enable {

    home.pointerCursor = {
      package = pkgs.adwaita-icon-theme; # provides the Adwaita cursors
      name = "Adwaita";
      size = 18; # pick any size you like
      gtk.enable = true; # GTK apps follow it
      x11.enable = true; # Xwayland too
    };

    wayland.windowManager.hyprland.settings.env = [
      "XCURSOR_THEME,Adwaita"
      "XCURSOR_SIZE,18"
      "HYPRCURSOR_THEME,Adwaita"
      "HYPRCURSOR_SIZE,18"
    ];

    wayland.windowManager.hyprland.settings.input = {
      kb_layout = "us,dk"; # order matters: 0=us, 1=dk
    };

    # --- Hyprland compositor (HM) ---
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true; # manage Hyprland via systemd user service

      settings = {
        # ---- look & feel ~ i3 gaps/borders ----
        general = {
          gaps_in = 5; # i3: inner gaps
          gaps_out = 3; # i3: outer gaps
          border_size = 1; # i3: thin borders
          layout = "master"; # "dwindle" or "master"
        };

        decoration = {
          rounding = 0;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
        };

        animations = { enabled = false; };

        "$mod" = "SUPER";
        bind = [
          # Keymap
          "$mod, Backspace, exec, ${pkgs.hyprland}/bin/hyprctl switchxkblayout all next"

          # # Cursed monitor hack - fix this with kanshi or shikane when they solve the issues https://github.com/hyprwm/Hyprland/issues/1274
          # ''
          #   $mod CTRL, F10, exec, ${pkgs.hyprland}/bin/hyprctl keyword monitor "HDMI-A-1,preferred,0x0,1"; ${pkgs.hyprland}/bin/hyprctl dispatch dpms off eDP-1''
          # ''
          #   $mod CTRL, F11, exec, ${pkgs.hyprland}/bin/hyprctl dispatch dpms on eDP-1; ${pkgs.hyprland}/bin/hyprctl keyword monitor "eDP-1,preferred,0x0,1"''
          # Dock: make HDMI primary, disable laptop panel
          "$mod CTRL, F10, exec, ${pkgs.hyprland}/bin/hyprctl keyword monitor 'HDMI-A-1,preferred,0x0,1'; ${pkgs.hyprland}/bin/hyprctl keyword monitor 'eDP-1,disable'; for i in $(seq 1 9); do ${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor $i HDMI-A-1; done"
          # Mobile: re-enable laptop panel, (optionally) kill HDMI
          "$mod CTRL, F11, exec, ${pkgs.hyprland}/bin/hyprctl keyword monitor 'eDP-1,preferred,0x0,1'; ${pkgs.hyprland}/bin/hyprctl dispatch dpms on eDP-1; ${pkgs.hyprland}/bin/hyprctl keyword monitor 'HDMI-A-1,disable'; for i in $(seq 1 9); do ${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor $i eDP-1; done"

          # apps
          "$mod, Return, exec, ${pkgs.alacritty}/bin/alacritty"
          "$mod, D,      exec, ${pkgs.rofi-wayland}/bin/rofi -show drun"
          "$mod SHIFT, D, exec, ${pkgs.rofi-wayland}/bin/rofi -show run"
          ''
            $mod SHIFT, S, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" ~/Pictures/Shot-$(date +%F_%T).png''
          "$mod ALT, L, exec, ${pkgs.hyprlock}/bin/hyprlock"
          "$mod SHIFT, Q, killactive"
          "$mod, F,      fullscreen"
          "$mod SHIFT, space, togglefloating"
          "$mod, Space,  togglesplit"

          # focus (i3: $mod+h/j/k/l)
          "$mod, H, movefocus, l"
          "$mod, J, movefocus, d"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, r"

          # move window (i3: $mod+Shift+h/j/k/l)
          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, J, movewindow, d"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, L, movewindow, r"

          # Workspaces
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"

          # Move to workspace
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
        ];

        # mouse like i3 (Mod+Left drag = move, Mod+Right drag = resize)
        bindm = [
          "$mod, mouse:272, movewindow" # left button
          "$mod, mouse:273, resizewindow" # right button
        ];

        # smooth resize (hold to repeat)
        binde = [
          "$mod CTRL, H, resizeactive, -20 0"
          "$mod CTRL, L, resizeactive,  20 0"
          "$mod CTRL, J, resizeactive,   0 20"
          "$mod CTRL, K, resizeactive,   0 -20"
        ];
      };
    };

    # --- Wayland userland that replaces X11 bits from i3 setup ---
    programs.waybar = {
      enable = true;
      systemd.enable = true; # autostart
      systemd.target = "hyprland-session.target";
    };
    services.mako.enable = true; # notifications

    # Automatic monitor switching
    # services.shikane = {
    #   enable = true;
    #   settings = {
    #     profile = [
    #       {
    #         name = "mobile";
    #         output = [{
    #           match = "eDP-1";
    #           enable = true;
    #         }];
    #       }
    #       {
    #         name = "docked";
    #         output = [
    #           {
    #             match = "eDP-1";
    #             enable = false;
    #           }
    #           {
    #             match = "HDMI-A-1";
    #             enable = true;
    #           }
    #         ];
    #       }
    #     ];
    #   };
    # };

    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;
        preload = [ "~/.wallpaper.jpg" ];
        wallpaper = [ "HDMI-A-1,~/.wallpaper.jpg" "eDP-1,~/.wallpaper.jpg" ];
      };
    };

    # Tools referenced in binds/startup (add/remove to taste)
    home.packages = with pkgs; [
      alacritty
      rofi-wayland
      wl-clipboard
      hyprlock
      grim
      slurp # screenshots if you bind Print, e.g.:
      # , Print, exec, ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" ~/Pictures/Shot-$(date +%F_%T).png
      intel-gpu-tools # for Intel iGPU fallback (intel_gpu_top)
      lm_sensors # temperature backing, nice to have
      pavucontrol # clicked by pulseaudio module
    ];

    # Nice-to-have env for native Wayland apps
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Electron/Chromium/VSCode Wayland
      MOZ_ENABLE_WAYLAND = "1"; # Firefox Wayland
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      GTK_USE_PORTAL = "1";
    };
  };
}
