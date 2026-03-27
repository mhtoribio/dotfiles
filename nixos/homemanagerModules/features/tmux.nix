{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    tmux.enable = lib.mkEnableOption "enable tmux";
  };
  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;

      prefix = "M-e";
      keyMode = "vi";
      baseIndex = 1;
      terminal = "tmux-256color";
      escapeTime = 0;
      mouse = true;
      historyLimit = 50000;
      extraConfig = ''
        set -g status-left "[#S] | "
        set -g status-left-length 30
        bind c new-window -c "#{pane_current_path}"
        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
      '';
    };
  };
}
