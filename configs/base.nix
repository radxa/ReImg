{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/profiles/base.nix"
    "${modulesPath}/profiles/all-hardware.nix"
  ];

  # Support common file systems
  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    supportedFilesystems = [ 
      # There is a build error for apfs module
      # "apfs"
      "exfat"
      "nfs"
    ];
    initrd.availableKernelModules = [
      "virtio_blk"
      "virtio_pmem"
      "virtio_console"
      "virtio_pci"
      "virtio_mmio"
      "virtio_scsi"
    ];
    initrd.kernelModules = [
      "i915"
      "amdgpu"
      "nouveau"
      "virtio-gpu"
    ];
    kernelParams = [
      "quiet"
      "console=tty0"
      "console=ttyS0"
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      libsForQt5.dolphin
      firefox-wayland
      git
      partition-manager
      pciutils
      usbutils
      wget
      xdg-user-dirs
      xdg-utils
    ];
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      # Default fonts
      noto-fonts-emoji
      cantarell-fonts
      twitter-color-emoji
      source-code-pro
      gentium
      # Additional fonts
      source-sans-pro
      source-serif-pro
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      font-awesome
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Source Serif Pro" "Noto Serif CJK SC" ];
        sansSerif = [ "Source Sans Pro" "Noto Sans CJK SC" ];
        monospace = [ "Source Code Pro" "Noto Sans Mono CJK SC" ];
      };
    };
  };

  hardware = {
    # Enable all firmware (requires nixpkgs.config.allowUnFree)
    enableAllFirmware = true;
    bluetooth.enable = true;
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-chinese-addons
      ];
    };
  };

  networking = {
    hostName = "ReImg";
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Etc/UTC";

  users.users = {
    radxa = {
      isNormalUser = true;
      initialHashedPassword = "";
      extraGroups = [ "wheel" "input" "networkmanager" "video" ];
    };
    root.initialHashedPassword = "";
  };

  security = {
    polkit.enable = true;
    # rtkit is optional but recommended for PipeWire
    rtkit.enable = true;
    sudo = {
      enable = lib.mkDefault true;
      wheelNeedsPassword = false;
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    logind = {
      lidSwitch = "ignore";
    };
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    timesyncd.enable = lib.mkDefault true;
    qemuGuest.enable = true;
  };

  xdg = {
    mime.defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Define default system.stateVersion
  system.stateVersion = "23.05";
}
