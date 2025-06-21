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

      colorschemes.catppuccin = {
        enable = true;
        settings.flavour = "mocha";
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

        harpoon = { enable = true; };

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
          settings.format_on_save = {
            lspFallback = true;
            timeoutMs = 2000;
          };
        };

        oil.enable = true;

        dressing.enable = true;

        markdown-preview.enable = true;

        fugitive.enable = true;

        clipboard-image = {
          enable = true;
          clipboardPackage = pkgs.xclip;
          default = { imgDir = "images"; };
        };

        comment = {
          enable = true;
          settings = {
            toggler = {
              line = "<leader>cc";
              block = "<leader>bc";
            };
            opleader = {
              line = "<leader>c";
              block = "<leader>b";
            };
          };
        };

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
            java-language-server.enable = true;
            tsserver.enable = true;
            ltex.enable = true;
            matlab_ls.enable = true;
            omnisharp.enable = true;
          };
        };

        cmp = {
          enable = true;
          settings = {
            sources = [
              { name = "nvim_lsp"; }
              { name = "luasnip"; }
              { name = "buffer"; }
              { name = "path"; }
            ];
            mapping = {
              "<C-p>" = "cmp.mapping.select_prev_item()";
              "<C-n>" = "cmp.mapping.select_next_item()";
              "<C-y>" = "cmp.mapping.confirm()";
              "<C-Space>" = "cmp.mapping.complete()";
            };
          };
        };

      }; # plugins

      # top-level keymaps
      keymaps = [
        {
          mode = "n";
          key = "-";
          action = "<cmd>Oil<CR>";
        }
        {
          mode = "n";
          key = "<leader>gs";
          action = "<cmd>Git<CR>";
        }
        {
          mode = "v";
          key = "K";
          action = ":m '<-2<CR>gv=gv";
        }
        {
          mode = "v";
          key = "J";
          action = ":m '>+1<CR>gv=gv";
        }
        {
          mode = "n";
          key = "J";
          action = "mzJ`z";
        }
        {
          mode = "n";
          key = "<C-d>";
          action = "<C-d>zz";
        }
        {
          mode = "n";
          key = "<C-u>";
          action = "<C-u>zz";
        }
        {
          mode = "n";
          key = "n";
          action = "nzzzv";
        }
        {
          mode = "n";
          key = "N";
          action = "Nzzzv";
        }
        {
          mode = "x";
          key = "<leader>p";
          action = ''"_dP'';
        }
        {
          key = "<leader>y";
          action = ''"+y'';
        }
        {
          mode = "n";
          key = "<leader>Y";
          action = ''"+Y'';
        }
        {
          mode = "n";
          key = "<C-f>";
          action = "<cmd>silent !tmux neww tmux-sessionizer<CR>";
        }
        {
          mode = "n";
          key = "<leader>s";
          action = ":%s/<<C-r><C-w>>/<C-r><C-w>/gI<Left><Left><Left>";
        }
        {
          mode = "n";
          key = "<leader>x";
          action = "<cmd>!chmod +x %<CR>";
          options.silent = true;
        }
        {
          mode = "n";
          key = "<leader><leader><CR>";
          action = "<cmd>.!sh<CR>";
        }
        {
          mode = "n";
          key = "]g";
          action = "<cmd>cnext<CR>";
        }
        {
          mode = "n";
          key = "[g";
          action = "<cmd>cprev<CR>";
        }
        {
          mode = "n";
          key = "<leader>md";
          action = "<cmd>set cole=0<CR>";
        }
        {
          mode = "n";
          key = "<leader>a";
          action.__raw = "function() require'harpoon':list():add() end";
        }
        {
          mode = "n";
          key = "<C-e>";
          action.__raw =
            "function() require'harpoon'.ui:toggle_quick_menu(require'harpoon':list()) end";
        }
        {
          mode = "n";
          key = "<C-h>";
          action.__raw = "function() require'harpoon':list():select(1) end";
        }
        {
          mode = "n";
          key = "<C-j>";
          action.__raw = "function() require'harpoon':list():select(2) end";
        }
        {
          mode = "n";
          key = "<C-k>";
          action.__raw = "function() require'harpoon':list():select(3) end";
        }
        {
          mode = "n";
          key = "<C-l>";
          action.__raw = "function() require'harpoon':list():select(4) end";
        }

      ];

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
