{ config, pkgs, ... }:

{
 # this is my default packages and settings for system without Virtualbox
 system.build.description = "Default";
# $ nix search wget
    environment.systemPackages = with pkgs; [
	steam
	discord
	heroic
	wineWowPackages.stable
	winetricks
	protontricks
	vulkan-tools
	vkd3d
  	dxvk
  	mokutil
  	r2modman
  ];



  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

}
