{ inputs, pkgs, ... }: {

  #environment.extraInit = ''
  #  export PATH=$HOME/bin:$PATH
  #'';

  # install packages from nix's official package repository.
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    git
    nil # nix language server
    nixfmt # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-fmt#examples
    tree
    bat
    eza
    fzf
    zoxide
  ];

  # To make this work, homebrew need to be installed manually, see
  # https://brew.sh The apps installed by homebrew are not managed by nix, and
  # not reproducible!  But on macOS, homebrew has a much larger selection of
  # apps than nixpkgs, especially for GUI apps!

  # work mac comes with brew
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      #cleanup = "zap";
    };

    #taps = [ "CtrlSpice/homebrew-otel-desktop-viewer" ];

    # brew install
    brews = [
      "koekeishiya/formulae/skhd"
      "mise"
      "stow"
      "lazygit"
      "coreutils"
      "tmux"
      "mosh"
      "nmap"
      "git-delta"
      "neovim"
      "tfenv"
      "bazelisk"
      "skaffold"
      "jq"
      "buf"
      "docker"
      "docker-buildx"
      "lazydocker"
      "k9s"
      "curlie"
      "posting"
      "rainfrog"
      # "otel-desktop-viewer"
      "yt-dlp"
      "mpv"
    ];

    # brew install --cask
    # these need to be updated manually
    #casks = [ "swiftbar" "spotify" "zoom" "intellij-idea" ];
    casks = [ "swiftbar" "visual-studio-code" ];

    # mac app store
    # click
    masApps = {
      tailscale = 1475387142;
      bitwarden = 1352778147;
      amphetamine = 937984704;
      easyres = 688211836;
      unsplash = 1284863847;
      copyclip = 595191960;
      dropover = 1355679052;
      hidden-bar = 1452453066;
      microsoft-onenote = 784801555;
      telegram = 747648890;
      whatsapp = 310633997;
      slack = 803453959;
      boop = 1518425043;
      key-codes = 414568915; # useful for debugging macos key codes
    };
  };

}
