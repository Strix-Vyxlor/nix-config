{ pkgs, config, ... }:
{

  programs.wofi = {
    enable = true;
    settings = {
      location = "top";
      show = "drun";
      width = 600;
      height = 400;
      term = "blackbox";
      prompt = "";
      columns = 1;
      allow-images = true;  
    };
    style = ''
      @define-color	mauve  #${config.lib.stylix.colors.base0E};
      @define-color	red  #${config.lib.stylix.colors.base08};
      @define-color	peach  #${config.lib.stylix.colors.base0D};
      @define-color	lavender  #${config.lib.stylix.colors.base07};
      @define-color	text  #${config.lib.stylix.colors.base05};
      @define-color	base  #${config.lib.stylix.colors.base00};

      * {
        font-family: 'Inter';
        font-size: 14px;
      }

      /* Window */
      window {
        margin: 0px;
        padding: 10px;
        border: 0.16em solid @lavender;
        border-radius: 1em;
        background-color: @base;
        animation: slideIn 0.5s ease-in-out both;
      }

      /* Slide In */
      @keyframes slideIn {
        0% {
           opacity: 0;
        }

        100% {
           opacity: 1;
        }
      }

      /* Inner Box */
      #inner-box {
        margin: 5px;
        padding: 10px;
        border: none;
        background-color: @base;
        animation: fadeIn 0.5s ease-in-out both;
      }

      /* Fade In */
      @keyframes fadeIn {
        0% {
           opacity: 0;
        }

        100% {
           opacity: 1;
        }
      }

      /* Outer Box */
      #outer-box {
        margin: 5px;
        padding: 10px;
        border: none;
        background-color: @base;
      }

      /* Scroll */
      #scroll {
        margin: 0px;
        padding: 10px;
        border: none;
        background-color: @base;
      }

      /* Input */
      #input {
        margin: 5px 20px;
        padding: 10px;
        border: none;
        border-radius: 0.5em;
        color: @text;
        background-color: @base;
        animation: fadeIn 0.5s ease-in-out both;
      }

      #input image {
          border: none;
          color: @red;
      }

      #input * {
        outline: 4px solid @red!important;
      }

      /* Text */
      #text {
        margin: 5px;
        border: none;
        color: @text;
        animation: fadeIn 0.5s ease-in-out both;
      }

      #entry {
        background-color: @base;
      }

      #entry arrow {
        border: none;
        color: @lavender;
      }

      /* Selected Entry */
      #entry:selected {
        border: 0.11em solid @lavender;
      }

      #entry:selected #text {
        color: @mauve;
      }

      #entry:drop(active) {
        background-color: @lavender!important;
      }
      '';
  };

  home.packages = [ pkgs.wofi ];
}
