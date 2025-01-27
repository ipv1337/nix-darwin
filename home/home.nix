{ config, lib, pkgs, ... }: {

  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;

  # this is internal compatibility configuration 
  # for home-manager, don't change this!
  home.stateVersion = "23.11";
  home.packages = with pkgs; [];
  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.git = {
    enable = true;
    userName = "James H. Nguyen";
    userEmail = "git@nocentre.net";
    extraConfig = {
      github.user = "ipv1337";
      init = { defaultBranch = "main"; };
      diff = { external = "${pkgs.difftastic}/bin/difft"; };
    };
  };
}
