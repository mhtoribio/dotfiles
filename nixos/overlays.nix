{ inputs, ... }: [
  (self: super: {
    unstable = import inputs.nixpkgs {
      system = self.system;
      config.allowUnfree = true;
    };
  })
  (self: super: {
    quartus-prime-old = import inputs.nixpkgs-quartus {
      system = self.system;
      config.allowUnfree = true;
    };
  })
  inputs.nix-matlab.overlay
]
