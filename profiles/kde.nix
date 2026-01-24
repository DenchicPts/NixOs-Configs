{ config, pkgs, lib, ... }:

{
  #### KDE Plasma ####

  # Включаем Plasma
  #services.xserver.desktopManager.plasma5.enable = true;
  
  services.desktopManager.plasma6.enable = true;
  
  security.pam.services.sddm.enable = true;

  # Display Manager для KDE
  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Гарантированно отключаем GDM
  services.xserver.displayManager.gdm.enable = false;

  #### KDE / Qt интеграция ####
  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };

  #### KDE-приложения (минимум) ####
  environment.systemPackages = with pkgs; [
    kdePackages.dolphin
    kdePackages.konsole
    kdePackages.kate
    kdePackages.spectacle
    kdePackages.gwenview
    kdePackages.bluedevil
    kdePackages.kdeconnect-kde
  ];

  programs.zsh.enable = true;

  users.users.denchicpts-kde = {
    isNormalUser = true;
    description = "denchicpts KDE user";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    homeMode = "2770";
    group = "denchicpts-shared";
    shell = pkgs.zsh;
    hashedPasswordFile = "/etc/nixos/secrets/denchicpts-kde-password";
 };

  #systemd.tmpfiles.rules = [
  #  "d /home/denchicpts 2770 denchicpts denchicpts-shared - -"
  #  "d /home/denchicpts-kde 2770 denchicpts-kde denchicpts-shared - -"
  #];

}
