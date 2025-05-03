{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  cfg = config.strixos.user;
in {
  options.strixos.user = {
    username = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        username given to home-manager
      '';
    };
    name = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        full name of the user account
      '';
    };
    email = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        email for user (needed for git)
      '';
    };
  };

  config = let
    username = let
      attempt = builtins.tryEval (
        assert builtins.isString cfg.username;
          cfg.username
      );
    in
      if attempt.success
      then attempt.value
      else throw "you need to specify the username";
  in {
    home = {
      inherit username;
      homeDirectory = "/home/" + username;
    };
  };
}
