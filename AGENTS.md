# Project Overview

This repository contains a declarative system configuration for a macOS machine, managed using [Nix flakes](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix-flake.html), [nix-darwin](https://github.com/LnL7/nix-darwin), and [Home Manager](https://nix-community.github.io/home-manager/).

It aims to provide a reproducible and version-controlled environment for:
*   **System-wide settings:** Configured via `nix-darwin` modules in the `modules/` directory.
*   **User-specific configurations:** Managed by `Home Manager` through `home/home.nix`.
*   **Application management:** Defined within the Nix ecosystem.

The `flake.nix` file serves as the central entry point, defining the project's dependencies and the system configuration for the host named "James-MacBook-Pro".

# Building and Running

To apply the system and user configurations defined in this flake, you will typically use the `darwin-rebuild` and `home-manager` commands.

**To apply the system configuration (nix-darwin):**

```bash
darwin-rebuild switch --flake .#James-MacBook-Pro
```

**To apply the user configuration (Home Manager):**

```bash
home-manager switch --flake .#James-MacBook-Pro
```

**Note:** Ensure you have Nix and nix-darwin installed and configured to use flakes.

# Development Conventions

*   **Declarative Configuration:** The entire system and user environment are defined declaratively using Nix expressions, promoting reproducibility and ease of management.
*   **Nix Flakes:** Dependencies and outputs are managed through Nix flakes, providing a locked and consistent set of inputs.
*   **Modular Structure:** The `modules/` directory contains separate Nix files for different aspects of the system configuration (e.g., `system.nix`, `apps.nix`, `host-users.nix`, `nix-core.nix`), promoting organization and reusability.
*   **Dotfile Management:** As noted in `home/README.md`, it is recommended *not* to manage dotfiles directly within Nix for this project. Instead, a separate dotfiles repository combined with a tool like `stow` is suggested for managing user dotfiles.
