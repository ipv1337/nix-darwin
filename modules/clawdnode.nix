# ClawdNode LaunchAgent - auto-restart on crash
# Enabled on all hosts - will fail gracefully if app not installed
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
