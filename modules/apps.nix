{ inputs, pkgs, lib, config, ... }: {

  #environment.extraInit = ''
  #  export PATH=$HOME/bin:$PATH
  #'';

  # install packages from nix's official package repository.
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    git
    nil    # nix language server
    nixfmt # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-fmt#examples
    tree
    bat
    # Moved to Homebrew for cross-node sync (see ~/.dotfile/Brewfile)
    # eza
    # fzf
    # zoxide
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

    taps = [
      "koekeishiya/formulae"       # skhd
      "go-task/tap"                # go-task
      "openhue/cli"                # openhue-cli
      "antoniorodr/memo"           # memo (Apple Notes CLI)
      "atlassian/acli"             # Atlassian CLI
      "f/mcptools"                 # MCP tools
      "rust-mcp-stack/tap"         # rust-mcp-filesystem
      "sinelaw/fresh"              # fresh
      "slp/krunkit"                # krunkit
      "sst/tap"                    # opencode
      "steipete/tap"               # bird, camsnap, gogcli, peekaboo, remindctl, summarize, wacli
      "workos/tap"                 # workos-cli
    ];

    # brew install - organized by category
    brews = [
      # === Terminal & Shell ===
      "coreutils"
      "eza"              # Modern ls
      "fzf"              # Fuzzy finder
      "zoxide"           # Smart cd
      "tmux"
      "mosh"
      "yazi"             # File manager
      "fastfetch"        # System info
      "htop"             # Process monitor
      "procs"            # Modern ps
      "duf"              # Disk usage
      "watch"

      # === Editors & Dev Tools ===
      "neovim"
      "mise"             # Runtime version manager
      "stow"             # Dotfiles manager
      "lazygit"

      # === Git ===
      "gh"
      "git-delta"
      "git-lfs"
      "git-filter-repo"
      "pre-commit"

      # === Network & HTTP ===
      "nmap"
      "curlie"
      "httpie"
      "wget"
      "speedtest-cli"
      "tailscale"
      "wireshark"

      # === Containers & K8s ===
      "docker"
      "docker-compose"
      "docker-buildx"
      "lazydocker"
      "kompose"
      "k9s"
      "skaffold"
      "incus"
      "lima-additional-guestagents"
      "slp/krunkit/krunkit"
      "socket_vmnet"
      "spice-protocol"
      "spice-server"

      # === Languages & Runtimes ===
      "node"
      "nvm"
      "uv"
      "python@3.12"
      "poetry"
      "pnpm"
      "ruff"              # Python linter

      # === Build & CI ===
      "bazelisk"
      "cmake"
      "go-task/tap/go-task"

      # === Data & APIs ===
      "jq"
      "buf"
      "posting"
      "rainfrog"          # Postgres TUI
      "stripe-cli"

      # === Code Quality ===
      "sonar-scanner"
      "checkstyle"
      "pmd"
      "spotbugs"
      "cloc"

      # === Media ===
      "yt-dlp"
      "mpv"

      # === macOS Utilities ===
      "koekeishiya/formulae/skhd"
      "mas"
      "bitwarden-cli"
      "openhue/cli/openhue-cli"

      # === Clawdbot Skills (steipete taps) ===
      "steipete/tap/bird"
      "steipete/tap/camsnap"
      "steipete/tap/gogcli"
      "steipete/tap/peekaboo"
      "steipete/tap/remindctl"
      "steipete/tap/summarize"
      "steipete/tap/wacli"

      # === AI & Coding Agents ===
      #"codex"
      "sst/tap/opencode"
      "f/mcptools/mcp"
      "rust-mcp-stack/tap/rust-mcp-filesystem"
      "sinelaw/fresh/fresh"

      # === Work Tools ===
      "atlassian/acli/acli"
      #"jira-cli"
      "workos/tap/workos-cli"
      "antoniorodr/memo/memo"
    ];

    # brew install --cask
    casks = [
      # === Terminals & Editors ===
      "ghostty"
      "visual-studio-code"

      # === Containers ===
      "podman-desktop"

      # === Fonts ===
      "font-hack-nerd-font"
      "font-dejavu-sans-mono-for-powerline"
      "font-powerline-symbols"

      # === Cloud ===
      "gcloud-cli"
      #"google-cloud-sdk"

      # === Utilities ===
      "swiftbar"

      # === AI/Dev Tools ===
      "codexbar"
      "opencode-desktop"
      "repobar"
      "slack-cli"
    ];

    # mac app store - TEMPORARILY DISABLED (mas hangs on password prompt)
    # Install these manually via App Store, then re-enable
    # masApps = {
    #   tailscale = 1475387142;
    #   bitwarden = 1352778147;
    #   amphetamine = 937984704;
    #   easyres = 688211836;
    #   unsplash = 1284863847;
    #   copyclip = 595191960;
    #   dropover = 1355679052;
    #   hidden-bar = 1452453066;
    #   microsoft-onenote = 784801555;
    #   telegram = 747648890;
    #   whatsapp = 310633997;
    #   slack = 803453959;
    #   boop = 1518425043;
    #   key-codes = 414568915; # useful for debugging macos key codes
    # };
  };

}
