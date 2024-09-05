{
  description = "Strix Vyxlor nix config."; 

  outputs = inputs@{ self, ... }:
    let
      systemSettings = {
        system = "x86_64-linux";
        profile = "laptop";
        kernel = pkgs.linuxPackages_latest;
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
        browser = "brave";
        term = "alacritty";
        font = "Inter Regular";
        fontPkg = pkgs.inter;
        theme = "catppuccin-mocha-peach";

        # terminal
        shell = "zsh";
        prompt = "oh-my-posh";
        zix = "default";
        editor = "nvim";
      };

      pkgs = import inputs.nixpkgs {
        system = systemSettings.system;
        config = {
          allowUnFree = true;
        };
        overlays = [ 
          (import inputs.rust-overlay)
          inputs.neovim.overlays.${systemSettings.system}.neovim
        ];
      };

      lib = inputs.nixpkgs.lib;
      home-manager = inputs.home-manager-unstable;

      zix-pkg = inputs.zix.packages.${systemSettings.system}.${userSettings.zix};
    in
    {

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

        rpi-example = lib.nixosSystem {
          system = "aarch64-linux";
          modules = [ ./profiles/rpi/sd-image.nix ];
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
          modules = [ ./profiles/nix-on-droid/configuration.nix ];
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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager-unstable";
    };

    zix = {
      url = "github:Strix-Vyxlor/zix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";

    neovim = {
      url = "github:Strix-Vyxlor/nvim_config";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 

    nix-colorizer.url = "github:nutsalhan87/nix-colorizer";
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
  };
}
