# ClawdNode LaunchAgent - auto-restart on crash
# Only enabled on nodes that run the Clawdbot desktop app
{ config, lib, pkgs, ... }:

let
  # Only these hosts run Clawdbot desktop app
  clawdbotHosts = [ "james-mbp16" "james-mbp32" ];
  hostname = config.networking.hostName;
  enableClawdbot = builtins.elem hostname clawdbotHosts;
in
{
  launchd.user.agents.clawdbot-node = lib.mkIf enableClawdbot {
    serviceConfig = {
      Label = "com.clawdbot.node";
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
