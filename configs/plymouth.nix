{ config, pkgs, lib, ... }:

{
  boot = {
    plymouth = {
      enable = true;
    };
    kernelParams = [
      "plymouth.ignore-serial-consoles"
    ];
  };
}
