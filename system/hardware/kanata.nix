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
          tab       a z e r t y u i o p
          caps       q s d f g h j k l m
          lsft OEM_10 w x c v b n OEM_COMMA OEM_PERIOD OEM_2 OEM_PLUS rsft
          lctrl lalt                                             ralt rctrl
        )

        (defalias
          esc-ctrl (tap-hold 100 100 esc lctrl)

          home (layer-switch base)
          num (layer-switch number)
          sym (layer-switch symbol)
          nav (layer-switch navigation)
          def (layer-switch default)
        )

        (deflayer base
          tab       a z e r t y u i o p
          @esc-ctrl  q s d f g h j k l m
          lsft OEM_10 w x c v b n OEM_COMMA OEM_PERIOD OEM_2 OEM_PLUS rsft
          lctrl @sym                                              @num caps
        )

        (deflayer number
          tab       a z S-OEM_2 S-OEM_1 t y S-7 S-8 S-9 p
          @esc-ctrl  q s OEM_MINUS S-OEM_PLUS g h S-4 S-5 S-6 S-0
          lsft OEM_10 w x c v b n S-1 S-2 S-3 OEM_PLUS rsft
          lctrl @home                             @nav caps
        )

        (deflayer symbol
          tab       OEM_10 RA-OEM_6 RA-4 5 RA-3 RA-OEM_PLUS OEM_4 RA-0 RA-OEM_1 S-OEM_10
          @esc-ctrl S-OEM_PLUS S-OEM_MINUS OEM_PERIOD OEM_COMMA RA-OEM_10 S-OEM_2 S-OEM_PERIOD OEM_2 OEM_MINUS OEM_PLUS
          lsft RA-1 2 7 1 4 9 3 8 S-OEM_1 RA-2 OEM_1 rsft
          lctrl @home                             @def rctrl
        )

        (deflayer navigation
          tab       a z e volu bru y pgup i o p
          @esc-ctrl  q prev pp next brdn lft down up rght m
          lsft OEM_10 w x vold v b pgdn OEM_COMMA OEM_PERIOD OEM_2 OEM_PLUS rsft
          lctrl @home                                               _ caps
        )

        (deflayer default
          tab       a z e r t y u i o p
          caps       q s d f g h j k l m
          lsft OEM_10 w x c v b n OEM_COMMA OEM_PERIOD OEM_2 OEM_PLUS rsft
          lctrl lalt                                             ralt @home
        )
      '';
    };
  };

  environment.systemPackages = [ pkgs.kanata ];
}
