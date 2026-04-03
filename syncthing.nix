{ config, pkgs, ... }:
{
  services.syncthing = {
    enable = true;
    user = "denchicpts";
    group = "users";
    dataDir = "/home/denchicpts/Documents/Git";
    configDir = "/home/denchicpts/.config/syncthing";
    openDefaultPorts = true;
  };

  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 8384 ];
}
