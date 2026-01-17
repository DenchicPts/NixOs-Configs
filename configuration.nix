# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:


let
  unstable = import <nixpkgs-unstable> { config = config.nixpkgs.config; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./firewall.nix
      ./docker.nix
      #./vms.nix
      ./standart.nix
      ./profiles/kde.nix
      #./profiles/gnome.nix
    ];


  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  nixpkgs.config.allowUnfree = true;
  # Я попробовал обновиться 18.12.2025
  # Столкнулся с проблемой что x11 как то работает не очень на 6.18, 6.17.8, потом откатился
  # Откатился до своего коммита 20c4598c84a6. Буду переодически проверять как там система
  # работает на новом ядре. 
  
  # !!! С Wayland никаких проблем, но hotkey дискорда для mute/unmute не работает вообще никак!
  # Вроде сделал тоннель но всё равно он отказался работать.

  # это для виртуалбокса, он тут не успевает обновляться для линукса. Поэтому пускай лучше сидит на своём старом ядре
  #boot.kernelPackages = pkgs.linuxPackages_6_16; 

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "DenchicPts-laptop"; # Define your hostname.

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.denchicpts = {
    isNormalUser = true;
    description = "denchicpts";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Riga";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";



  # =======================
  # GRUB AND THEMES + OPTIMIZATION
  # =======================
  boot.loader = {
    systemd-boot.enable = false;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    
    grub = {
      enable = true;
      version = 2;
      efiSupport = true;
      efiInstallAsRemovable = false;
      device = "nodev";
      useOSProber = true;  # чтобы автоматически находить доп OS
      timeout = 5; # 5 секунд как ты хотел
    };
  };

  boot = {
    # Современный systemd в initrd (ускоряет загрузку)
    initrd.systemd.enable = true;
    # В будущем надо разобраться с plymooth, иконка загрузки типо
  };
  


  # Enable sound with pipewire.
  services.pulseaudio.enable = false;

# =======================
# SERVICES
# =======================
  services = {
    # X11 & GNOME
    xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];

      xkb = {
        layout = "us";
        variant = "";
      };
      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
      
      # Wayland
    };

    # Audio
    pipewire = {
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

    # GNOME services

    # System services
    udisks2.enable = true;
    gvfs.enable = true;
    flatpak.enable = true;
    
    # Fingerprint
    fprintd.enable = true;

    # VPN
    netbird.enable = true;

    # ОТКЛЮЧЕННЫЕ СЕРВИСЫ (для ускорения)
    printing.enable = false;      # Принтеры
    avahi.enable = false;          # Поиск устройств в сети
  };

# =======================
# SYSTEMD OPTIMIZATION
# =======================
  systemd = {
    # Отключаем ожидание сети (экономия ~7 секунд)
    services.NetworkManager-wait-online.enable = false;
    
    # Docker socket activation (экономия ~2.7 секунды)
    services.docker = {
      wantedBy = lib.mkForce [];
    };
    sockets.docker.wantedBy = [ "sockets.target" ];
    
    # Ускоряем таймауты
    extraConfig = ''
      DefaultTimeoutStartSec=10s
      DefaultTimeoutStopSec=5s
    '';

    services.NetworkManager.serviceConfig = {
      TimeoutStartSec = "2s";
    };
  };

  # =======================
  # SECURITY & AUDIO
  # =======================
  security = {
    rtkit.enable = true;
    # For fingerprint use
    pam.services.sudo.fprintAuth = true;
  };

  programs = {
    firefox.enable = true;
    gamescope.enable = true;
    
    # Для AppImage файлов
    appimage = {
      enable = true;
      binfmt = true;
    };
  };


  # Включаем поддержку OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # для игр/Proton
  };


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
	temurin-jre-bin-17
  lutris
  python3
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
