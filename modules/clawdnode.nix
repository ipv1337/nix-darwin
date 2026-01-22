# ClawdNode LaunchAgent - auto-restart on crash
# Enabled on all hosts - will fail gracefully if app not installed
{ config, lib, pkgs, ... }:

{
  launchd.user.agents.clawdbot-node = {
    serviceConfig = {
      Label = "com.clawdbot.node.nix";
      # Use "Clawdbot" app name (current release)
      ProgramArguments = [ "/usr/bin/open" "-a" "Clawdbot" ];
      RunAtLoad = true;
      KeepAlive = {
        SuccessfulExit = false;
      };
      ThrottleInterval = 30;
      StandardOutPath = "/tmp/clawdbot-node.log";
      StandardErrorPath = "/tmp/clawdbot-node.err";
    };
  };
}
