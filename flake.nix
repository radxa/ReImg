{
  description = "ReImg Recovery System";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-generators, ... }: let

    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ] (system: function nixpkgs.legacyPackages.${system});

  in {
    packages = forAllSystems (pkgs: {
      default = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        modules = [
          ./configs/base.nix
          ./configs/hardware-configuration.nix
          ./configs/plasma5.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.radxa = import ./configs/radxa.nix;
          }
        ];
        format = "raw-efi";
      };
    });

    nixosConfigurations = {
      ReImg = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configs/base.nix
          ./configs/hardware-configuration.nix
          ./configs/plasma5.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.radxa = import ./configs/radxa.nix;
          }
        ];
      };
    };
  };
}
