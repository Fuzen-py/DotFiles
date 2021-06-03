{ lib, config, pkgs, ... }:
let
  inherit (pkgs) stdenv;
in

rec {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "aizuzu";
  home.homeDirectory = "/home/aizuzu";
  # Unfree packages wanted
  nixpkgs.config.allowUnfree = true;

  home.file = {
    # Set unfree here too
    ".config/nixpkgs/config.nix" = {
      text = ''
        {allowUnfree = true; }
      '';
    };
    ".profile" = {
      text = ''
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      '';
    };
    ".config/nvim/autoload/.keep".text = "";
    ".config/nvim/swapfiles/.keep".text = "";
    ".config/nvim/undofiles/.keep".text = "";
    ".config/nvim/Ultisnips/.keep".text = "";

  };

  manual = {
    html.enable = true;
    json.enable = true;
    manpages.enable = true;
  };

  home.packages = with pkgs; [
    (import ./rename-padded-numbers.nix { inherit pkgs; })
    nerdfonts
    tokei
    nixfmt
    niv
    tig
    restic
    zstd
    mosh
    rclone
    carnix
    man-pages
    less
    ffmpeg
    youtube-dl
    tealdeer
    procs
    #rustup
    rustc
    rust-analyzer
    cargo
    rustfmt
    # rust
    peco
    kopia
    clang
    (import ./slower.nix  { inherit pkgs; inherit lib; })
  ];

  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
    DOTNET_ROOT = "${pkgs.dotnet-sdk}";
    DOTNET_CLI_TELEMETRY_OPTOUT = 1;
    DOTNET_SKIP_FIRST_TIME_EXPERIENCE = 1;
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  };

  home.sessionVariablesExtra = ''
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  '';

  home.sessionPath = [ "~/.local/bin" "${pkgs.dotnet-sdk}/bin" ];

  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscode;

    };
    firefox = {
      enable = true;
      package = pkgs.firefox.override {
        cfg = {
          enableUgetIntegrator = true;
          pipewireSupport = true;
          ffmpegSupport = true;
          enablePlasmaBrowserIntegration = true;
          enableGnomeExtensions = true;
        };
      };
      profiles = {
        homeNix = {
          isDefault = true;
          id = 0;
          settings = {
            "browser.startup.homepage" = "https://duckduckgo.com";
            "browser.search.region" = "US";
            "browser.search.isUS" = true;
            "distribution.searchplugins.defaultLocale" = "en-US";
            "general.useragent.locale" =
              "${"distribution.searchplugins.defaultLocale"}";
            "browser.bookmarks.showMobileBookmarks" = true;
          };
        };
      };
    };
    chromium = {
      enable = true;
      extensions = [

        {
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; # Ublock Origin
        }

        {
          id =
            "bkdgflcldnnnapblkhphbgpggdiikppg"; # DuckDuckGo Privacy Essentials
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
    gpg.enable = true;
    aria2 = {
      enable = true;
      settings = {
        file-allocation = "none";
        log-level = "warn";
        max-connection-per-server = 16;
        min-split-size = "1M";
        human-readable = true;
        reuse-uri = true;
        rpc-save-upload-metadata = true;
        max-file-not-found = 0;
        remote-time = true;
        async-dns = true;
        stop = 0;
        allow-piece-length-change = true;
        parameterized-url = true;
        # Default is 5:25
        # Leading to 5 on 1mbs nets
        # And 50 on 100mbps
        optimize-current-downloads = true;
        max-concurrent-downloads = 100;
        deferred-input = true;
        continue = true;
        check-integrity = true;
        realtime-chunk-checksum = true;
        piece-length = "1M";
        split = 16;
        # Seconds:
        save-session-interval = 60;
        # Caches in memory
        disk-cache = "32M";
        save-not-found = true;
        download-result = "full";
        truncate-console-readout = true;
        # stream-piece-selector = "random";
        retry-wait = 30;
        max-tries = 15;
        enable-color = true;
        enable-http-keep-alive = true;
        enable-http-pipelining = true;
        http-accept-gzip = true;
        follow-torrent = true;
        bt-save-metadata = true;
        bt-detach-seed-only = true;
        seed-time = 0;
        bt-load-saved-metadata = true;
        metalink-preferred-protocol = "https";
      };
    };
    git = {
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
    tmux = {
      enable = true;
      shortcut = "a";
      aggressiveResize = true;
      baseIndex = 1;
      newSession = true;
      escapeTime = 0;
      secureSocket = false;
      clock24 = true;
      terminal = "screen-256color";
      historyLimit = 50000;
      plugins = with pkgs; [
        tmuxPlugins.cpu
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
        {
          plugin = tmuxPlugins.online-status;
          extraConfig = ''
            set -g status-right "Online: #{online_status} | %a %h-%d %H:%M "
            set -g @online_icon "ok"
            set -g @offline_icon "offline!"
            set -g @route_to_ping "1.1.1.1"
          '';
        }
        tmuxPlugins.pain-control
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60' # minutes
          '';
        }
      ];
      extraConfig = ''
        set-option -g mouse on
        bind-key a send-prefix
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
        set -g status-position bottom
        set-option -g set-titles on
        set-optiong -g title-string "Tmux #{online_status} #{session_name} > #{pane_title} | #h"
      '';
    };
    neovim = (import ./nvim.nix { inherit pkgs; });
    fzf = {
      enable = true;
      tmux = {
        enableShellIntegration = true;
        shellIntegrationOptions = [ "-d 40%" ];
      };
    };
    gh.enable = true;
    jq.enable = true;
    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
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
        username.show_always = true;
      };
    };
    command-not-found.enable = false;
    htop.enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
    mpv = {
      enable = true;
      package = with pkgs;
        pkgs.wrapMpv
        (pkgs.mpv-unwrapped.override { vapoursynthSupport = true; }) {
          youtubeSupport = true;
        };

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
    ssh = {
      enable = true;
      matchBlocks = { };
    };
    alacritty = {
      enable = true;
      settings = {
        env = { TERM = "xterm-256color"; };
        window = {
          dimensions = {
            colums = 0;
            lines = 0;
          };
          padding = {
            x = 0;
            y = 0;
          };
          decorations = "full";
        };
        tabspaces = 4;
        draw_bold_text_with_bright_colors = true;
        font = {
          normal = {
            family = "SauceCodePro Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "SauceCodePro Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "SauceCodePro Nerd Font";
            style = "Italic";
          };
          size = "16.0";
          offset = {
            x = 0;
            y = 0;
          };
          glyph_offset = {
            x = 0;
            y = 0;
          };
          use_thin_strokes = true;
        };

        colors = {
          primary = {
            background = "0x282a36";
            foreground = "0xf8f8f2";
          };
          normal = {
            black = "0x272822";
            red = "0xF92672";
            green = "0xA6E22E";
            yellow = "0xF4BF75";
            blue = "0x66D9EF";
            magenta = "0xAE81FF";
            cyan = "0xA1EFE4";
            white = "0xF8F8F2";
          };
          bright = {
            black = "0x75715E";
            red = "0xF92672";
            green = "0xA6E22E";
            yellow = "0xF4BF75";
            blue = "0x66D9EF";
            magenta = "0xAE81FF";
            cyan = "0xA1EFE4";
            white = "0xF9F8F5";
          };

        };
        visual_bell = {
          animation = "EaseOutExpo";
          duration = 0;
        };

        background_opacity = 1.0;

        mouse_bindings = [{
          mouse = "Middle";
          action = "PasteSelection";
        }];

        mouse = {
          double_click = { threshold = 300; };
          tripple_click = { threshold = 300; };
          faux_scrolling_lines = 1;
          hide_when_typing = false;
        };

        cursor = {
          stye = "Block";
          unfocused_hollow = true;
        };

        slection = { semantic_escape_chars = '',│`|:"' ()[]{}<>''; };

        dynamic_title = true;
        live_config_reload = true;

        key_bindings = [
          {
            key = "V";
            mods = "Control|Shift";
            action = "Paste";
          }
          {
            key = "C";
            mods = "Control|Shift";
            action = "Copy";
          }
          {
            key = "Y";
            mods = "Control";
            action = "Paste";
          }
          {
            key = "W";
            mods = "Alt";
            action = "Copy";
          }
          {
            key = "Paste";
            action = "Paste";
          }
          {
            key = "Copy";
            action = "Copy";
          }
          {
            key = "Q";
            mods = "Command";
            action = "Quit";
          }
          {
            key = "W";
            mods = "Command";
            action = "Quit";
          }
          {
            key = "Insert";
            mods = "Shift";
            action = "PasteSelection";
          }
          {
            key = "Key0";
            mods = "Control";
            action = "ResetFontSize";
          }
          {
            key = "Equals";
            mods = "Control";
            action = "IncreaseFontSize";
          }
          {
            key = "Subtract";
            mods = "Control";
            action = "DecreaseFontSize";
          }
          {
            key = "Home";
            chars = "\\x1bOH";
            mode = "AppCursor";
          }
          {
            key = "Home";
            chars = "\\x1b[H";
            mode = "~AppCursor";
          }
          {
            key = "End";
            chars = "\\x1bOF";
            mode = "AppCursor";
          }
          {
            key = "End";
            chars = "\\x1b[F";
            mode = "~AppCursor";
          }
          {
            key = "PageUp";
            mods = "Shift";
            chars = "\\x1b[5;2~";
          }
          {
            key = "PageUp";
            mods = "Control";
            chars = "\\x1b[5;5~";
          }
          {
            key = "PageUp";
            chars = "\\x1b[5~";
          }
          {
            key = "PageDown";
            mods = "Shift";
            chars = "\\x1b[6;2~";
          }
          {
            key = "PageDown";
            mods = "Control";
            chars = "\\x1b[6;5~";
          }
          {
            key = "PageDown";
            chars = "\\x1b[6~";
          }
          {
            key = "Tab";
            mods = "Shift";
            chars = "\\x1b[Z";
          }
          {
            key = "Back";
            chars = "\\x7f";
          }
          {
            key = "Back";
            mods = "Alt";
            chars = "\\x1bx7f";
          }
          {
            key = "Insert";
            chars = "\\x1b[2~";
          }
          {
            key = "Delete";
            chars = "\\x1b[3~";
          }
          {
            key = "Left";
            mods = "Shift";
            chars = "\\x1b[1;2D";
          }
          {
            key = "Left";
            mods = "Control";
            chars = "\\x1b[1;5D";
          }
          {
            key = "Left";
            mods = "Alt";
            chars = "\\x1b[1;3D";
          }
          {
            key = "Left";
            chars = "\\x1b[D";
            mode = "~AppCursor";
          }
          {
            key = "Left";
            chars = "\\x1bOD";
            mode = "AppCursor";
          }
          {
            key = "Right";
            mods = "Shift";
            chars = "\\x1b[1;2C";
          }
          {
            key = "Right";
            mods = "Control";
            chars = "\\x1b[1;5C";
          }
          {
            key = "Right";
            mods = "Alt";
            chars = "\\x1b[1;3C";
          }
          {
            key = "Right";
            chars = "\\x1b[C";
            mode = "~AppCursor";
          }
          {
            key = "Right";
            chars = "\\x1bOC";
            mode = "AppCursor";
          }
          {
            key = "Up";
            mods = "Shift";
            chars = "\\x1b[1;2A";
          }
          {
            key = "Up";
            mods = "Control";
            chars = "\\x1b[1;5A";
          }
          {
            key = "Up";
            mods = "Alt";
            chars = "\\x1b[1;3A";
          }
          {
            key = "Up";
            chars = "\\x1b[A";
            mode = "~AppCursor";
          }
          {
            key = "Up";
            chars = "\\x1bOA";
            mode = "AppCursor";
          }
          {
            key = "Down";
            mods = "Shift";
            chars = "\\x1b[1;2B";
          }
          {
            key = "Down";
            mods = "Control";
            chars = "\\x1b[1;5B";
          }
          {
            key = "Down";
            mods = "Alt";
            chars = "\\x1b[1;3B";
          }
          {
            key = "Down";
            chars = "\\x1b[B";
            mode = "~AppCursor";
          }
          {
            key = "Down";
            chars = "\\x1bOB";
            mode = "AppCursor";
          }
          {
            key = "F1";
            chars = "\\x1bOP";
          }
          {
            key = "F2";
            chars = "\\x1bOQ";
          }
          {
            key = "F3";
            chars = "\\x1bOR";
          }
          {
            key = "F4";
            chars = "\\x1bOS";
          }
          {
            key = "F5";
            chars = "\\x1b[15~";
          }
          {
            key = "F6";
            chars = "\\x1b[17~";
          }
          {
            key = "F7";
            chars = "\\x1b[18~";
          }
          {
            key = "F8";
            chars = "\\x1b[19~";
          }
          {
            key = "F9";
            chars = "\\x1b[20~";
          }
          {
            key = "F10";
            chars = "\\x1b[21~";
          }
          {
            key = "F11";
            chars = "\\x1b[23~";
          }
          {
            key = "F12";
            chars = "\\x1b[24~";
          }
          {
            key = "F1";
            mods = "Shift";
            chars = "\\x1b[1;2P";
          }
          {
            key = "F2";
            mods = "Shift";
            chars = "\\x1b[1;2Q";
          }
          {
            key = "F3";
            mods = "Shift";
            chars = "\\x1b[1;2R";
          }
          {
            key = "F4";
            mods = "Shift";
            chars = "\\x1b[1;2S";
          }
          {
            key = "F5";
            mods = "Shift";
            chars = "\\x1b[15;2~";
          }
          {
            key = "F6";
            mods = "Shift";
            chars = "\\x1b[17;2~";
          }
          {
            key = "F7";
            mods = "Shift";
            chars = "\\x1b[18;2~";
          }
          {
            key = "F8";
            mods = "Shift";
            chars = "\\x1b[19;2~";
          }
          {
            key = "F9";
            mods = "Shift";
            chars = "\\x1b[20;2~";
          }
          {
            key = "F10";
            mods = "Shift";
            chars = "\\x1b[21;2~";
          }
          {
            key = "F11";
            mods = "Shift";
            chars = "\\x1b[23;2~";
          }
          {
            key = "F12";
            mods = "Shift";
            chars = "\\x1b[24;2~";
          }
          {
            key = "F1";
            mods = "Control";
            chars = "\\x1b[1;5P";
          }
          {
            key = "F2";
            mods = "Control";
            chars = "\\x1b[1;5Q";
          }
          {
            key = "F3";
            mods = "Control";
            chars = "\\x1b[1;5R";
          }
          {
            key = "F4";
            mods = "Control";
            chars = "\\x1b[1;5S";
          }
          {
            key = "F5";
            mods = "Control";
            chars = "\\x1b[15;5~";
          }
          {
            key = "F6";
            mods = "Control";
            chars = "\\x1b[17;5~";
          }
          {
            key = "F7";
            mods = "Control";
            chars = "\\x1b[18;5~";
          }
          {
            key = "F8";
            mods = "Control";
            chars = "\\x1b[19;5~";
          }
          {
            key = "F9";
            mods = "Control";
            chars = "\\x1b[20;5~";
          }
          {
            key = "F10";
            mods = "Control";
            chars = "\\x1b[21;5~";
          }
          {
            key = "F11";
            mods = "Control";
            chars = "\\x1b[23;5~";
          }
          {
            key = "F12";
            mods = "Control";
            chars = "\\x1b[24;5~";
          }
          {
            key = "F1";
            mods = "Alt";
            chars = "\\x1b[1;6P";
          }
          {
            key = "F2";
            mods = "Alt";
            chars = "\\x1b[1;6Q";
          }
          {
            key = "F3";
            mods = "Alt";
            chars = "\\x1b[1;6R";
          }
          {
            key = "F4";
            mods = "Alt";
            chars = "\\x1b[1;6S";
          }
          {
            key = "F5";
            mods = "Alt";
            chars = "\\x1b[15;6~";
          }
          {
            key = "F6";
            mods = "Alt";
            chars = "\\x1b[17;6~";
          }
          {
            key = "F7";
            mods = "Alt";
            chars = "\\x1b[18;6~";
          }
          {
            key = "F8";
            mods = "Alt";
            chars = "\\x1b[19;6~";
          }
          {
            key = "F9";
            mods = "Alt";
            chars = "\\x1b[20;6~";
          }
          {
            key = "F10";
            mods = "Alt";
            chars = "\\x1b[21;6~";
          }
          {
            key = "F11";
            mods = "Alt";
            chars = "\\x1b[23;6~";
          }
          {
            key = "F12";
            mods = "Alt";
            chars = "\\x1b[24;6~";
          }
          {
            key = "F1";
            mods = "Super";
            chars = "\\x1b[1;3P";
          }
          {
            key = "F2";
            mods = "Super";
            chars = "\\x1b[1;3Q";
          }
          {
            key = "F3";
            mods = "Super";
            chars = "\\x1b[1;3R";
          }
          {
            key = "F4";
            mods = "Super";
            chars = "\\x1b[1;3S";
          }
          {
            key = "F5";
            mods = "Super";
            chars = "\\x1b[15;3~";
          }
          {
            key = "F6";
            mods = "Super";
            chars = "\\x1b[17;3~";
          }
          {
            key = "F7";
            mods = "Super";
            chars = "\\x1b[18;3~";
          }
          {
            key = "F8";
            mods = "Super";
            chars = "\\x1b[19;3~";
          }
          {
            key = "F9";
            mods = "Super";
            chars = "\\x1b[20;3~";
          }
          {
            key = "F10";
            mods = "Super";
            chars = "\\x1b[21;3~";
          }
          {
            key = "F11";
            mods = "Super";
            chars = "\\x1b[23;3~";
          }
          {
            key = "F12";
            mods = "Super";
            chars = "\\x1b[24;3~";
          }
        ];

      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableScDaemon = true;
      enableSshSupport = true;
      defaultCacheTtl = 60;
      maxCacheTtl = 60;
      extraConfig = ''
        # https://github.com/drduh/config/blob/master/gpg.conf
        # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html
        # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Esoteric-Options.html
        # Use AES256, 192, or 128 as cipher
        personal-cipher-preferences AES256 AES192 AES
        # Use SHA512, 384, or 256 as digest
        personal-digest-preferences SHA512 SHA384 SHA256
        # Use ZLIB, BZIP2, ZIP, or no compression
        personal-compress-preferences ZLIB BZIP2 ZIP Uncompressed
        # Default preferences for new keys
        default-preference-list SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed
        # SHA512 as digest to sign keys
        cert-digest-algo SHA512
        # SHA512 as digest for symmetric ops
        s2k-digest-algo SHA512
        # AES256 as cipher for symmetric ops
        s2k-cipher-algo AES256
        # UTF-8 support for compatibility
        charset utf-8
        # Show Unix timestamps
        fixed-list-mode
        # No comments in signature
        no-comments
        # No version in signature
        no-emit-version
        # Disable banner
        no-greeting
        # Long hexidecimal key format
        keyid-format 0xlong
        # Display UID validity
        list-options show-uid-validity
        verify-options show-uid-validity
        # Display all keys and their fingerprints
        with-fingerprint
        # Display key origins and updates
        #with-key-origin
        # Cross-certify subkeys are present and valid
        require-cross-certification
        # Disable caching of passphrase for symmetrical ops
        no-symkey-cache
        # Disable recipient key ID in messages
        throw-keyids
        # Default/trusted key ID to use (helpful with throw-keyids)
        #default-key 0xFF3E7D88647EBCDB
        #trusted-key 0xFF3E7D88647EBCDB
        # Group recipient keys (preferred ID last)
        #group keygroup = 0xFF00000000000001 0xFF00000000000002 0xFF3E7D88647EBCDB
        # Keyserver URL
        keyserver hkps://pgp.mit.edu
        #keyserver hkps://keys.openpgp.org
        #keyserver hkps://keyserver.ubuntu.com:443
        #keyserver hkps://hkps.pool.sks-keyservers.net
        #keyserver hkps://pgp.ocf.berkeley.edu
        # Proxy to use for keyservers
        #keyserver-options http-proxy=socks5-hostname://127.0.0.1:9050
        # Verbose output
        #verbose
        # Show expired subkeys
        #list-options show-unusable-subkeys
        write-env-file
        use-standard-socket
      '';
    };
    keybase = { enable = true; };
    kbfs = { enable = true; };
    syncthing = {
      enable = true;
      tray = { enable = true; };
    };
  };

  fonts.fontconfig.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
