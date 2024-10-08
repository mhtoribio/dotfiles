{ inputs, ... }: {
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  modifications = final: _prev: {
    quartus = import inputs.nixpkgs-quartus {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
