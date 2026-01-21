{ config, pkgs, lib, ... }:

{
  #### GNOME Desktop ####

  # GNOME Desktop Environment
  services.xserver.desktopManager.gnome.enable = true;

  # FingerPrint  
  security.pam.services.gdm-fingerprint.enable = true;
  
  # Display Manager — GDM
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  #### GNOME services ####
  services.gnome = {
    # Онлайн-аккаунты (Google Drive и т.д.)
    gnome-online-accounts.enable = true;

    # Отключаем лишнее (ускорение)
    evolution-data-server.enable = lib.mkForce false;
    gnome-user-share.enable = false;
  };

  #### GNOME tools / extensions ####

  environment.systemPackages = [
    pkgs.gnome-tweaks
    pkgs.gnome-extension-manager
    pkgs.gnomeExtensions.user-themes
    pkgs.gnomeExtensions.dash-to-dock
  ];
  
  imports = [
    ./gnome-extensions.nix
  ];
}
