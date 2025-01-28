{ config, lib, pkgs, ... }: {

  home.username = "james";
  home.homeDirectory = "/Users/james";
  # this is internal compatibility configuration 
  # for home-manager, don't change this!
  home.stateVersion = "25.05";
  home.packages = with pkgs; [];

  # home.file.".vimrc".source = ./dotfile/vimrc;
  home.file = {
    ".zshrc".source = ./dotfile/zshrc;
    ".vimrc".source = ./dotfile/vimrc;
    ".gitconfig".source = ./dotfile/gitconfig;
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.git = {
    enable = true;
    userName = "James H. Nguyen";
    userEmail = "git@nocentre.net";
    ignores = [ ".DS_Store" ];
    extraConfig = {
      github.user = "ipv1337";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      diff.external = "${pkgs.difftastic}/bin/difft";
    };
  };

  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;

}
