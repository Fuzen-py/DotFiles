{ lib, config, pkgs, ... }: {
  imports = [
    ./firefox.nix
    ./chromium.nix
    ./aria2.nix
    ./git.nix
    ./tmux.nix
    ./neovim/config.nix
    ./ssh.nix
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
    gh.enable = true;
    jq.enable = true;
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
}
