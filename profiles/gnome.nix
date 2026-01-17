{ config, pkgs, lib, ... }:

{
  #### GNOME Desktop ####

  # GNOME Desktop Environment
  services.xserver.desktopManager.gnome.enable = true;
  
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
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-extension-manager

    gnomeExtensions.user-themes
    gnomeExtensions.dash-to-dock
  ];

  #### (Опционально) Настройки интерфейса через dconf
  # Если захочешь управлять GNOME декларативно
  #
  # services.gnome.settings = {
  #   "org.gnome.desktop.interface" = {
  #     gtk-theme = "Adwaita";
  #     icon-theme = "Adwaita";
  #     cursor-theme = "Adwaita";
  #     font-name = "Cantarell 11";
  #   };
  # };
}
