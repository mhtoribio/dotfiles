{ inputs, lib, config, pkgs, ... }: {
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];
  options = { nixvim.enable = lib.mkEnableOption "enable nixvim"; };
  config = lib.mkIf config.nixvim.enable {
    programs.nixvim = {
      enable = true;
      vimAlias = true;
      globals = { mapleader = " "; };
      opts = {
        relativenumber = true;
        number = true;
        incsearch = true;
        hlsearch = false;
        shiftwidth = 4;
        tabstop = 4;
        wrap = false;
        swapfile = false;
        termguicolors = true;
        scrolloff = 2;
      };
      plugins = {
        telescope = {
          enable = true;
          keymaps = {
            "<leader>pf" = { action = "find_files"; };
            "<leader>ps" = { action = "grep_string"; };
            "<leader>pl" = { action = "live_grep"; };
            "<leader>pk" = { action = "keymaps"; };
            "<C-p>" = { action = "git_files"; };
          };
        };
        harpoon = {
          enable = true;
          saveOnToggle = true;
          keymaps = {
            addFile = "<leader>a";
            toggleQuickMenu = "<C-e>";
            navFile = {
              "1" = "<C-h>";
              "2" = "<C-j>";
              "3" = "<C-k>";
              "4" = "<C-l>";
            };
          };
        };
        conform-nvim = {
          enable = true;
          formattersByFt = {
            c = [ "astyle" ];
            cpp = [ "astyle" ];
            lua = [ "stylua" ];
            nix = [ "nixfmt" ];
            go = [ "gofmt" ];
            rust = [ "rustfmt" ];
            sh = [ "shfmt" ];
          };
          formatOnSave = {
            lspFallback = true;
            timeoutMs = 2000;
          };
        };
        oil.enable = true;
        lsp = {
          enable = true;
          keymaps = {
            lspBuf = {
              "<leader>vgd" = "definition";
              "<leader>vgD" = "declaration";
              "<leader>vgi" = "implementation";
              "<leader>vgt" = "type_definition";
              "<leader>vgs" = "signature_help";
              "K" = "hover";
              "<leader>vws" = "workspace_symbol";
              "<leader>vca" = "code_action";
              "<leader>vrr" = "references";
              "<leader>vrn" = "rename";
            };
            diagnostic = {
              "<leader>vd" = "open_float";
              "]d" = "goto_next";
              "[d" = "goto_prev";
            };
          };
          servers = {
            nil_ls.enable = true;
            clangd.enable = true;
            bashls.enable = true;
            pyright.enable = true;
            rust-analyzer = {
              enable = true;
              installCargo = true;
              installRustc = true;
            };
            gopls.enable = true;
          };
        };
      };
    };
    home.packages = with pkgs; [
      ripgrep
      astyle
      astyle
      stylua
      nixfmt-classic
      rustfmt
      shfmt
      go
    ];
  };
}
