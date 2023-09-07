#
#  Home-manager configuration for macbook
#
#  flake.nix
#   ├─ ./darwin
#   │   ├─ ./default.nix
#   │   └─ ./home.nix *
#   └─ ./modules
#       └─ ./programs
#           └─ ./alacritty.nix
#

{ pkgs, ... }:

{
  home = {                                        # Specific packages for macbook
    packages = with pkgs; [
      # Terminal
      pfetch
    ];
    stateVersion = "23.05";
  };

  programs = {
    zsh = {                                       # Post installation script is run in configuration.nix to make it default shell
      enable = true;
      enableAutosuggestions = true;               # Auto suggest options and highlights syntax. It searches in history for options
      #enableSyntaxHighlighting = true;
      history.size = 10000;

      oh-my-zsh = {                               # Extra plugins for zsh
        enable = true;
        theme = "gentoo";
        plugins = [ "git" ];
        custom = "$HOME/.config/zsh_nix/custom";
      };

      initExtra = "source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup";
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [

        # Syntax
        vim-nix
        vim-markdown

        # Quality of life
        vim-lastplace                             # Opens document where you left it
        auto-pairs                                # Print double quotes/brackets/etc.
        vim-gitgutter                             # See uncommitted changes of file :GitGutterEnable

        # File Tree
        nerdtree                                  # File Manager - set in extraConfig to F6

        # Customization
        wombat256-vim                             # Color scheme for lightline
        srcery-vim                                # Color scheme for text

        lightline-vim                             # Info bar at bottom
        indent-blankline-nvim                     # Indentation lines
      ];
    };
  };
}
