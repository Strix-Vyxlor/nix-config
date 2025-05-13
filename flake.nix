{
  description = "Strix Vyxlor nix config.";

  outputs = inputs @ {self, ...}: let
    systemSettings = {
      system = "x86_64-linux";
      branch = "unstable";
      profile = "laptop";
      subprofile = "";
      kernel = pkgs.linuxPackages_testing;
      timezone = "Europe/Brussels";
      locale = "en_US.UTF-8";
      hostName = "nixos";
    };

    userSettings = {
      username = "strix";
      name = "Strix Vyxlor";
      email = "strix.vyxlor@gmail.com";
      configDir = "~/.nix-config";

      # theming
      wm = "hyprland";
      browser = "zen";
      term = "kitty";
      font = "Inter Regular";
      fontPkg = pkgs.inter;
      theme = "nord";

      # terminal
      shell = "nu";
      prompt = "oh-my-posh";
      editor = "nvim";
    };

    home-manager = inputs."home-manager-${systemSettings.branch}";
    nixpkgs = inputs."nixpkgs-${systemSettings.branch}";
    stylix = inputs."stylix-${systemSettings.branch}";

    pkgs = import nixpkgs {
      inherit (systemSettings) system;
      config = {
        allowUnfree = true;
      };
      overlays = [
        (import inputs.rust-overlay)
        inputs.zix.overlays.zix
      ];
    };

    inherit (nixpkgs) lib;
  in {
    homeConfigurations = {
      default = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (./. + "/profiles" + ("/" + systemSettings.profile) + ("/" + systemSettings.subprofile) + "/home.nix")
          self.homeManagerModules.strixos
          stylix.homeManagerModules.stylix
        ];
        extraSpecialArgs = {
          inherit systemSettings;
          inherit userSettings;
          inherit inputs;
        };
      };
    };

    nixosConfigurations = {
      default = lib.nixosSystem {
        inherit (systemSettings) system;
        modules = [
          (./. + "/profiles" + ("/" + systemSettings.profile) + ("/" + systemSettings.subprofile) + "/configuration.nix")
          self.nixosModules.strixos
          stylix.nixosModules.stylix
        ];
        specialArgs = {
          inherit systemSettings;
          inherit userSettings;
          inherit inputs;
        };
      };

      rpi = lib.nixosSystem {
        system = "aarch64-linux";
        modules = [./profiles/rpi/sd-image.nix];
        specialArgs = {
          inherit systemSettings;
          inherit userSettings;
          inherit inputs;
        };
      };
    };

    nixOnDroidConfigurations = {
      inherit pkgs;
      default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        inherit pkgs;
        modules = [./profiles/nix-on-droid/configuration.nix];
        extraSpecialArgs = {
          inherit systemSettings;
          inherit userSettings;
          inherit inputs;
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
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.11";
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
      url = "github:danth/stylix/release-24.11";
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

    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };
}
