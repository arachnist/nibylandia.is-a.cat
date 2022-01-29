{ ... }:

{
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    openFirewall = true;
  };
  programs.mosh.enable = true;
}
