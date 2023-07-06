{ config, pkgs, lib, ... }:

{
  imports = [ ./graphical-base.nix ];

  environment = {
    variables = {
      XDG_CURRENT_DESKTOP = "kde";
    };

    systemPackages = with pkgs; with libsForQt5; [
      breeze-qt5
      breeze-gtk
      breeze-icons
      breeze-plymouth
      discover
      kate
    ];
  };

  services = {
    xserver = {
      enable = true;

      desktopManager.plasma5 = {
        enable = true;
      };

      displayManager = {
        defaultSession = "plasmawayland";
        sddm = {
          # https://github.com/NixOS/nixpkgs/issues/152726
          # sddm 0.19.0 contains a bug with Wayland session
          enable = false;
          settings = {
            Theme = {
              CursorTheme = "breeze";
            };
          };
        };
        lightdm.enable = true;
        autoLogin = {
          enable = true;
          user = "radxa";
        };
      };
    };
  };
}
