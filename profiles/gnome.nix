{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-extension-manager
    gnomeExtensions.user-themes
    gnomeExtensions.dash-to-dock
  ];

  # Настройки интерфейса (тема/иконки)
#  services.gnome.settings = {
 #   "org.gnome.desktop.interface" = {
  #    gtk-theme = "Adwaita";
   #   icon-theme = "Adwaita";
    #  cursor-theme = "Adwaita";
     # font-name = "Cantarell 11";
   # };
  #};
}

