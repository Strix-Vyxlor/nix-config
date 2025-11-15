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
    strixos = inputs."strixos-${flakeSettings.branch}";

    pkgs = import nixpkgs {
      inherit (flakeSettings) system;
      config = {
        allowUnfree = true;
      };
    };

    inherit (nixpkgs) lib;
  in {
    homeConfigurations = {
      default = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (./. + "/profiles" + ("/" + flakeSettings.profile) + "/home.nix")
          strixos.homeManagerModules.strixos
        ];
      };

      wsl = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./profiles/wsl/home.nix
          strixos.homeManagerModules.strixos
        ];
      };
    };

    nixosConfigurations = {
      default = lib.nixosSystem {
        inherit (flakeSettings) system;
        modules = [
          (./. + "/profiles" + ("/" + flakeSettings.profile) + "/configuration.nix")
          strixos.nixosModules.strixos
        ];
      };

      wsl = lib.nixosSystem {
        inherit (flakeSettings) system;
        modules = [
          ./profiles/wsl/configuration.nix
          inputs.nixos-wsl.nixosModules.default
          strixos.nixosModules.strixos
        ];
      };

      rpi5-sd = lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./profiles/rpi/sd-image.nix
          strixos.nixosModules.strixos
        ];
        specialArgs = {
          inherit nixpkgs;
        };
      };

      visionfive2-octoprint = lib.nixosSystem {
        system = "riscv64-linux";
        modules = [
          strixos.nixosModules.strixos
          ./images/visionfive2/octoprint/configuration.nix
        ];
      };
    };

    nixOnDroidConfigurations = {
      inherit pkgs;
      default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        inherit pkgs;
        modules = [
          ./profiles/nix-on-droid/configuration.nix
          strixos.nixOnDroidModules.strixos
        ];
      };
    };
  };

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    strixos-unstable = {
      url = "github:Strix-Vyxlor/strixos/unstable";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    strixos-stable = {
      url = "github:Strix-Vyxlor/strixos/stable";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

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

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };
}
