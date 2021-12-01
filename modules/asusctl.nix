{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface

  options = {
    services.asusctl = {
      enable = mkOption {
        description = ''
          Enable this option to enable control of Asus laptop specifics with asusctl.

          This permits you to control the lighting, fan curve, GPU mode and more on
          supported Asus laptops.
        '';
        type = types.bool;
        default = false;
      };
    };
  };

  ###### implementation

  config = mkIf config.services.asusctl.enable {
    services.supergfxctl.enable = true;
    environment.systemPackages = with pkgs; [ asusctl ];
    services.dbus.packages = with pkgs; [ asusctl ];
    services.udev.packages = with pkgs; [ asusctl ];
    systemd.packages = with pkgs; [ asusctl ];
  };
}
