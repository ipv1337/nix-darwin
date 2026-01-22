# ClawdNode LaunchAgent - auto-restart on crash
# Enabled on all hosts - will fail gracefully if app not installed
{ config, lib, pkgs, ... }:

{
  launchd.user.agents.clawdbot-node = {
    serviceConfig = {
      Label = "com.clawdbot.node.nix";
      # Run the app binary directly so launchd can track the process
      ProgramArguments = [ "/Applications/Clawdbot.app/Contents/MacOS/Clawdbot" ];
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
