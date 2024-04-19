{ config, pkgs, inputs, outputs, ... }:

{
    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        # inputs.home-manager.nixosModules.home-manager
        # inputs.self.outputs.homeManagerModules.default
        ];

# Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "mltop"; # Define your hostname.
#networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

        nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Enable networking
    networking.networkmanager.enable = true;

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

    services.xserver = {
        enable = true;
        windowManager.i3.enable = true;
        displayManager.lightdm.enable = true;
        xkb.layout = "us";
    };

# Enable CUPS to print documents.
#services.printing.enable = true;

# Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
# If you want to use JACK applications, uncomment this
#jack.enable = true;

# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;
    };

# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.markus = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" ];
        # packages = with pkgs; [
        # ];
    };

# Allow unfree packages
    nixpkgs.config.allowUnfree = true;

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [ 9000 8000 ];

# Home Manager
#     home-manager = {
#         extraSpecialArgs = { inherit inputs outputs; };
#         users = {
# # Import your home-manager configuration
#             "markus" = import ./home.nix;
#         };
#     };

    environment.systemPackages = with pkgs; [
        home-manager
        vim
        firefox
        git
        gcc
    ];

    services.keyd = {
        enable = true;
        keyboards = {
            default = {
                ids = [ "*" ];
                settings = {
                    main = {
                        capslock = "overload(meta, esc)";
                    };
                };
            };
        };
    };

    system.stateVersion = "23.11"; # Don't change

}
