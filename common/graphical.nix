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
      plymouth = { 
        enable = false;
	theme = "breeze";
	extraConfig = ''
	  ShowDelay=0
	'';
      };
      initrd.systemd.enable = true;
    };

    sound.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      media-session.config.bluez-monitor.rules = [
        {
          # Matches all cards
          matches = [{ "device.name" = "~bluez_card.*"; }];
          actions = {
            "update-props" = {
              "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
              # mSBC is not expected to work on all headset + adapter combinations.
              "bluez5.msbc-support" = true;
              # SBC-XQ is not expected to work on all headset + adapter combinations.
              "bluez5.sbc-xq-support" = true;
            };
          };
        }
        {
          matches = [
            # Matches all sources
            {
              "node.name" = "~bluez_input.*";
            }
            # Matches all outputs
            { "node.name" = "~bluez_output.*"; }
          ];
          actions = { "node.pause-on-idle" = false; };
        }
      ];
    };

    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.backend = "wpa_supplicant";
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
          enable = false; # temporary? until that segfault is fixed
          settings.Wayland.SessionDir =
            "${pkgs.plasma5Packages.plasma-workspace}/share/wayland-sessions";
        };
	gdm.enable = true;
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
        carlito
        meslo-lgs-nf
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
      kdeconnect.enable = true;
      sway = {
        enable = true;
      };
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
      thunderbird
      feh
      virt-manager
      cura
      ncdu
      nixos-option
      yt-dlp
      lsix
    ];

    nixpkgs.config.joypixels.acceptLicense = true;
    nixpkgs.config.firefox = {
      enablePlasmaBrowserIntegration = true;
      enableBrowserpass = true;
    };

    users.users.ar = {
      hashedPassword = lib.mkForce
        config.my.secrets.userDB.ar.passwords.${config.networking.hostName};
    };

    my.interactive.enable = lib.mkDefault true;
  };
}
