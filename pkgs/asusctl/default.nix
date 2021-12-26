{ lib, rustPlatform, fetchFromGitLab, pkg-config, udev, coreutils, systemd }:

rustPlatform.buildRustPackage rec {
  pname = "asusctl";
  version = "4.0.7";

  src = fetchFromGitLab {
    owner = "asus-linux";
    repo = pname;
    rev = version;
    sha256 = "13x1g6n5qrwblcyzjzsshvar2h7himryhzg6hnjx7jrkq7wlw1m4";
  };

  patches = [
    ./configdir.patch
    ./statedir.patch
  ];

  postPatch = ''
    substituteInPlace daemon/src/laptops.rs \
      --replace /etc $out/etc

    for file in daemon/src/*.rs daemon/src/**/*.rs; do
      substituteInPlace $file \
        --replace \"/etc \"/var/lib \
        --replace /usr $out
    done

    for file in data/*.service; do
      substituteInPlace $file \
        --replace /usr/bin/sleep ${coreutils}/bin/sleep \
        --replace /bin/sleep ${coreutils}/bin/sleep \
        --replace /bin/mkdir ${coreutils}/bin/mkdir \
        --replace /usr/bin $out/bin
    done

    substituteInPlace data/asusd.rules \
      --replace systemctl ${systemd}/bin/systemctl

    echo "After=supergfxd.service\nRequires=supergfx.d.service" \
        >> data/asusd.service
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  cargoHash = "sha256-OHg6W4qc3cxMygWfW3OzS3x9aGYocakDxBDZONHV1PI=";

  # Use default phases since the build scripts install systemd services, udev rules, ... too
  makeFlags = [ "prefix=${placeholder "out"}" "configdir=${placeholder "out"}/etc" ];
  buildPhase = "buildPhase";
  installPhase = "installPhase";

  # Need to run on an actual Asus laptop
  doCheck = false;

  meta = with lib; {
    description = "A utility for Linux to control many aspects of various ASUS laptops";
    homepage = "https://gitlab.com/asus-linux/asusctl";
    license = licenses.mpl20;
    maintainers = [ maintainers.Cogitri ];
  };
}
