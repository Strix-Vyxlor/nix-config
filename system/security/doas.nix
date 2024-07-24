{ pkgs, userSettings, ... }:
{
  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [{
      users = [ "${userSettings.username}" ];
      keepEnv = true;
      persist = true;
    }];
  };

  environment.systemPackages = [
    (pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
  ];
}
