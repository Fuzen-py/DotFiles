{ config, pkgs, ... }: {
  programs.chromium = {
    enable = true;
    extensions = [

      {
        id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; # Ublock Origin
      }

      {
        id = "bkdgflcldnnnapblkhphbgpggdiikppg"; # DuckDuckGo Privacy Essentials
      }

      {
        id = "gcbommkclmclpchllfjekcdonpmejbdp"; # HTTPS Everywhere
      }

      {
        id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; # 1Password
      }

      {
        id = "nkbihfbeogaeaoehlefnkodbefgpgknn"; # MetaMask
      }

    ];
  };
}
