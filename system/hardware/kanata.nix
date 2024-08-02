{ pkgs, ... }:
{
  services.kanata = {
    enable = true;
    keyboards."default" = {
      config = ''
        (deflocalkeys-linux
          OEM_7 41
          a 16
          z 17
          q 30
          w 44
          m 39
          OEM_10 86

          1 2
          2 3
          3 4
          4 5
          5 6
          6 7
          7 8
          8 9
          9 10
          0 11

          OEM_6 26
          OEM_1 27
          OEM_4 12
          OEM_MINUS 13
          OEM_PLUS 53
          OEM_2 52
          OEM_PERIOD 51
          OEM_COMMA 50
          OEM_3 40
        )

        ;; souce map
        (defsrc
          tab         a z e r t y u i o p
          caps         q s d f g h j k l m OEM_3
          lshift OEM_10 w x c v b n OEM_COMMA OEM_PERIOD OEM_2 rshift ralt rctrl
        )

        (defalias
          esc-ctrl (tap-hold 100 100 esc lctrl)
          base-layerswitch (tap-dance 200 (
            (layer-switch num)
            (layer-switch symbol)
            (layer-switch default)
          ))
          to-base (layer-switch base)
          repeat-ralt (tap-hold 150 100 rpt-any ralt)
        )

        (deflayer base
          tab         a z e r t y u i o p
          @esc-ctrl    q s d f g h j k l m OEM_3
          lshift OEM_10 w x c v b n OEM_COMMA OEM_PERIOD OEM_2 rshift @base-layerswitch caps
        )

        (deflayer num
          tab         1 2 3 4 5 6 7 8 9 0
          @esc-ctrl     S-1 S-2 S-3 S-4 S-5 S-6 S-7 S-8 S-9 S-0 S-OEM_3
          lshift RA-OEM_10 RA-1 RA-2 RA-3 RA-9 b RA-0 S-OEM_COMMA S-OEM_PERIOD S-OEM_2 rshift @to-base caps
        )

        (deflayer symbol
          tab         a S-OEM_2 OEM_COMMA S-OEM_PERIOD S-OEM_PLUS S-OEM_3 OEM_PERIOD OEM_2 S-OEM_COMMA p
          @esc-ctrl    OEM_1 RA-OEM_6 RA-9 5 S-OEM_MINUS OEM_MINUS OEM_4 RA-0 RA-OEM_1 RA-OEM_PLUS OEM_3
          lshift OEM_10 w x c S-OEM_1 b OEM_PLUS OEM_COMMA OEM_PERIOD OEM_2 @to-base @to-base caps
        )

        (deflayer default
          tab         a z e r t y u i o p
          caps         q s d f g h j k l m OEM_3
          lshift OEM_10 w x c v b n OEM_COMMA OEM_PERIOD OEM_2 rshift ralt @to-base
        )
      '';
    };
  };

  environment.packages = [ pkgs.kanata ];
}
