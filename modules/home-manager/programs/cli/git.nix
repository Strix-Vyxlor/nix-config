{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.strixos.programs.cli.git;
  userCfg = config.strixos.user;
in {
  options.strixos.programs.cli.git = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable git
      '';
    };
    gh = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable github integration
      '';
    };
  };

  config = let
    email = let
      attempt = builtins.tryEval (assert builtins.isString userCfg.email; userCfg.email);
    in
      if attempt.success
      then attempt.value
      else throw "git needs an email";
    name = let
      attempt = builtins.tryEval (assert builtins.isString userCfg.name; userCfg.name);
    in
      if attempt.success
      then attempt.value
      else throw "git needs an full name";
  in {
    programs = {
      git = {
        inherit (cfg) enable;
        settings.user = {
          inherit name;
          inherit email;
          init.defaultBrach = "master";
        };
      };
      gh = {
        enable = cfg.gh;
        gitCredentialHelper.enable = true;
        settings = {
          git_protocol = "ssh";
        };
      };
    };
  };
}
