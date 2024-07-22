{
  description = "Basic example of Nix-on-Droid system config.";

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
  };

  outputs = inputs@{ self, ... }:
  let
    systemSettings = {
      system = "aarch64-linux";
      profile = "nix-on-droid";
      timeZone = "Europe/Brussels";
      locale = "en_US.UTF-8";
    };

    userSettings = {
      username = "strix";
      name = "Strix-Vyxlor";
      email = "strix.vyxlor@gmail.com";
      shell = "zsh";
      prompt = "starship";
      editor = "helix";
      editorCmd = "hx"; # please select manualy, i dont want to make a masive if else tree
      zix = "prebuild";
    };

    pkgs = import inputs.nixpkgs {
      system = systemSettings.system;
      config = {
        allowUnFree = true;
      };
    };
    
    lib = inputs.nixpkgs.lib;
    home-manager = inputs.home-manager-unstable;

    zix-pkg = inputs.zix.packages.${systemSettings.system}.${userSettings.zix};
  in {

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
}
