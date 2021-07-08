{ lib, config, pkgs, ... }: {
  imports = [
    ./firefox.nix
    ./chromium.nix
    ./aria2.nix
    ./git.nix
    ./tmux.nix
    ./neovim/config.nix
    ./ssh.nix
    ./alacritty.nix
  ];
  programs = {
    vscode = {
      enable = config.xsession.enable;
      package = pkgs.vscode;
    };
    gpg.enable = true;
    bat = {
      enable = true;
      config = { theme = "gruvbox-dark"; };
    };
    nix-index = { enable = true; };
    irssi = {
      enable = true;
      aliases = {
        BYE = "quit";
        J = "join";
      };
    };
    fzf = {
      enable = true;
      tmux = {
        enableShellIntegration = true;
        shellIntegrationOptions = [ "-d 40%" ];
      };
    };
    gh = { enable = true; };
    jq = { enable = true; };
    direnv = {
      enable = true;
      nix-direnv = { enable = true; };
    };
    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      settings = {
        add_newline = false;
        battery = {
          full_symbol = "🔋";
          charging_symbol = "⚡️";
          discharging_symbol = "💀";
          display = [
            {
              threshold = 10;
              style = "bold red";
            }
            {
              threshold = 30;
              style = "bold yellow";
            }
          ];
        };
        username = { show_always = true; };
      };
    };
    command-not-found = { enable = false; };
    htop = { enable = true; };
    man = {
      enable = true;
      generateCaches = true;
    };
    mpv = {
      # TODO: Check for audio / video
      enable = true;
      package = with pkgs;
        pkgs.wrapMpv (pkgs.mpv-unwrapped.override {
          vapoursynthSupport = system != "aarch64-linux";
        }) { youtubeSupport = true; };

      config = {
        profile = "gpu-hq";
        ytdl-format = "bestvideo+bestaudio";
        cache-default = 4000000;
      };
    };
    go = {
      enable = true;
      goBin = ".local/bin.go";
      goPath = ".local/go";
    };
    dircolors = {
      enable = true;
      settings = { ".sh" = "01;32"; };
    };
    exa = {
      enable = true;
      enableAliases = true;

    };
    bash = {
      enable = true;
      enableVteIntegration = true;
      historyControl = [ "ignorespace" ];
      historyIgnore = [ "#" "ls" "cd" "exit" ];
      shellOptions = [ "histappend" "checkwinsize" "checkjobs" ];
      bashrcExtra = ''
        export PATH="$PATH:$HOME/.dotnet/tools"
      '';
      shellAliases = (import ./shellAliases.nix { inherit pkgs; }) // { };
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableVteIntegration = true;
      autocd = true;
      history = {
        expireDuplicatesFirst = true;
        extended = true;
        ignoreSpace = true;
        share = true;
      };
      shellAliases = (import ./shellAliases.nix { inherit pkgs; }) // {

      };
    };
    fish = {
      enable = true;
      shellAliases = (import ./shellAliases.nix { inherit pkgs; }) // { };
      plugins = [
        {
          name = "replay.fish";
          src = pkgs.fetchFromGitHub {
            owner = "orgebucaran/";
            repo = "replay.fish";
            rev = "07f2bcea94391946cab747199dd5597366532dda";
            sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
          };
        }
        {
          name = "rustup";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-rustup";
            rev = "81a58a1c433e6aa89d66211c07e7652407fde1ad";
            sha256 = "mu3lSppyOULU96lRyKlWq84yksAPEi4W/mxUlEpye5c=";
          };
        }
        {
          name = "expand";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-expand";
            rev = "ffb18d57506c7332ae8b7b8bc8d7f56e3a2390d2";
            sha256 = "mEgoKxoe7/88p0/5vcX27VM83wp4Cii5C3sTjwnoLJ8=";
          };
        }
        {
          name = "foriegn-env";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-foreign-env";
            rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
            sha256 = "er1KI2xSUtTlQd9jZl1AjqeArrfBxrgBLcw5OqinuAM=";
          };
        }
        {
          name = "bang-bang";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-bang-bang";
            rev = "f969c618301163273d0a03d002614d9a81952c1e";
            sha256 = "A8ydBX4LORk+nutjHurqNNWFmW6LIiBPQcxS3x4nbeQ=";
          };
        }
        {
          name = "grc";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-grc";
            rev = "a5472aca6f26ca793ee76d7451dae553875a1f1d";
            sha256 = "w8/ByVdgkXVax2Du6TGvf/VnIu0Min2zQbMaQmsZwSQ=";
          };
        }
      ];
    };
  };
}
