{ pkgs, ... }: {

  nix.settings = {
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];

    # substituers that will be considered before the official ones(https://cache.nixos.org)
    substituters = [
      #"https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
    ];
    trusted-users = [ "root" ];
    #trusted-public-keys = [
    #  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #];
    builders-use-substitutes = true;
  };

  # auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix.package = pkgs.nix;
  programs.nix-index.enable = true;

  # clean up every once in a while
  nix.gc.automatic = true;
  # gets rid of duplicate store files
  # turned off due to
  # https://github.com/NixOS/nix/issues/7273#issuecomment-1325073957
  #nix.settings.auto-optimise-store = false;
  # nix store optimise (manually instead)

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # linux builder
  # https://nixcademy.com/2024/02/12/macos-linux-builder/
  # root was here previously, @admin is for linux-builder
  #nix.settings.trusted-users = [ "root" "@admin" ];

  # sudo launchctl list org.nixos.linux-builder
  # sudo launchctl stop org.nixos.linux-builder
  #nix.linux-builder = {
  #  enable = true;
  #  ephemeral = true;
  #  maxJobs = 4;
  #  config = {
  #    virtualisation = {
  #      darwin-builder = {
  #        diskSize = 40 * 1024; # 40gb
  #        memorySize = 8 * 1024; # 8gb
  #      };
  #      cores = 6;
  #    };
  #  };
  #};
  # try it
  # nix build --impure  --expr '(with import <nixpkgs> { system = "aarch64-linux"; }; runCommand "foo" { nativeBuildInputs = [ neofetch ]; } "neofetch >> $out" )' && cat result

}
