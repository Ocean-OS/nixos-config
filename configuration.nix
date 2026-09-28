# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (import "${home-manager}/nixos")
  ];

  home-manager.users.me = {
    home.stateVersion = "26.05";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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
  systemd.services.display-manager.enable = false;
  services.xserver.enable = true;
  #  services.displayManager.gdm.enable = true;
  #  services.desktopManager.gnome.enable = true;
  programs.hyprland.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
  programs.direnv.enable = true;
  programs.hyprlock.enable = true;
  security.pam.services.hyprlock = { };
  security.polkit.enable = true;
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "us";
  #   variant = "";
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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
  ];
  fonts.fontconfig.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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
  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  # Install firefox.
  programs.firefox.enable = true;
  programs.neovim.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    let
      zen-browser =
        import (builtins.fetchTarball "https://github.com/youwen5/zen-browser-flake/archive/master.tar.gz")
          {
            inherit pkgs;
          };
      porffor = pkgs.callPackage ./porffor/porf.nix { };
    in
    with pkgs;
    [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
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
      arduino-ide
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
    ];
  environment.sessionVariables = {
    SAL_USE_VCLPLUGIN = "gtk3";
    XDG_CURRENT_DESKTOP = "Hyprland";
    NIXOS_OZONE_WL = "1";
    GSETTINGS_SCHEMA_DIR = "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
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
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
