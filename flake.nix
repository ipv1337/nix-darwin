{

  description = "James nix-darwin system flake";

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-locked.url =
      "github:NixOS/nixpkgs/1042fd8b148a9105f3c0aca3a6177fd1d9360ba5";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs =
    inputs@{ self, nixpkgs, nixpkgs-unstable, nix-darwin, home-manager, ... }:
    let
      configuration = { pkgs, ... }: {
        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;
      };
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#James-MacBook-Pro
      darwinConfigurations."James-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          configuration
          ./modules/nix-core.nix
          ./modules/system.nix
          ./modules/apps.nix
          ./modules/host-users.nix
          ./modules/homebrew-nolock-fix.nix  # WORKAROUND: remove --no-lock flag
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.verbose = true;
            home-manager.users.james = import ./home/home.nix;
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            home-manager.extraSpecialArgs = {
              inherit inputs;
              #dotfiles = dotfiles;
              # hack around nix-home-manager causing infinite recursion
              isLinux = false;
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };
      # ARM Mac: james-mbp16 (has nixbld GID 30000 from old nix install)
      darwinConfigurations."james-mbp16" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          configuration
          ./modules/nix-core.nix
          ./modules/system.nix
          ./modules/apps.nix
          ./modules/host-users.nix
          ./modules/homebrew-nolock-fix.nix  # WORKAROUND: remove --no-lock flag
          { ids.gids.nixbld = 30000; }  # Match existing GID
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.verbose = true;
            home-manager.users.james = import ./home/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              isLinux = false;
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };

      # ARM Mac: james-mbp32 (has nixbld GID 350 from Determinate installer)
      darwinConfigurations."james-mbp32" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          configuration
          ./modules/nix-core.nix
          ./modules/system.nix
          ./modules/apps.nix
          ./modules/host-users.nix
          ./modules/homebrew-nolock-fix.nix  # WORKAROUND: remove --no-lock flag
          { ids.gids.nixbld = 350; }  # Match existing GID
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.verbose = true;
            home-manager.users.james = import ./home/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              isLinux = false;
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };

      # Intel Mac: james-mbp (has nixbld GID 350)
      darwinConfigurations."james-mbp" = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          configuration
          ./modules/nix-core-x86.nix  # x86-specific nix-core
          ./modules/system.nix
          ./modules/apps.nix
          ./modules/host-users.nix
          ./modules/homebrew-nolock-fix.nix  # WORKAROUND: remove --no-lock flag
          { ids.gids.nixbld = 350; }  # Match existing GID
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.verbose = true;
            home-manager.users.james = import ./home/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              isLinux = false;
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."James-MacBook-Pro".pkgs;
    };

}
