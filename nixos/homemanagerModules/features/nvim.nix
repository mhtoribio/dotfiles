{ lib, config, pkgs, ... }: {
    options = {
        nvim.enable = lib.mkEnableOption "enable nvim";
    };
    config = lib.mkIf config.nvim.enable {
        programs.neovim = {
            enable = true;
            defaultEditor = true;
            vimAlias = true;
        };
        home.packages = with pkgs; [
            lua-language-server
            nil
            clang-tools
            rust-analyzer
            nodePackages.pyright
            nixpkgs-fmt
            gopls
        ];
        home.file.".config/nvim/".source = "${config.stow-base-folder}/nvim/.config/nvim/";
    };
}
