{ config, pkgs, inputs, outputs, ... }:

{
	wsl.enable = true;
	wsl.defaultUser = "markus";

  networking.hostName = "mws-nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # Enable sound with pipewire.
  # Don't require password for sudo
  # I'm already logged in and its a personal machine, why would i need to enter password?
  security.sudo.extraRules = [{
    users = [ "markus" ];
    commands = [{
      command = "ALL";
      options =
        [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
    }];
  }];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.markus = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.bash;
    # packages = with pkgs; [
    # ];
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 9000 8000 ];
  networking.firewall.enable = false;

  environment.systemPackages = with pkgs; [
    home-manager
    vim
    firefox
    git
    gcc
    linux-manual
    man-pages
    man-pages-posix
    wireguard-tools
  ];

  documentation.enable = true;
  documentation.man.enable = true;
  documentation.dev.enable = true;
  documentation.info.enable = true;
  documentation.doc.enable = true;

  system.stateVersion = "23.11"; # Don't change
}
