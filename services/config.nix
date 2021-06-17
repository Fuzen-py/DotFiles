{ config, pkgs, ... }: {
  imports = [ ./gpg-agent.nix ];
  services = {
    keybase = { enable = true; };
    kbfs = { enable = true; };
    syncthing = {
      enable = true;
      # tray = { enable = true; };
    };
  };
}
