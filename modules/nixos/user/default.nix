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
        manage normal user with strixos module;
        If this is null all user related configuration will not be done
      '';
    };
    name = mkOption {
      type = types.str;
      default = "";
      description = ''
        full name of the user account
      '';
    };
    extraGroups = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        aditional groups for the user
      '';
    };
  };

  config =
    mkIf (cfg.username != null)
    {
      users.users.${cfg.username} = {
        isNormalUser = true;
        uid = 1000;
        description = cfg.name;
        inherit (cfg) extraGroups;
      };
    };
}
