{
  description = "Strix Vyxlor nix config.";

  outputs = inputs @ {self, ...}: let
    systemSettings = {
      system = "x86_64-linux";
      nixpkgs = "nixpkgs";
      home-manager = "home-manager";
      profile = "laptop";
      subprofile = "";
      kernel = pkgs.linuxPackages_testing;
      timezone = "Europe/Brussels";
      locale = "en_US.UTF-8";
      hostname = "nixos";
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
      theme = "red-sunset";

      # terminal
      shell = "nu";
      prompt = "oh-my-posh";
      zix = "default";
      editor = "nvim";
    };

    pkgs = import inputs.${systemSettings.nixpkgs} {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
      };
      overlays = [
        (import inputs.rust-overlay)
        inputs.neovim.overlays.${systemSettings.system}.neovim
      ];
    };

    lib = inputs.nixpkgs.lib;
    home-manager = inputs.${systemSettings.home-manager};

    zix-pkg = inputs.zix.packages.${systemSettings.system}.${userSettings.zix};
  in {
    homeConfigurations = {
      default = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix")
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
        system = systemSettings.system;
        modules = [
          (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
        ];
        specialArgs = {
          inherit zix-pkg;
          inherit systemSettings;
          inherit userSettings;
          inherit inputs;
        };
      };

      rpi = lib.nixosSystem {
        system = "aarch64-linux";
        modules = [./profiles/rpi/sd-image.nix];
        specialArgs = {
          inherit zix-pkg;
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
          inherit zix-pkg;
          inherit systemSettings;
          inherit userSettings;
          inherit inputs;
        };
      };
    };
  };

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager-unstable";
    };

    zix = {
      url = "github:Strix-Vyxlor/zix/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";

    neovim = {
      url = "github:Strix-Vyxlor/nvim_config";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-colorizer.url = "github:nutsalhan87/nix-colorizer";
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
    zen-browser.url = "github:ch4og/zen-browser-flake";

    nix-autobahn.url = "github:Lassulus/nix-autobahn";
  };
}
