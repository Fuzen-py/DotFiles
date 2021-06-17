{ pkgs, ... }:

{
  l = "${pkgs.exa}/bin/exa";
  ls = "${pkgs.exa}/bin/exa";
  ll = "${pkgs.exa}/bin/exa -l";
  g = "${pkgs.git}/bin/git";
  t = "tig status";
  e = "$EDITOR";
  ee = "fzf --print0 | xargs -0 nvim";
  download = "${pkgs.aria}/bin/aria2c";
  ".." = "cd ..";
  "..." = "cd ../..";
  "...." = "cd ../../../";
  cat = "bat -p";
  "nixfmt-all" =
    ''find . -type f -name '*.nix' -exec ${pkgs.nixfmt}/bin/nixfmt "{}" \;'';
  cp = "${pkgs.coreutils-full}/bin/cp --reflink=auto";
}
