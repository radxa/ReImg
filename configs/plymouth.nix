{ config, pkgs, lib, ... }:

{
  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };
}
