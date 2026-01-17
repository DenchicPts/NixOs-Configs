{ config, pkgs, lib, ... }:

{
  #### KDE Plasma ####

  # Включаем Plasma
  services.xserver.desktopManager.plasma5.enable = true;
  
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
    plasma5Packages.kdeconnect-kde
  ];

  programs.zsh.enable = true;

  users.users.denchicpts-kde = {
  isNormalUser = true;
  description = "denchicpts KDE user";
  extraGroups = [ "wheel" "networkmanager" "docker" ];
  shell = pkgs.zsh;
};

}
