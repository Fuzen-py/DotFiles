{ pkgs, lib, ... }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "slower";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "Fuzen-py";
    repo = "slower";
    rev = "v${version}";
    sha256 = "1qpci69xijkhihcirgwqc8bkjz66wijvydvm9s4k2r73fflr01w1";
  };

  cargoSha256 = "04mbjikjwq2w6l2yx60y50ppdnw3l6y9bawik2hy6bq68ajnzvsv";

  meta = with lib; {
      description = "Rate limit stdout";
      longDescription = "Rate limit stdout output to make logs readable";
      homepage = "https://github.com/fuzen-py/slower";
      license = licenses.mit;
      maintainers = with maintainers; [ fuzen ];
  };
}
