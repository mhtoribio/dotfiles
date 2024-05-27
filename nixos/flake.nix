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
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs:
        let
            inherit (self) outputs;
            system = "x86_64-linux";
            pkgs = import nixpkgs { inherit system; };
        in
    {
        nixosConfigurations = {
            mltop = nixpkgs.lib.nixosSystem {
                specialArgs = {inherit inputs outputs;};
                modules = [
                    ./hosts/mltop/configuration.nix
                    ./nixosModules
                ];
            };
        };
        homeConfigurations = {
            markus = inputs.home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = {
                    inherit inputs outputs;
                };
                modules = [
                    ./hosts/mltop/home.nix
                    self.outputs.homeManagerModules.default
                ];
            };
        };
        homeManagerModules.default = ./homemanagerModules;
    };
}
