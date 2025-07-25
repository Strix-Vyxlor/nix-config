{python3Packages}:
python3Packages.buildPythonApplication {
  pname = "colorfull-papirus";
  version = "1.0";
  pyproject = true;
  build-system = with python3Packages; [setuptools];

  buildInputs = with python3Packages; [setuptools wheel];
  propagatedBuildInputs = with python3Packages; [
  ];

  checkPhase = ''
    $out/bin/colorfull-papirus --help > /dev/null
  '';

  src = ./.;
}
