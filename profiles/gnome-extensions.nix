{ config, pkgs, lib, unstable, ... }:

{
  # GNOME Shell Extensions

  environment.systemPackages = with pkgs.gnomeExtensions; [
    dash-to-panel
    hide-top-bar
    vitals
    quick-settings-audio-panel
    clipboard-indicator
    user-themes
  ] ++ [
    # Из unstable
      unstable.gnomeExtensions.fuzzy-app-search
  ];
}