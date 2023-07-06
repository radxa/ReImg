{ config, pkgs, lib, ... }:

{
  home = {
    username = "radxa";
    homeDirectory = "/home/radxa";
    stateVersion = "23.05";
    file."${config.xdg.configHome}" = {
      source = ../dotfiles;
      recursive = true;
    };
  };
  programs = {
    home-manager.enable = true;
  };
}
