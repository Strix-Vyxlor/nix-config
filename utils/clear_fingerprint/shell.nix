let
  pkgs = import <nixpkgs> {
    config = {
      allowUnfree = true;
    };
  };
in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      python3
      python3Packages.pygobject3
      gobject-introspection
      libfprint
      gusb
      libfprint-2-tod1-goodix-550a
    ];

    shellHook = ''
      echo "Run 'sudo LD_LIBRARY_PATH=\$LD_LIBRARY_PATH PYTHONPATH=\$PYTHONPATH GI_TYPELIB_PATH=\$GI_TYPELIB_PATH python3 ./fprint_clear_storage.py'"
    '';
  }
