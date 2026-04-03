{
  description = "NixOS stable with unstable spicetify";

  inputs = {

    # STABLE - основные пакеты
     nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Пофиг буду сидеть на САМОЙ новой версии. И всё равно что она не стабильна!
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # ЗАБУДЬТЕ
    # 🔹 UNSTABLE — только для отдельных пакетов
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # 🔹 spicetify-nix (совместим с unstable)
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable,  nixpkgs-stable ,spicetify-nix, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      stablePkgs = import nixpkgs-stable{
        inherit system;
        config.allowUnfree = true;
      };

      unstablePkgs = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      # 🔹 Общие specialArgs для всех конфигураций
      commonSpecialArgs = {
        unstable = unstablePkgs;
        inputs = { inherit spicetify-nix; };
      };

      # 🔹 Общие модули для всех конфигураций
      baseModules = [
        ./configuration.nix
        spicetify-nix.nixosModules.spicetify
      ];

    in {
      nixosConfigurations = {
        


        # 🔹 Стандартная конфигурация (основная)
        DenchicPts-laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = commonSpecialArgs;
          modules = baseModules ++ [
            ./profiles/gnome.nix
            { 
              system.nixos.label = "Gnome";
            }
          ];
        };


        ## Тестовая конфигурация для тестов самого последнего ядра
        testing-new-kernel = nixpkgs-unstable.lib.nixosSystem {
        inherit system;
        specialArgs = commonSpecialArgs;
        modules = baseModules ++ [
          ./profiles/gnome.nix
          { 
            system.nixos.label = "Testing-New-Kernel";
            boot.kernelPackages = unstablePkgs.linuxPackages_latest;
            
            # Попробуй эти параметры
            boot.kernelParams = [
              "amdgpu.dc=1"
              "amdgpu.dpm=1"
            ];
            
            # Обновленные графические пакеты
            environment.systemPackages = with unstablePkgs; [
              mesa
              vulkan-loader
              vulkan-validation-layers
            ];
          }
        ];
      };

        # 🔹 ПРИМЕР: Конфигурация с VirtualBox (закомментирована)
        # Раскомментируй когда понадобится
         vbox = nixpkgs.lib.nixosSystem {
           inherit system;
           specialArgs = commonSpecialArgs;
           modules = baseModules ++ [
             ./profiles/gnome.nix
             ./vms.nix  # раскомментируй эту строку в configuration.nix
             { 
               boot.kernelPackages = stablePkgs.linuxPackages_6_18;
               system.nixos.label = "VirtualBox";
             }
           ];
         };



        # 🔹 ПРИМЕР: Конфигурация с KDE вместо GNOME
         kde = nixpkgs.lib.nixosSystem {
           inherit system;
           specialArgs = commonSpecialArgs;
           modules = baseModules ++ [
             ./profiles/kde.nix
             { 
               system.nixos.label = "KDE";
             }
           ];
         };
      };

      # 🔹 Алиас для удобства (можно использовать короткое имя)
      nixosConfigurations.default = self.nixosConfigurations.DenchicPts-laptop;
    };
}