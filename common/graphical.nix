{ config, lib, pkgs, ... }:

{
  options = {
    my.graphical.enable =
      lib.mkEnableOption "Configuration specific for graphical machines";
  };

  config = lib.mkIf config.my.graphical.enable {
    boot = {
      extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
      extraModprobeConfig = ''
        options v4l2loopback devices=4 exclusive_caps=1
      '';
    };

    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.backend = "iwd";
    hardware.steam-hardware.enable = true;
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
    };
    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
    };

    services.xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;
      displayManager = {
        sddm = {
          enable = true;
          settings.Wayland.SessionDir =
            "${pkgs.plasma5Packages.plasma-workspace}/share/wayland-sessions";
        };
      };

      layout = "pl";
      xkbOptions = "ctrl:nocaps";
      libinput.enable = true;
    };

    fonts = {
      enableDefaultFonts = true;
      fonts = with pkgs; [
        nerdfonts
        terminus_font
        terminus_font_ttf
        noto-fonts-cjk
        noto-fonts-emoji
        noto-fonts-emoji-blob-bin
        joypixels
        twemoji-color-font
      ];
    };

    i18n.inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ uniemoji ];
    };

    services.printing = {
      enable = true;
      drivers = with pkgs; [ cups-dymo ];
    };

    services.avahi = {
      enable = true;
      nssmdns = true;
    };

    services.flatpak.enable = true;

    users.users.ar = {
      extraGroups = [
        "video"
        "dialout" # usb serial adapters
        "networkmanager"
      ];
    };

    programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
      adb.enable = true;
      fuse.userAllowOther = true;
      dconf.enable = true;
      mosh.enable = true;
    };

    environment.systemPackages = with pkgs; [
      arandr
      chromium
      electrum
      ffmpeg-full
      firefox
      imagemagick
      inkscape
      kate
      kdeconnect
      keybase-gui
      kmail
      kolourpaint
      nixfmt
      okular
      paprefs
      pavucontrol
      prusa-slicer
      signal-desktop
      solvespace
      spotify
      super-slicer-latest
      youtube-dl
      morph
      mpv
      gphoto2
      minicom
      maim
    ];

    nixpkgs.config.joypixels.acceptLicense = true;
    nixpkgs.config.firefox = {
      enablePlasmaBrowserIntegration = true;
      enableBrowserpass = true;
    };

    users.users.ar = {
      hashedPassword = lib.mkForce
        config.my.secrets.userDB.ar.passwords."${config.networking.hostName}";
    };

    my.interactive.enable = lib.mkDefault true;
  };
}
