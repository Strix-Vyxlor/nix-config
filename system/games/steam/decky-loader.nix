{
  pkgs,
  lib,
  ...
}: let
  decky-loader-pkg = pkgs.python3.pkgs.buildPythonPackage rec {
    pname = "decky-loader";
    version = "3.1.5";

    src = pkgs.fetchFromGitHub {
      owner = "SteamDeckHomebrew";
      repo = "decky-loader";
      rev = "v${version}";
      hash = "sha256-2unRxeN2fhkkcOmiWh7OUxJtC65VKX1Zi8xyIP+M5lw=";
    };

    pnpmDeps = pkgs.pnpm_9.fetchDeps {
      inherit pname version src;
      sourceRoot = "${src.name}/frontend";
      hash = "sha256-WzYbqcniww6jpLu1PIJ3En/FPZSqOZuK6fcwN1mxuNQ=";
    };

    pyproject = true;

    pnpmRoot = "frontend";

    nativeBuildInputs = with pkgs; [
      nodejs
      pnpm_9.configHook
    ];

    preBuild = ''
      cd frontend
      pnpm build
      cd ../backend
    '';

    build-system = with pkgs.python3.pkgs; [
      poetry-core
      poetry-dynamic-versioning
    ];

    dependencies = with pkgs.python3.pkgs; [
      aiohttp
      aiohttp-cors
      aiohttp-jinja2
      certifi
      multidict
      packaging
      setproctitle
      watchdog
    ];

    makeWrapperArgs = [
      "--prefix PATH : ${lib.makeBinPath (with pkgs; [coreutils psmisc brightnessctl])}"
    ];

    pythonRelaxDeps = [
      "aiohttp-cors"
      "watchdog"
    ];

    passthru.python = pkgs.python3;

    meta = with lib; {
      description = "A plugin loader for the Steam Deck";
      homepage = "https://github.com/SteamDeckHomebrew/decky-loader";
      platforms = platforms.linux;
      license = licenses.gpl2Only;
    };
  };
in {
  users.users.decky = {
    group = "decky";
    home = "/var/lib/decky-loader";
    isSystemUser = true;
  };
  users.groups.decky = {};

  systemd.services.decky-loader = {
    description = "Steam Deck Plugin Loader";

    wantedBy = ["multi-user.target"];
    after = ["network.target"];

    environment = {
      UNPRIVILEGED_USER = "decky";
      UNPRIVILEGED_PATH = "/var/lib/decky-loader";
      PLUGIN_PATH = "/var/lib/decky-loader/plugins";
    };

    path = with pkgs; [];

    preStart = ''
      mkdir -p "/var/lib/decky-loader"
      chown -R "decky:" "/var/lib/decky-loader"
    '';

    serviceConfig = {
      ExecStart = "${decky-loader-pkg}/bin/decky-loader";
      KillMode = "process";
      TimeoutStopSec = 45;
    };
  };
}
