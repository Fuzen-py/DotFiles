{ config, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    extraPackages = with pkgs; [ rustfmt clippy rustc cargo rust-analyzer gcc nodejs ];
    plugins = with pkgs.vimPlugins; [
      coc-json
      coc-rust-analyzer
      {
        plugin = coc-nvim;
        config = "let g:coc_node_path=\"${pkgs.nodejs}/bin/node\"";
      }
      {
        plugin = vim-airline;
        config = ''
          let g:airline_symbols={}
          let g:airline_detect_modified=1
          let g:airline_detect_paste=1
          let g:airline_detect_spell=1
          let g:airline_detect_spelllang=1
          let g:airline_detect_crypt=1
          let g:airline#extensions#tabline#enabled = 1
          let g:airline_powerline_fonts = 1
          let g:airline_symbols.crypt = '🔒'
          let g:airline_symbols.linenr = '☰'
          let g:airline_symbols.linenr = '¶'
          let g:airline_symbols.maxlinenr = '㏑'
          let g:airline_symbols.paste = 'ρ'
          let g:airline_symbols.spell = 'Ꞩ'
          let g:airline_symbols.whitespace = 'Ξ'
        '';
      }
      vim-nix
      nerdtree
      syntastic
      rust-vim
      webapi-vim
      vim-repeat
      vim-surround
      vim-tmux
      {
        plugin = ale;
        config = ''
          let g:ale_fix_on_save = 1
          let g:ale_rust_cargo_use_clippy = executable("${pkgs.clippy}/bin/cargo-clippy")
          let g:ale_rust_analyzer_executable = "${pkgs.rust-analyzer}/bin/rust-analyzer"
          let g:ale_linters = { 'rust': ['cargo', 'analyzer'] }
        '';
      }
      indentLine
      vim-fugitive
      vim-unimpaired
      {
        plugin = fastfold;
        config = ''
          let g:fastfold_fold_command_suffixes = ['x','X','a','A','o','O','c','C','r','R','m','M','i','n','N']
        '';
      }
      vim-commentary
      papercolor-theme
      vim-polyglot
      {
        plugin = vim-startify;
        config = "let g:startify_change_to_vcs_root = 0";
      }
      {
        plugin = gruvbox;
        config = ''
          let g:gruvbox_contrast_dark='hard'
          let g:gruvbox_contrast_light=g:gruvbox_contrast_dark
          let g:gruvbox_italic=1
          let g:gruvbox_bold=1
          let g:gruvbox_underline=1
        '';
      }

    ];
    extraPython3Packages = (ps: with ps; [ pylint autopep8 pandas jedi ]);
    extraConfig = ''
      scriptencoding utf-8
      colorscheme gruvbox
      let $RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}"

    '' + (builtins.readFile ./general_settings.vim)
      + (builtins.readFile ./custom_commands.vim);
  };
}
