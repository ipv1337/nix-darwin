# in configuration.nix
{ pkgs, lib, inputs }: {
# inputs.self, inputs.nix-darwin, and inputs.nixpkgs can be accessed here

  nixpkgs.hostPlatform = "aarch64-darwin";
}
