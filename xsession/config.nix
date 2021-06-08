{ config, pkgs, ... }: {
  imports = [ ./i3.nix ];
  xsession = {
    enable = false;
    numlock.enable = false;
  };
}
