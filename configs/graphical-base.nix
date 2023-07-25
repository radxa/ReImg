{ config, pkgs, lib, ... }:

{
  powerManagement.enable = true;

  environment = {
    variables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_WEBRENDER = "1";
      MOZ_USE_XINPUT2 = "1";
      XDG_SESSION_TYPE = "wayland";
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORMTHEME = "kde";
      QT_QPA_PLATFORM = "wayland";
      CLUTTER_BACKEND = "wayland";
      SDL_VIDEODRIVER = "wayland";
    };
  
    systemPackages = with pkgs; [
      htop
      pavucontrol
    ];
  };

  programs = {
    dconf.enable = true;
  };

  services = {
    dbus.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make firefox happy
    extraPortals = with pkgs; [ 
      xdg-desktop-portal-gtk
    ];
  };
}
