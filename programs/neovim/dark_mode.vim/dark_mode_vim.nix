{ pkgs, lib, ... }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "dark-mode-vim";
  version = "0.1.0";

  src = ./.;

  cargoSha256 = "1vks2p7i9sx0vv7q51hsad0k4fg3nrzfq0zzqfr4qyipkgdpsi88";

  meta = with lib; {
    description = "System theme & time aware dark mode";
    longDescription = "System theme & time aware dark mode";
    homepage = "https://github.com/fuzen-py/slower";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ fuzen ];
  };
}
