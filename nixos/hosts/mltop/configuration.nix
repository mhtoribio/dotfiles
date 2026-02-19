{ config, pkgs, inputs, outputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # inputs.home-manager.nixosModules.home-manager
    # inputs.self.outputs.homeModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mltop"; # Define your hostname.
  environment.etc.hosts.mode = "0644"; # allow editing /etc/hosts as root
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;

  networking.nameservers = [ "8.8.8.8" ];

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

  # Display manager
  services.xserver.enable = false;
  services.xserver.displayManager.gdm.enable = false;

  # Hyprland system module provides the session entry for GDM
  programs.hyprland = {
    enable = true;
    withUWSM = true; # optional but nice; safe to keep on
    xwayland.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Text greeter; launches Hyprland after login
        command =
          "${pkgs.tuigreet}/bin/tuigreet --cmd 'uwsm start hyprland'";
        user = "greeter";
      };
    };
  };

  # Portals (screenshare, file dialogs)
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  xdg.portal.config = { common = { default = [ "hyprland" ]; }; };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxusers" "dialout" ];
    shell = pkgs.bash;
    # packages = with pkgs; [
    # ];
  };

  boot.supportedFilesystems = [ "ntfs" ];

  boot.kernelModules = [ "kvm-intel" ];
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.virtualbox.host.enable = true;

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
    usbutils
    pciutils
    quartus-prime-old.quartus-prime-lite
    gnome-network-displays
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
  ];

  documentation.enable = true;
  documentation.man.enable = true;
  documentation.dev.enable = true;
  documentation.info.enable = true;
  documentation.doc.enable = true;

  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  #     # Add any missing dynamic libraries for unpackaged programs
  #     # here, NOT in environment.systemPackages
  # ];

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = { main = { capslock = "overload(meta, esc)"; }; };
      };
    };
  };

  system.stateVersion = "23.11"; # Don't change

}
