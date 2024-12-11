# 
{ config, pkgs, ... }:

{
  # TODO please change the username & home directory to your own
  home.username = "andersjohansson";
  home.homeDirectory = "/Users/andersjohansson";

  #settings for macOS
  targets.darwin.defaults."com.apple.finder".FXRemoveOldTrashItems = true;
  #finder.FXRemoveOldTrashItems = true;
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    # neofetch
  ];
  home.sessionVariables = {
    EDITOR = "vim";
  };
  home.file = {
    ".vimrc".source = ../dotfiles/vim_configuration;
    "${config.xdg.configHome}/oh-my-posh/zen.toml".source = ../dotfiles/zen.toml;
    "./dotfiles/.aliases".source = ../dotfiles/aliases;
    "./dotfiles/.kubectl_aliases".source = ../dotfiles/kubectl_aliases;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    mutableExtensionsDir = false;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    extensions = with pkgs.open-vsx; [
      # https://raw.githubusercontent.com/nix-community/nix-vscode-extensions/master/data/cache/open-vsx-latest.json
      leodevbro.blockman
      bbenoist.nix
      pinage404.nix-extension-pack
      jnoortheen.nix-ide
      oderwat.indent-rainbow
      hashicorp.hcl
      bungcip.better-toml
    ] ++ (with  pkgs.vscode-marketplace; [
      # https://raw.githubusercontent.com/nix-community/nix-vscode-extensions/master/data/cache/vscode-marketplace-latest.json
      ms-vscode-remote.vscode-remote-extensionpack
      ms-vscode.remote-explorer
    ]);
    userSettings = {
      "editor.formatOnSave" = true;
      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 1000;
      "nix.serverPath" = "nixd";
      "nix.enableLanguageServer" = true;
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {
            "command" = [ "alejandra" ]; # or nixfmt or nixpkgs-fmt
          };
        };
      };
      "editor.inlayHints.enabled" = "off";
      "editor.guides.indentation" = false;
      "editor.guides.bracketPairs" = false;
      "editor.wordWrap" = "off";
      "diffEditor.wordWrap"= "off";
      "workbench.colorCustomizations" = {
      "editor.lineHighlightBorder"  = "#9fced11f";
      "editor.lineHighlightBackground"  = "#1073cf2d";
      };
    };
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      if [ -f $HOME/.config/nix/dotfiles/.zshrc ]; 
      then
        source $HOME/.config/nix/dotfiles/.zshrc
      fi
      eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/zen.toml)"
    '';
    history = {
      save = 1000000;
      size = 1000000;
    };
  };
  programs.oh-my-posh = {
    enable = true;
    #    enableZshIntegration = true;
  };
  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
