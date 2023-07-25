{ config, pkgs, lib, ... }:

{
  imports = [ ./graphical-base.nix ];

  environment = {
    variables = {
      XDG_CURRENT_DESKTOP = "hyprland";
    };
  
    systemPackages = with pkgs; [
      hyprpaper
      nwg-drawer
    ];
  };
  
  programs = {
    regreet = {
      enable = true;
    };
    hyprland = {
      enable = true;
      xwayland.enable = true;
      nvidiaPatches = true;
    };
    waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        patches = (oldAttrs.patches or []) ++ [
          (pkgs.fetchpatch {
            name = "fix waybar hyprctl";
            url = "https://aur.archlinux.org/cgit/aur.git/plain/hyprctl.patch?h=waybar-hyprland-git&id=1ec549866eba42ae47920da6be4519d06962ca1c";
            sha256 = "sha256-pY3+9Dhi61Jo2cPnBdmn3NUTSA8bAbtgsk2ooj4y7aQ=";
          })
        ];
      });
    };
  };

  services = {
    greetd = {
      enable = true;
      settings = rec {
        default_session = let
          greetdConfig = pkgs.writeText "greetd-config" ''
              exec-once = ${pkgs.greetd.regreet}/bin/regreet; ${pkgs.hyprland}/bin/hyprctl dispatch exit
            '';
        in {
          command = "${pkgs.hyprland}/bin/Hyprland --config ${greetdConfig}";
        };
        initial_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "radxa";
        };
      };
    };
  };

  xdg.portal = {
    extraPortals = with pkgs; [ 
      xdg-desktop-portal-hyprland
    ];
  };
}
