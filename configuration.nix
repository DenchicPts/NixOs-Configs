# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:


let
  unstable = import <nixpkgs-unstable> { config = config.nixpkgs.config; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./profiles/gnome.nix
      ./firewall.nix
      ./docker.nix
      #./vms.nix
      ./standart.nix
      
    ];


  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  
  ## NEW GRUBBBSS MY SHEILA
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = false;  # полезно для некоторых EFI
  boot.loader.grub.device = "nodev";               # при EFI не указываем диск напрямую
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.useOSProber = true;          # чтобы автоматически находить Ubuntu



  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # Я попробовал обновиться 18.12.2025
  # Столкнулся с проблемой что x11 как то работает не очень на 6.18, 6.17.8, потом откатился
  # Откатился до своего коммита 20c4598c84a6. Буду переодически проверять как там система
  # работает на новом ядре. 
  
  # !!! С Wayland никаких проблем, но hotkey дискорда для mute/unmute не работает вообще никак!
  # Вроде сделал тоннель но всё равно он отказался работать.



  # это для виртуалбокса, он тут не успевает обновляться для линукса. Поэтому пускай лучше сидит на своём старом ядре
  #boot.kernelPackages = pkgs.linuxPackages_6_16; 
  services.flatpak.enable = true;
  
  networking.hostName = "DenchicPts-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # AMD GPU
  services.xserver.videoDrivers = ["amdgpu"];

  # Set your time zone.
  time.timeZone = "Europe/Riga";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  ############services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.denchicpts = {
    isNormalUser = true;
    description = "denchicpts";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [
    #  thunderbird
    ];
  };


  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;


## Netbird VPN
services.netbird = {
  enable = true;
};

  # Включаем поддержку OpenGL
hardware.graphics = {
  enable = true;
  enable32Bit = true; # для игр/Proton
};


	# Wayland
services.xserver.displayManager.gdm = {
  enable = true;
  wayland = true;
};



services.udisks2.enable = true;
services.gvfs.enable = true;


  # $ nix search wget
environment.systemPackages = with pkgs; [
	netbird
	spotify
	obsidian
	gitkraken
	git
	tdesktop
	corectrl
	vscode
	vulkan-tools
	mesa-demos
	nodejs_22		
	docker_28
	docker-compose
  	vlc
  	gimp
  	libreoffice
  	remmina
  	curl
  	wget
  	gjs
	glib
	gtk4
 	mesa
	mesa.drivers
	mesa-demos
	vulkan-loader
	vulkan-validation-layers
	libdrm
	steam-run
	duf
	protontricks
	winetricks
	jq
	fd
	wireshark
	temurin-jre-bin-17
	## UNSTABLE PACKAGE

	unstable.fastfetch  	
  ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';


# Возможное решение для того чтобы можно было запускать стандартные линуксовые бинарники
programs.nix-ld = {
  enable = true;
  libraries = with pkgs; [
    # Стандартные библиотеки
    stdenv.cc.cc.lib
    zlib
    zstd
    fuse3
    icu
    nss
    openssl
    curl
    expat
    
    # Графика
    libGL
    libva
    libdrm
    mesa
    vulkan-loader
    libgbm
    
    # Xorg
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXrender
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libxcb
    xorg.libXScrnSaver
    xorg.libXxf86vm
    xorg.libXinerama
    xorg.libXtst
    xorg.libxshmfence
    xorg.libXmu
    xorg.libXt
    xorg.libSM
    xorg.libICE
    
    # Аудио
    alsa-lib
    pulseaudio
    libpulseaudio
    
    # GTK/Системное
    glib
    gtk3
    gtk2
    cairo
    pango
    fontconfig
    freetype
    dbus
    at-spi2-atk
    at-spi2-core
    atk
    
    # Дополнительные часто используемые
    libpng
    libjpeg
    libtiff
    libwebp
    pixman
    gdk-pixbuf
    
    # Системные
    systemd
    libnotify
    libsecret
    util-linux
    e2fsprogs
    
    # Для игр
    SDL2
    openal
    
    # Дополнительные системные библиотеки
    attr
    libssh
    bzip2
    libxml2
    acl
    libsodium
    xz
    libelf
    
    # Сетевые
    krb5
    keyutils
    
    # Прочие полезные
    cups
    nspr
    libcap
    libappindicator-gtk3
    libdbusmenu
  ];
};


# Для AppImage файлов
programs.appimage = {
  enable = true;
  binfmt = true;
};



# For fingerprint use
services.fprintd.enable = true;
security.pam.services.gdm-fingerprint.enable = true;
security.pam.services.sudo.fprintAuth = true;




#services.udev.packages = [ pkgs.virtualbox ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
