{
  config,
  pkgs,
  inputs,
  ...
}:
let
  pyCommon = "${config.home.homeDirectory}/py_common/src/py_common";
in
{
  config = {
    home.username = "mato";
    home.homeDirectory = "/home/mato";
    home.stateVersion = "23.11";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Since this is not NixOS
    targets.genericLinux.enable = true;

    bundles.general.enable = false;
    bundles.xdesktop.enable = false;
    bundles.wayland_desktop.enable = false;

    nixvim.enable = true;
    tmux.enable = true;

    # Python tooling
    programs.nixvim = {
      extraPackages = with pkgs; [
        ruff
        mypy
      ];

      plugins = {
        lsp.servers = {
          ruff = {
            enable = true;
            extraOptions.init_options.settings.configuration = "${pyCommon}/ruff.toml";
          };
          pyright = {
            settings = {
              pyright.disableOrganizeImports = true;
              python.analysis.typeCheckingMode = "off";
            };
          };
        };

        conform-nvim.settings = {
          formatters_by_ft.python = [
            "ruff_organize_imports"
            "ruff_format"
          ];

          formatters.ruff_organize_imports.prepend_args = [
            "--config"
            "${pyCommon}/ruff.toml"
          ];
          formatters.ruff_format.prepend_args = [
            "--config"
            "${pyCommon}/ruff.toml"
          ];

          # Format Python only, on the work host
          format_on_save.__raw = ''
            function(bufnr)
              if vim.bo[bufnr].filetype ~= "python" then
                return nil
              end
              return { timeout_ms = 1000, lsp_format = "never" }
            end
          '';
        };

        lint = {
          enable = true;
          lintersByFt.python = [ "mypy" ];
        };

        cmp.settings.experimental.ghost_text = true;
      };

      extraConfigLuaPost = ''
        local lint = require("lint")
        vim.list_extend(lint.linters.mypy.args, {
          "--config-file",
          "${pyCommon}/mypy.toml",
        })

        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = "*.py",
          callback = function()
            lint.try_lint("mypy")
          end,
        })
      '';
    };

    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      font-awesome
      noto-fonts-color-emoji
    ];
  };
}
