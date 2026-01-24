# ==============================================================================
# ClawdNode LaunchAgent — Auto-restart Clawdbot.app on crash
# ==============================================================================
#
# CURRENT STATUS: Legacy module (app-only restart)
#
# This module only manages the Clawdbot.app LaunchAgent. The gateway and CLI
# are currently installed via npm (`npm install -g clawdbot`) and managed by
# `clawdbot onboard --install-daemon`.
#
# FOR FULL NIX MANAGEMENT:
# ────────────────────────
# Consider migrating to nix-clawdbot (github:clawdbot/nix-clawdbot) which
# provides declarative management of:
#   - Gateway + macOS app + tools (all pinned)
#   - Launchd services that survive reboots
#   - Plugin system with declarative config
#   - Instant rollback via `home-manager switch --rollback`
#
# To migrate:
#   1. Uncomment nix-clawdbot input in flake.nix
#   2. Add nix-clawdbot.darwinModules.default to each host's modules
#   3. Configure programs.clawdbot in home.nix
#   4. Remove this clawdnode.nix module
#
# See: https://github.com/clawdbot/nix-clawdbot
#      https://docs.clawd.bot/install/nix
#
# ==============================================================================
{ config, lib, pkgs, ... }:

{
  launchd.user.agents.clawdbot-node = {
    serviceConfig = {
      Label = "com.clawdbot.node.nix";
      # Use wrapper script to kill stale SSH tunnels before starting
      # This fixes reconnection issues when the app restarts but old tunnels persist
      ProgramArguments = [
        "/bin/zsh"
        "-c"
        ''
          # Kill any stale SSH tunnels for Clawdbot gateway (port 18789)
          pkill -f "ssh.*18789" 2>/dev/null || true
          sleep 1
          # Start Clawdbot
          exec /Applications/Clawdbot.app/Contents/MacOS/Clawdbot
        ''
      ];
      RunAtLoad = true;
      KeepAlive = true;  # Always restart if process exits
      ThrottleInterval = 10;
      StandardOutPath = "/tmp/clawdbot-node.log";
      StandardErrorPath = "/tmp/clawdbot-node.err";
      EnvironmentVariables = {
        PATH = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };
}
