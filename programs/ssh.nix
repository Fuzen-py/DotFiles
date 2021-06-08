{ lib, config, pkgs, ... }: {
  programs.ssh = {
    enable = true;
    compression = false;
    matchBlocks = { "*" = { identityFile = [ "~/.ssh/fuzen_ed25519" ]; }; };
  };
}
