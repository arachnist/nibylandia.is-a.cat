{ config, pkgs, lib, ... }:

{
  options = {
    my.interactive.enable =
      lib.mkEnableOption "Configuration specific for graphical machines";
  };

  config = lib.mkIf config.my.interactive.enable {
    programs.zsh = {
      enable = true;
      enableBashCompletion = true;
      ohMyZsh.enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
    programs.bash.enableCompletion = true;

    programs.neovim = {
      enable = true;
      withRuby = true;
      vimAlias = true;
      viAlias = true;
      defaultEditor = true;
    };

    programs.tmux = {
      enable = true;
      terminal = "screen256-color";
      clock24 = true;
    };

    programs.mtr.enable = true;

    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowBroken = true;

    environment.systemPackages = with pkgs; [
      file
      git
      go
      libarchive
      lm_sensors
      lshw
      lsof
      pciutils
      pry
      pv
      python3
      python3Packages.ipython
      strace
      usbutils
      wget
      zip
      config.boot.kernelPackages.perf
      age
      sshfs
      dig
      dstat
      htop
      iperf
      whois
      xxd
      tcpdump
      traceroute
    ];
  };
}
