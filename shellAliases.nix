{ pkgs, ... }:

{
  l = "${pkgs.exa}/bin/exa";
  ls = "${pkgs.exa}/bin/exa";
  ll = "${pkgs.exa}/bin/exa -l";
  g = "git";
  t = "tig status";
  e = "nvim";
  ee = "fzf --print0 | xargs -0 nvim";
  download = "${pkgs.aria}/bin/aria2c";
  ".." = "cd ..";
  "..." = "cd ../..";
  "...." = "cd ../../../";
  cat = "bat -p";
}
