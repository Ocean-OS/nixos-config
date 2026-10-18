{
    config,
    pkgs,
    lib,
    inputs,
    nixpkgs,
    ...
}:
let
    home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
in
{
    imports = 
    if builtins.currentSystem == "x86_64-linux" then [
        (import "${home-manager}/nixos")
	./hosts/thinkpad/hardware-configuration.nix
	./hosts/thinkpad/bootloader.nix
    ] else [
	(import "${home-manager}/nixos")
	./hosts/raspberry-pi/hardware-configuration.nix
	./hosts/raspberry-pi/bootloader.nix
    ];

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    home-manager.users.me = {
    	home.stateVersion = "26.05";
    };

    # Define a user account. Don't forget to set a password with `passwd`. 
    users.users."me" = {
        isNormalUser = true;
        description = " ";
        extraGroups = [
            "networkmanager"
            "wheel"
        ];
        packages = with pkgs; [
        ];
    };

    # Enable networking
    networking.networkmanager.enable = true;

    # Define your hostname.
    networking.hostName = "nixos";
    # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Set your time zone.
    time.timeZone = "America/Los_Angeles";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };

    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    # rtkit (optional but recommended) enables realtime scheduling for pipewire
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

    hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
        settings = {
            General = {
                Enable = "Source,Sink,Media,Socket";
                Experimental = true;
            };
        };
    };

    # Desktop environment setup
    systemd.services.display-manager.enable = false;
    services.xserver.enable = true;
    programs.hyprland.enable = true;
    xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
        ];
    };
    programs.hyprlock.enable = true;
    security.pam.services.hyprlock = { };
    security.polkit.enable = true;
    fonts.fontconfig.enable = true;
    
    # Libraries
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
        glib
        dbus
        cups
        gtk3
        libGL
        libx11
        libxcursor
        libxrender
        atk
        libglvnd
        nspr
        nss_latest
        cairo
        pango
        libgbm
        expat
        libxkbcommon
        alsa-lib
        libxrandr
        libxcomposite
        libxdamage
        libxext
        libxfixes
        libxcb
        libxtst
        libxi
        libelf
        pkgs.fontconfig
        libusb1
        libinput
        libudev-zero
        avahi
        icu
        libice
        libsm
        wayland
        gtk4
        gtk2
        harfbuzz
        freetype
        flac
        ffmpeg
        xz
        util-linux
        libxml2
        libssh
        stdenv.cc.cc
        zlib
        zstd
        curl
        openssl
        attr
        bzip2
        acl
        libsodium
    ];
    programs.direnv.enable = true;
    programs.neovim.enable = true;
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = 
        let
            zen-browser = 
# the flake is currently broken on main
# https://github.com/youwen5/zen-browser-flake/issues/22
#                import (builtins.fetchTarball "https://github.com/youwen5/zen-browser-flake/archive/master.tar.gz")
		import (builtins.fetchTarball "https://github.com/youwen5/zen-browser-flake/archive/458cd16116c362a5e92d5db6bdc3599e4e8b1f4a.tar.gz")
                    {
                        inherit pkgs;
                    };
            porffor = pkgs.callPackage ./porffor/porf.nix { };
        in
        with pkgs;
        [
            vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is installed by default.
            wget
            curl
            fastfetch
            git
            cowsay
            pkgs.openscad-unstable
            pkgs.libreoffice-fresh
            libreoffice-qt6-fresh
            hunspell
            hunspellDicts.en_US
            wineWow64Packages.full
            nodejs
            btop
            kitty
# currently not available for aarch64, TODO install only on supported arch
#            arduino-ide
            arduino-cli
            pico-sdk
            xdg-desktop-portal-gtk
            pkgs.ashell
            cpio
            cmake
            gcc
            meson
            gnumake
            hyprlauncher
            polkit
            pkgs.proton-vpn
            zen-browser.default
            vlc
            kdePackages.qtsvg
            kdePackages.kio
            kdePackages.kio-fuse
            kdePackages.kio-extras
            kdePackages.dolphin
            unzip
            file
            glib
            winetricks
            ffmpeg
            xdg-desktop-portal
            usbimager
            tmpmail
            pkgs.qemu
            bc
            bison
            flex
            ncurses
            porffor
            gh
            pnpm
            gdevelop
            usbutils
            yazi
            blahaj
        ];

    environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

    environment.sessionVariables = {
        SAL_USE_VCLPLUGIN = "gtk3";
        XDG_CURRENT_DESKTOP = "Hyprland";
        NIXOS_OZONE_WL = "1";
        GSETTINGS_SCHEMA_DIR = "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
        LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    };

    # Some programs need SUID wrappers, can be configured further or
    # are started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #     enable = true;
    #     enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default 
    # settings for stateful data, like file locations and database
    # versions on your system were taken. It's perfectly fine and 
    # recommended to leave this value at the release version of the 
    # first install of this system. 
    # Before changing this value read the documentation for this
    # option (e.g. man configuration.nix or on 
    # https://nixos.org/nixos/options.html). 
    system.stateVersion = "26.05"; # Did you read the comment?

}
