{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface

  options = {
    services.supergfxctl = {
      enable = mkOption {
        description = ''
          Enable this option to enable control of GPU modes with supergfxctl.

          This permits you to switch between integrated, hybrid and dedicated
          graphics modes on supported laptops.
        '';
        type = types.bool;
        default = false;
      };
    };
  };

  ###### implementation

  config = mkIf config.services.supergfxctl.enable {
    environment.systemPackages = with pkgs; [ supergfxctl ];
    services.dbus.packages = with pkgs; [ supergfxctl ];
    services.udev.packages = with pkgs; [ supergfxctl ];
    systemd.packages = with pkgs; [ supergfxctl ];
  };
}
