{ userSettings, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [ "${userSettings.username}" ];
      PermitRootLogin = "prohibit-password";
    };
  };
}
