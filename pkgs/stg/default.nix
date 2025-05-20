{
  lib,
  stdenv,
  python3Packages,
  colorz,
}:
python3Packages.buildPythonApplication {
  pname = "strix-theme-generator";
  version = "1.0";

  buildInputs = with python3Packages; [setuptools wheel];
  propagatedBuildInputs = with python3Packages; [
    configargparse
    toml
    colorz
  ];

  checkPhase = ''
    $out/bin/strix-theme-generator --help > /dev/null
  '';

  src = ./.;
}
