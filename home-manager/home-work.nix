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
    "./.gnupg/gpg-agent.conf".source = ../dotfiles/gpg-agent.conf;
    "./.gnupg/gpg.conf".source = ../dotfiles/gpg.conf;
    "./.gnupg/scdaemon.conf".source = ../dotfiles/scdaemon.conf;
    "/.ssh/config".source = ../dotfiles/ssh_conf;
  };

  programs.neovim = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Anders Johansson";
    userEmail = "anders.johansson@safespring.com";
    extraConfig = {
      init.defaultBranch = "main";
      #commit.gpgsign = true;
      #gpg.format = "gpg";
      user.signingkey = "EB9E4DF3E489552FE16729B42C382213541BC679";
    };
  };
  programs.ssh = {
    enable = false;
    matchBlocks = {
      "host" = {
        hostname = "ip";
        identityFile = "~/.ssh/id_ed25519_sk-pub";
        user = "andersj";
        forwardAgent = true;
        
        RemoteForwards = "/run/user/1010/gnupg/S.gpg-agent /Users/andersjohansson/.gnupg/S.gpg-agent";
      };
    };
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
            "command" = [ "nixfmt" ]; # or nixfmt or nixpkgs-fmt
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
  programs.helix = {
    enable = true;
    settings = {
      theme = "autumn_night_transparent";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages.language = [{
      name = "nix";
      auto-format = true;
      formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
    }];
    themes = {
      autumn_night_transparent = {
        "inherits" = "autumn_night";
        "ui.background" = { };
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

      eval "$(/opt/homebrew/bin/brew shellenv)"

      export GNUPGHOME="~/.gnupg"
      GPG_TTY=$(tty)
      export GPG_TTY=$TTY

      alias cpass="PASSWORD_STORE_DIR=$HOME/.pass-team/ pass"
      compdef _pass cpass
      zstyle ':completion::complete:cpass::' prefix "$HOME/.pass-team"
      function cpass(){
        PASSWORD_STORE_DIR=$HOME/.pass-team pass $@
      }

      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket) # like in the guide
      gpgconf --launch gpg-agent # like in the guide
      gpg-connect-agent updatestartuptty /bye > /dev/null
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
