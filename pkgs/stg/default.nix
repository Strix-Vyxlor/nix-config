{
  lib,
  stdenv,
  python3Packages,
  colorz,
}:
python3Packages.buildPythonApplication {
  pname = "strix-theme-generator";
  version = "1.0";

  pyproject = true;
  build-system = with python3Packages; [setuptools];

  buildInputs = with python3Packages; [setuptools wheel];
  propagatedBuildInputs = with python3Packages; [
    toml
    colorz
  ];

  checkPhase = ''
    $out/bin/strix-theme-generator --help > /dev/null
  '';

  src = ./.;
}
