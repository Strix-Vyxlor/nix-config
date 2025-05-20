{
  pkgs,
  imagePath,
}:
pkgs.stdenv.mkDerivation {
  name = "generated-theme";
  src = ./.;

  buildInputs = [pkgs.strix-theme-generator];

  buildPhase = ''
    mkdir -p $out
    strix-theme-generator -o $out/theme.toml ${imagePath}
  '';
}
