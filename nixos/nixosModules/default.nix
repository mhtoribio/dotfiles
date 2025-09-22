{ pkgs, inputs, ... }: {
  imports = [
    # ./bundles/general-desktop.nix { inherit inputs; }
    ./programs/matlab.nix
  ];
}
