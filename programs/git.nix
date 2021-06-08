{ lib, config, pkgs, ... }: {
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Fuzen";
    userEmail = "me@fuzen.cafe";
    delta.enable = true;
    lfs = {
      enable = true;

    };
    ignores = [ "*~" "*.swp" ".DS_Store" ];
    extraConfig = {
      init.defaultBranch = "main";
      core = { whitespace = "trailing-space,space-before-tab"; };

    };
    signing = {
      key = "${config.programs.git.userEmail}";
      signByDefault = false;
    };
  };
}
