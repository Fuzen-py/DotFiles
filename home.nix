{ stdenv, config, pkgs, ... }:

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
        . /home/aizuzu/.nix-profile/etc/profile.d/nix.sh
      '';
    };
    ".config/nvim/autoload/.keep".text = "";
    ".config/nvim/swapfiles/.keep".text = "";
    ".config/nvim/undofiles/.keep".text = "";
    ".config/nvim/Ultisnips/.keep".text = "";
  };

  home.packages = with pkgs; [
    (import ./rename-padded-numbers.nix { inherit pkgs; })
    tokei
    nixfmt
    niv
    tig
    restic
    zstd
    rclone
    carnix
    man-pages
    less
    ffmpeg
    youtube-dl
    tealdeer
    procs
    rustup
  ];

  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
    DOTNET_ROOT = "${pkgs.dotnet-sdk}";
  };

  home.sessionPath = [ "~/.local/bin" "${pkgs.dotnet-sdk}/bin" ];

  programs = {
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

      };
    };
    bat = {
      enable = true;
      config = { theme = "TwoDark"; };
    };

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
    command-not-found.enable = true;
    htop.enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
    mpv = {
      enable = false;
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
      plugins = [{
        name = "replay.fish";
        src = pkgs.fetchFromGitHub {
          owner = "orgebucaran/";
          repo = "replay.fish";
          rev = "07f2bcea94391946cab747199dd5597366532dda";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }];
    };
    ssh = {
      enable = true;
      matchBlocks = { };
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
        keyserver hkps://keys.openpgp.org
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
  };

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
