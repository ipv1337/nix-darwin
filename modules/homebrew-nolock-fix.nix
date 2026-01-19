# WORKAROUND: Patch homebrew activation to remove --no-lock flag
# The nix-darwin 24.11 branch uses --no-lock which isn't supported by older brew bundle
# This module overrides the activation script to remove that flag
{ config, lib, pkgs, ... }:

let
  cfg = config.homebrew;
  brewfileFile = pkgs.writeText "Brewfile" cfg.brewfile;
  
  # Rebuild the brewBundleCmd without --no-lock
  brewBundleCmdFixed = lib.concatStringsSep " " (
    lib.optional (!cfg.onActivation.autoUpdate) "HOMEBREW_NO_AUTO_UPDATE=1"
    ++ [ "brew bundle --file='${brewfileFile}'" ]  # NO --no-lock here
    ++ lib.optional (!cfg.onActivation.upgrade) "--no-upgrade"
    ++ lib.optional (cfg.onActivation.cleanup == "uninstall") "--cleanup"
    ++ lib.optional (cfg.onActivation.cleanup == "zap") "--cleanup --zap"
    ++ cfg.onActivation.extraFlags
  );
in
{
  # Override the homebrew activation script
  system.activationScripts.homebrew.text = lib.mkIf cfg.enable (lib.mkForce ''
    # Homebrew Bundle (patched to remove --no-lock)
    echo >&2 "Homebrew bundle..."
    if [ -f "${cfg.brewPrefix}/brew" ]; then
      PATH="${cfg.brewPrefix}":$PATH ${brewBundleCmdFixed}
    else
      echo -e "\e[1;31merror: Homebrew is not installed, skipping...\e[0m" >&2
    fi
  '');
}
