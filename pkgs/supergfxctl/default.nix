{ lib, rustPlatform, fetchFromGitLab, pkg-config, udev, kmod }:

rustPlatform.buildRustPackage rec {
  pname = "supergfxctl";
  version = "2.0.4";

  src = fetchFromGitLab {
    owner = "asus-linux";
    repo = pname;
    rev = version;
    sha256 = "1rnpfaxbsa88lm10fl81pm1rrp7hshfzylb3apw81bs9nms37h56";
  };

  patches = [
    ./no-config-write.patch
  ];

  postPatch = ''
    substituteInPlace data/supergfxd.service \
      --replace /usr/bin $out/bin

    substituteInPlace src/controller.rs \
      --replace \"modprobe\" \"${kmod}/bin/modprobe\" \
      --replace \"rmmod\" \"${kmod}/bin/rmmod\"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  cargoHash = "sha256-JEOLcYDx/uCW9oY8BmuLlxogDAMS3FcKnCwWB6DrCxA=";

  makeFlags = [ "prefix=${placeholder "out"}" ];
  # Use default phases since the build scripts install systemd services and udev rules too
  buildPhase = "buildPhase";
  installPhase = "installPhase";

  meta = with lib; {
    description = "Graphics switching tool";
    homepage = "https://gitlab.com/asus-linux/supergfxctl";
    license = licenses.mpl20;
    maintainers = [ maintainers.Cogitri ];
  };
}
