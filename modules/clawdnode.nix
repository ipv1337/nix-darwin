# ClawdNode LaunchAgent - auto-restart on crash
# Only enabled on nodes that run the ClawdNode desktop app
{ config, lib, pkgs, ... }:

let
  # Only these hosts run ClawdNode
  clawdnodeHosts = [ "james-mbp16" "james-mbp32" ];
  hostname = config.networking.hostName;
  enableClawdNode = builtins.elem hostname clawdnodeHosts;
in
{
  launchd.user.agents.clawdnode = lib.mkIf enableClawdNode {
    serviceConfig = {
      Label = "com.clawdbot.node";
      ProgramArguments = [ "/usr/bin/open" "-a" "ClawdNode" "--args" "--background" ];
      RunAtLoad = true;
      KeepAlive = {
        SuccessfulExit = false;
      };
      ThrottleInterval = 30;
      StandardOutPath = "/tmp/clawdnode.log";
      StandardErrorPath = "/tmp/clawdnode.err";
    };
  };
}
