{ config, pkgs, ... }:

{

  system.build.description = "VirtualBox";

  # Чёрный список модулей KVM (чтобы они не загружались автoматом)
  boot.blacklistedKernelModules = [ "kvm" "kvm_amd" "kvm_intel" ];
  
  # Явно грузим модули VirtualBox (будут собраны под текущее ядро)
  boot.kernelModules = [ "vboxdrv" "vboxnetflt" "vboxnetadp" ];
  
  # Включаем поддержку VirtualBox на хосте
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.dragAndDrop = true;
  
  virtualisation.libvirtd.enable = false;
  services.upower.enable = true;

  users.extraGroups.vboxusers.members = [ "denchicpts" ];


  environment.systemPackages = with pkgs; [
	samba
	
  ];
  
  users.users.test1 = {
  isNormalUser = true;
  description = "Samba test user";
  home = "/home/test1";
  extraGroups = [ "users" "vboxusers" ];
  initialHashedPassword = "";
};
  
  
  ## SAMBA
services.samba = {
  enable = true;
  securityType = "user";
  settings = {
    global = {
      "workgroup" = "WORKGROUP";
      "map to guest" = "Bad User";
      "guest account" = "nobody";
    };
    Shared = {
      path = "/home/Shared";
      "guest ok" = "no";
      "browseable" = "yes";
      "create mask" = "0755";
      "directory mask" = "0750";
      "writeable" = "yes";
    };
    
    
    "My Sweet Home" = {
      path = "/home/denchicpts/Documents";
      "browseable" = "yes";
      "read only" = "no";
      "guest ok" = "no";
      "valid users" = "denchicpts";
    };

    	
  };
};


  

}
