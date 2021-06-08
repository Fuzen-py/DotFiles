{ config, pkgs, ... }: {
  xsession.windowManager.i3 = {
    enable = false;
    package = pkgs.i3-gaps;
    config = {

    };
  };
}
