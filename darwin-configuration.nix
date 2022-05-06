{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];
  environment.systemPackages = with pkgs; [
    deno
    fzf
    graphviz
    ripgrep
    terraform
    zsh-powerlevel10k
  ];
  # nixpkgs.config.allowUnfree = true;
  fonts.fonts = with pkgs; [
    meslo-lgs-nf
  ];
  users.users.kevinkoshiol = {
    name = "kevinkoshiol";
    home = "/Users/kevinkoshiol";
  };
  home-manager.users.kevinkoshiol = { pkgs, ... }: {
    programs.git = {
      enable = true;
      userName = "Kevin Koshiol";
      userEmail = "kevin.koshiol@calabrio.com";
      aliases = {
        adog = "log --all --decorate --oneline --graph --abbrev-commit --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
        amend = "commit --amend --no-edit";
        pushup = "push -u origin HEAD";
      };
      extraConfig = {
        pull = { ff = "only"; };
        init = { defaultBranch = "master"; };
      };
      ignores = [ "*~" ".DS_Store" ];
    };
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      history.expireDuplicatesFirst = true;
      initExtra = ''
        export DOCKER_BUILDKIT=1
        export ZSH_THEME=powerlevel10k/powerlevel10k
        export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
        export EDITOR=nvim
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        # NVM
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
        [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
        # Fuzzy Finder
        source ${pkgs.fzf}/share/fzf/completion.zsh
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        # Set Default Java Version
        export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '';
    };
    programs.kitty = {
      enable = true;
      settings = {
        background_opacity = "0.7";
        hide_window_decorations = true;
        macos_quit_when_last_window_closed = true;
        scrollback_lines = 10000;
      };
    };
    # programs.vscode = {
    #   enable = true;
    #   extensions = [
    #     pkgs.vscode-extensions.bbenoist.nix
    #     pkgs.vscode-extensions.dbaeumer.vscode-eslint
    #     pkgs.vscode-extensions.eamodio.gitlens
    #     pkgs.vscode-extensions.ms-vscode.vscode-js-profile-flame
    #   ];
    #   userSettings = {
    #     "editor.renderWhitespace" = "boundary";
    #     "editor.foldingImportsByDefault" = true;
    #     "editor.tabSize" = 2;
    #     "git.autofetch" = true;
    #     "git.confirmSync" = false;
    #     "gitlens.codeLens.scopes" = [ "document" ];
    #     "javascript.preferences.quoteStyle" = "single";
    #     "javascript.updateImportsOnFileMove.enabled" = "always";
    #     "js/ts.implicitProjectConfig.strictNullChecks" = true;
    #     "search.maintainFileSearchCache" = true;
    #     "terminal.integrated.fontFamily" = "Meslo LG M for Powerline";
    #     "typescript.format.semicolons" = "remove";
    #     "typescript.preferences.quoteStyle" = "single";
    #     "typescript.updateImportsOnFileMove.enabled" = "always";
    #   };
    # };
    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        coc-nvim
        coc-tsserver
        coc-html
        coc-css
        coc-rls
        coc-python
        coc-yaml
        coc-eslint
        fzf-vim
        vim-airline
        vim-gitgutter
        vim-polyglot
        vim-sneak
      ];
      extraConfig = "
        \" COC
        set hidden
        set nobackup
        set nowritebackup
        set cmdheight=2
        set updatetime=300
        set shortmess+=c
        set signcolumn=yes
        \" Editor
        set number
        set relativenumber
        let mapleader=\"\\<SPACE>\"
        set formatoptions+=o
        set expandtab
        set tabstop=2
        set shiftwidth=2
        set nojoinspaces
        set splitbelow
        set splitright
        if !&scrolloff
          set scrolloff=3
        endif
        if !&sidescrolloff
          set sidescrolloff=5
        endif
        set nostartofline
        if &listchars ==# 'eol:$'
          set listchars=tab:>\\ ,trail:-,extends:>,precedes:<,nbsp:+
        endif
        set list                \" Show problematic characters.
        highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
        match ExtraWhitespace /\\s\\+$\\|\t/
        set ignorecase          \" Make searching case insensitive
        set smartcase           \" ... unless the query has capital letters.
        set gdefault            \" Use 'g' flag by default with :s/foo/bar/.
      ";
    };
    # home.file = {
    #   powerlevel10k = {
    #     target = ".p10k.zsh";
    #   };
    # };
  };
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
