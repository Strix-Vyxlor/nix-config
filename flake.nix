{
  description = "Strix Vyxlor nix config.";

  outputs = inputs @ {self, ...}: let
    flakeSettings = {
      system = "x86_64-linux";
      branch = "unstable";
      profile = "laptop";
    };

    home-manager = inputs."home-manager-${flakeSettings.branch}";
    nixpkgs = inputs."nixpkgs-${flakeSettings.branch}";
    stylix = inputs."stylix-${flakeSettings.branch}";

    pkgs = import nixpkgs {
      inherit (flakeSettings) system;
      config = {
        allowUnfree = true;
      };
      overlays = [
        (import inputs.rust-overlay)
      ];
    };

    inherit (nixpkgs) lib;
  in {
    homeConfigurations = {
      default = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (./. + "/profiles" + ("/" + flakeSettings.profile) + "/home.nix")
          self.homeManagerModules.strixos
          stylix.homeModules.stylix
        ];
        extraSpecialArgs = {
          inherit (flakeSettings) branch;
        };
      };

      wsl = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./profiles/wsl/home.nix
          self.homeManagerModules.strixos
          stylix.homeModules.stylix
        ];
        extraSpecialArgs = {
          inherit (flakeSettings) branch;
        };
      };
    };

    nixosConfigurations = {
      default = lib.nixosSystem {
        inherit (flakeSettings) system;
        modules = [
          (./. + "/profiles" + ("/" + flakeSettings.profile) + "/configuration.nix")
          self.nixosModules.strixos
          stylix.nixosModules.stylix
        ];
        specialArgs = {
          inherit (flakeSettings) branch;
        };
      };

      wsl = lib.nixosSystem {
        inherit (flakeSettings) system;
        modules = [
          ./profiles/wsl/configuration.nix
          self.nixosModules.strixos
          stylix.nixosModules.stylix
          inputs.nixos-wsl.nixosModules.default
        ];
        specialArgs = {
          inherit (flakeSettings) branch;
        };
      };

      iso = lib.nixosSystem {
        inherit (flakeSettings) system;
        modules = [
          self.nixosModules.strixos
          stylix.nixosModules.stylix
          ./profiles/iso/configuration.nix
        ];
        specialArgs = {
          inherit (flakeSettings) branch;
        };
      };

      rpi5-sd = lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./profiles/rpi/sd-image.nix
          self.nixosModules.strixos
          stylix.nixosModules.stylix
        ];
        specialArgs = {
          inherit (flakeSettings) branch;
          inherit nixpkgs;
        };
      };
    };

    nixOnDroidConfigurations = {
      inherit pkgs;
      default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        inherit pkgs;
        modules = [./profiles/nix-on-droid/configuration.nix];
        extraSpecialArgs = {
          inherit (flakeSettings) branch;
        };
      };
    };

    nixosModules = rec {
      default = strixos;
      strixos = {imports = [(import ./modules/nixos inputs)];};
    };

    homeManagerModules = rec {
      default = strixos;
      strixos = {imports = [(import ./modules/home-manager inputs)];};
    };

    overlays = rec {
      default = strixos;
      strixos = import ./overlay.nix;
    };
  };

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager-unstable";
    };

    zix = {
      url = "github:Strix-Vyxlor/zix/master";
    };

    stylix-unstable = {
      url = "github:danth/stylix/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    stylix-stable = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    rust-overlay.url = "github:oxalica/rust-overlay";

    strixvim = {
      url = "github:Strix-Vyxlor/strixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };
}
