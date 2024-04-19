{ lib, config, ... }: {
    options = {
        nvim.enable = lib.mkEnableOption "enable nvim";
    };
    config = lib.mkIf config.nvim.enable {
        programs.neovim = {
            enable = true;
            defaultEditor = true;
            vimAlias = true;
        };
        home.file.".config/nvim/".source = "${config.stow-base-folder}/nvim/.config/nvim/";
    };
}
