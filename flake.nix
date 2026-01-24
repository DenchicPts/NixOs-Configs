{
  description = "NixOS stable with unstable spicetify";

  inputs = {
    # 🔹 Основная система — STABLE
    nixpkgs.url = "github:NixOS/nixpkgs/20c4598c84a6";

    # Самая новая версия, но на новом ядре есть микрофризы
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # 🔹 UNSTABLE — только для отдельных пакетов
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # 🔹 spicetify-nix (совместим с unstable)
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, spicetify-nix, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
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

        

        # 🔹 ПРИМЕР: Конфигурация с VirtualBox (закомментирована)
        # Раскомментируй когда понадобится
        # vbox = nixpkgs.lib.nixosSystem {
        #   inherit system;
        #   specialArgs = commonSpecialArgs;
        #   modules = baseModules ++ [
        #     ./vms.nix  # раскомментируй эту строку в configuration.nix
        #     { 
        #       system.nixos.label = "VirtualBox";
        #     }
        #   ];
        # };

        # 🔹 ПРИМЕР: Экспериментальная конфигурация с новым ядром
        # testing = nixpkgs.lib.nixosSystem {
        #   inherit system;
        #   specialArgs = commonSpecialArgs;
        #   modules = baseModules ++ [
        #     { 
        #       system.nixos.label = "Testing-Kernel";
        #       boot.kernelPackages = pkgs.linuxPackages_testing;
        #     }
        #   ];
        # };

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