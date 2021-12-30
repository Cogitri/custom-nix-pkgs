{lib
, stdenv
, meson
, fetchurl
, python3
, pkg-config
, gtk4
, glib
, gtksourceview5
, gsettings-desktop-schemas
, wrapGAppsHook
, ninja
, gnome
, enchant
, icu
, itstool
, libadwaita
, libxml2
, pcre
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "gnome-text-editor";
  version = "41.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-text-editor/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-YZ7FINbgkF1DEWcCTkPc4Nv2o0Xy1IaTUB1w3HYm+GE=";
  };

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    gnome.adwaita-icon-theme
    enchant
    icu
    glib
    gsettings-desktop-schemas
    gtk4
    gtksourceview5
    libadwaita
    libxml2 # for xmllint
    pcre
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-text-editor";
      attrPath = "gnome.gnome-text-editor";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-text-editor";
    description = "A Text Editor for GNOME";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
