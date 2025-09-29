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
      systemd.enable = true;
      systemd.target = "hyprland-session.target";

      settings = {
        mainBar = {
          height = 30;
          spacing = 4;

          # LEFT / CENTER / RIGHT
          modules-left = [ "hyprland/workspaces" "hyprland/window" ];
          modules-center = [ ];
          modules-right = [
            "idle_inhibitor"
            "pulseaudio"
            "network"
            "power-profiles-daemon"
            "cpu"
            "memory"
            "temperature"
            "backlight"
            "hyprland/language" # shows us/dk
            "battery"
            "clock"
            "tray"
          ];

          # --- Modules ---
          "hyprland/workspaces" = {
            format = "{name}";
            all-outputs = true;
            on-click = "activate";
            # Uncomment to always show 1..9:
            # persistent-workspaces = { "*" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ]; };
          };

          "hyprland/window" = { max-length = 80; };

          "hyprland/language" = {
            format = "{short}"; # "us"/"dk"
            tooltip = false;
          };

          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };

          "pulseaudio" = {
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = { default = [ "" "" "" ]; };
            on-click = "pavucontrol";
          };

          "network" = {
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "{ipaddr}/{cidr} ";
            format-linked = "{ifname} (No IP) ";
            format-disconnected = "Disconnected ⚠";
            tooltip-format = "{ifname} via {gwaddr} ";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };

          "power-profiles-daemon" = {
            format = "{icon}";
            tooltip = true;
            tooltip-format = ''
              Power profile: {profile}
              Driver: {driver}'';
            format-icons = {
              default = "";
              performance = "";
              balanced = "";
              "power-saver" = "";
            };
          };

          "cpu" = {
            format = "{usage}% ";
            tooltip = true;
          };
          "memory" = { format = "{}% "; };

          "temperature" = {
            critical-threshold = 80;
            format = "{temperatureC}°C {icon}";
            format-icons = [ "" "" "" ];
          };

          "backlight" = {
            # auto-detects device; set "device" if needed
            format = "{percent}% {icon}";
            format-icons = [ "" "" "" "" "" "" "" "" "" ];
          };

          "battery" = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-full = "{capacity}% {icon}";
            format-charging = "{capacity}% ";
            format-plugged = "{capacity}% ";
            format-alt = "{time} {icon}";
            format-icons = [ "" "" "" "" "" ];
          };

          "clock" = {
            tooltip-format =
              "<big>{:%Y %B}</big><tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d}";

          };

          "tray" = { spacing = 10; };
        };
      };

      # Minimal style + icon fonts (uses Nerd Font so icons render)
      style = ''
        /* ---------- base ---------- */
        * {
          font-family: "JetBrainsMono Nerd Font", "JetBrainsMono Nerd Font Mono", monospace;
          font-size: 13px;
        }
        		
        window#waybar {
        	background-color: rgba(43, 48, 59, 0.5);
        	border-bottom: 3px solid rgba(100, 114, 125, 0.5);
        	color: #ffffff;
        	transition-property: background-color;
        	transition-duration: .5s;
        }

        window#waybar.hidden {
        	opacity: 0.2;
        }

        /*
        window#waybar.empty {
        	background-color: transparent;
        }
        window#waybar.solo {
        	background-color: #FFFFFF;
        }
        */

        window#waybar.termite {
        	background-color: #3F3F3F;
        }

        window#waybar.chromium {
        	border: none;
        }

        button {
        	/* Use box-shadow instead of border so the text isn't offset */
        	box-shadow: inset 0 -3px transparent;
        	/* Avoid rounded borders under each button name */
        	border: none;
        	border-radius: 0;
        }

        /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
        button:hover {
        	background: inherit;
        	box-shadow: inset 0 -3px #ffffff;
        }

        /* you can set a style on hover for any module like this */
        #pulseaudio:hover {
        	background-color: #a37800;
        }

        #workspaces button {
        	padding: 0 5px;
        	background-color: transparent;
        	color: #ffffff;
        }

        #workspaces button:hover {
        	background: rgba(0, 0, 0, 0.2);
        }

        #workspaces button.focused {
        	background-color: #64727D;
        	box-shadow: inset 0 -3px #ffffff;
        }

        #workspaces button.urgent {
        	background-color: #eb4d4b;
        }

        #mode {
        	background-color: #64727D;
        	box-shadow: inset 0 -3px #ffffff;
        }

        #clock,
        #battery,
        #cpu,
        #memory,
        #disk,
        #temperature,
        #backlight,
        #network,
        #pulseaudio,
        #wireplumber,
        #custom-media,
        #tray,
        #mode,
        #idle_inhibitor,
        #scratchpad,
        #power-profiles-daemon,
        #mpd {
        	padding: 0 10px;
        	color: #ffffff;
        }

        #window,
        #workspaces {
        	margin: 0 4px;
        }

        /* If workspaces is the leftmost module, omit left margin */
        .modules-left > widget:first-child > #workspaces {
        	margin-left: 0;
        }

        /* If workspaces is the rightmost module, omit right margin */
        .modules-right > widget:last-child > #workspaces {
        	margin-right: 0;
        }

        #clock {
        	background-color: #64727D;
        }

        #battery {
        	background-color: #ffffff;
        	color: #000000;
        }

        #battery.charging, #battery.plugged {
        	color: #ffffff;
        	background-color: #26A65B;
        }

        @keyframes blink {
        	to {
        		background-color: #ffffff;
        		color: #000000;
        	}
        }

        /* Using steps() instead of linear as a timing function to limit cpu usage */
        #battery.critical:not(.charging) {
        	background-color: #f53c3c;
        	color: #ffffff;
        	animation-name: blink;
        	animation-duration: 0.5s;
        	animation-timing-function: steps(12);
        	animation-iteration-count: infinite;
        	animation-direction: alternate;
        }

        #power-profiles-daemon {
        	padding-right: 15px;
        }

        #power-profiles-daemon.performance {
        	background-color: #f53c3c;
        	color: #ffffff;
        }

        #power-profiles-daemon.balanced {
        	background-color: #2980b9;
        	color: #ffffff;
        }

        #power-profiles-daemon.power-saver {
        	background-color: #2ecc71;
        	color: #000000;
        }

        label:focus {
        	background-color: #000000;
        }

        #cpu {
        	background-color: #2ecc71;
        }

        #memory {
        	background-color: #9b59b6;
        }

        #disk {
        	background-color: #964B00;
        }

        #backlight {
        	background-color: #90b1b1;
        }

        #network {
        	background-color: #2980b9;
        }

        #network.disconnected {
        	background-color: #f53c3c;
        }

        #pulseaudio {
        	background-color: #f1c40f;
        }

        #pulseaudio.muted {
        	background-color: #90b1b1;
        	color: #2a5c45;
        }

        #wireplumber {
        	background-color: #fff0f5;
        	color: #000000;
        }

        #wireplumber.muted {
        	background-color: #f53c3c;
        }

        #custom-media {
        	background-color: #66cc99;
        	color: #2a5c45;
        	min-width: 100px;
        }

        #custom-media.custom-spotify {
        	background-color: #66cc99;
        }

        #custom-media.custom-vlc {
        	background-color: #ffa000;
        }

        #temperature {
        	background-color: #f0932b;
        }

        #temperature.critical {
        	background-color: #eb4d4b;
        }

        #tray {
        	background-color: #2980b9;
        }

        #tray > .passive {
        	-gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
        	-gtk-icon-effect: highlight;
        	background-color: #eb4d4b;
        }

        #idle_inhibitor {
        	background-color: #2d3436;
        }

        #idle_inhibitor.activated {
        	background-color: #ecf0f1;
        	color: #2d3436;
        }

        #mpd {
        	background-color: #66cc99;
        	color: #2a5c45;
        }

        #mpd.disconnected {
        	background-color: #f53c3c;
        }

        #mpd.stopped {
        	background-color: #90b1b1;
        }

        #mpd.paused {
        	background-color: #51a37a;
        }

        #language {
        	background: #00b093;
        	color: #740864;
        	padding: 0 5px;
        	margin: 0 5px;
        	min-width: 16px;
        }

        #keyboard-state {
        	background: #97e1ad;
        	padding: 0 0px;
        	margin: 0 5px;
        	min-width: 16px;
        }

        #keyboard-state > label {
        	padding: 0 5px;
        }

        #keyboard-state > label.locked {
        	background: rgba(0, 0, 0, 0.2);
        }

        #scratchpad {
        	background: rgba(0, 0, 0, 0.2);
        }

        #scratchpad.empty {
        	background-color: transparent;
        }

        #privacy {
        	padding: 0;
        }

        #privacy-item {
        	padding: 0 5px;
        	color: white;
        }

        #privacy-item.screenshare {
        	background-color: #cf5700;
        }

        #privacy-item.audio-in {
        	background-color: #1ca000;
        }

        #privacy-item.audio-out {
        	background-color: #0069d4;
        }
      '';
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
    fonts.fontconfig.enable = true;
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

      pkgs.nerd-fonts.jetbrains-mono # was (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      pkgs.nerd-fonts.symbols-only # replaces "NerdFontsSymbolsOnly"
      font-awesome
      noto-fonts-emoji # (optional) nicer emoji coverage
      # noto-fonts                       # (optional) general text fallback
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
