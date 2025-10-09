{ config, pkgs, ... }:

{
  networking.firewall.enable = true;

  # TCP порты
  networking.firewall.allowedTCPPorts = [
#    22     # SSH
    80     # HTTP
    443    # HTTPS
    445    # SMB
    25565  # Minecraft
    27015  # Steam server
  ];

  # UDP порты
  networking.firewall.allowedUDPPorts = [
    445 # SMB
    25565  # Minecraft
    27015  # Steam server
  ];

  # ICMP (ping)
  networking.firewall.allowPing = false; # как ufw по умолчанию

  # Проверка spoofing
  networking.firewall.checkReversePath = true;
}

