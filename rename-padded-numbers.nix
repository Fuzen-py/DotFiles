{ pkgs, ... }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "rename-padded-numbers";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "Fuzen-py";
    repo = "rename_padded_numbers";
    rev = "836a178bd1d0e0ea4724662c701d951f94ba3446";
    sha256 = "de82lG5P+C0FLGKyzf/MUre8XnwQ4w44syzIZhCpqsc=";
  };

  cargoSha256 = "O39GNhiH12L76iQE8vqdnr2teW3SvaqwILw3sDkYcZ0=";

  meta = {
    description =
      "A batch file renamer padding the first number with 0s for all files in CWD";
    homepage = "https://github.com/Fuzen-py/rename_padded_numbers";
  };
}
