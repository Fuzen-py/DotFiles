{ pkgs, lib, ... }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "dark-mode-vim";
  version = "0.1.0";

  src = ./.;

  cargoSha256 = "1wkzhgvdpvpc6yp5jisf7b874b19yyr4rp703a9dnmispakfyzyc";

  meta = with lib; {
    description = "System theme & time aware dark mode";
    longDescription = "System theme & time aware dark mode";
    homepage = "https://github.com/fuzen-py/slower";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ fuzen ];
  };
}
