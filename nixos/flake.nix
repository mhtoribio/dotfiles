{
  description = "nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-matlab = {
      # nix-matlab's Nixpkgs input follows Nixpkgs' nixos-unstable branch. However
      # your Nixpkgs revision might not follow the same branch. You'd want to
      # match your Nixpkgs and nix-matlab to ensure fontconfig related
      # compatibility.
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:doronbehar/nix-matlab";
    };

    nixpkgs-quartus.url = "github:nixos/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs, home-manager, nix-matlab, ... }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      flake-overlays = [ nix-matlab.overlay ];
      pkgs = import nixpkgs {
        inherit system;
        overlays = import ./overlays.nix { inherit inputs; };
      };
    in {
      nixosConfigurations = {
        mltop = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/mltop/configuration.nix ./nixosModules ];
        };
      };
      homeConfigurations = {
        markus = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs outputs; };
          modules =
            [ ./hosts/mltop/home.nix self.outputs.homeManagerModules.default ];
        };
      };
      homeManagerModules.default = ./homemanagerModules;
    };
}
