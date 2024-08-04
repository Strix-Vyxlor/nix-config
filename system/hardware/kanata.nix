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
        )

        (deflayer base
          tab       a z e r t y u i o p
          @esc-ctrl  q s d f g h j k l m
          lsft OEM_10 w x c v b n OEM_COMMA OEM_PERIOD OEM_2 OEM_PLUS rsft
          lctrl _                                                @num caps
        )

        (deflayer number
          tab       a z e r t y u S-7 S-8 S-9
          @esc-ctrl  q s d f g h S-4 S-5 S-6 S-0
          lsft OEM_10 w x c v b n S-1 S-2 S-3 OEM_PLUS rsft
          lctrl @base                             ralt caps
        )

        (deflayer default
          tab       a z e r t y u i o p
          caps       q s d f g h j k l m
          lsft OEM_10 w x c v b n OEM_COMMA OEM_PERIOD OEM_2 OEM_PLUS rsft
          lctrl lalt                                             ralt @base
        )
      '';
    };
  };

  environment.systemPackages = [ pkgs.kanata ];
}
