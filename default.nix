# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> {}, ... }:
let
  callPackage = pkgs.callPackage;
  stdenv = pkgs.stdenv;

  supergfxctl_pkg = pkgs.callPackage ./pkgs/supergfxctl { };
  asusctl_pkg = pkgs.callPackage ./pkgs/asusctl { };
  gnome_text_editor_pkg = pkgs.callPackage ./pkgs/gnome-text-editor { };

in rec {
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules

  supergfxctl = supergfxctl_pkg;
  asusctl = asusctl_pkg;
  gnome-texxt-editor = gnome_text_editor_pkg;
}

