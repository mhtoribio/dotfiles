{
  lib,
  config,
  ...
}:
{
  options = {
    bash.enable = lib.mkEnableOption "enable bash";
  };
  config = lib.mkIf config.bash.enable {
    programs.bash = {
      enable = true;
      bashrcExtra = ''
        # Navigate with lf
        lfcd () {
            tmp="$(mktemp -uq)"
            trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
            lf -last-dir-path="$tmp" "$@"
            if [ -f "$tmp" ]; then
                dir="$(cat "$tmp")"
                [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
            fi
        }
        bind '"\C-o":"\C-e\C-u lfcd\n"'
        bind '"\C-f":"\C-e\C-u $HOME/.dotfiles/scripts/tmux-sessionizer\n"'
        bind '"\C-n":"\C-e\C-u cd \"$(dirname \"$(fzf)\")\"\n"'
      '';
      sessionVariables = {
        GIT_EDITOR = "nvim";
        EDITOR = "nvim";
      };
      shellAliases = {
        # Confirm before overwriting something
        cp = "cp -i";
        mv = "mv -i";
        # ls
        ls = "ls --color=tty";
        lsa = "ls -la";
        ll = "ls -l";
        # use these all the time
        t = "tmux";
        v = "vim";
      };

    };
  };
}
