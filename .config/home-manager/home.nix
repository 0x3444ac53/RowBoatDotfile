{ config, pkgs, lib, ... }:

let
  fromGitHub = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };
in

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nora";
  home.homeDirectory = "/home/nora";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nora/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
        search = "~/bin/ellies-bash-scripts/modules/search.sh";
        config = "git --git-dir=$HOME/.cfg/  --work-tree=$HOME";
    };
    oh-my-zsh = {
        enable = true;
        plugins = [
        "pip"
        "python"
        "git" 
        "fzf" 
        ];
        theme = "minimal";
    };
  };
  programs.neovim = {
    enable = true;
    coc.enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
set tabstop=4
set shiftwidth=4
set expandtab
set relativenumber
set number


colorscheme base16-nord

set nocompatible
filetype plugin on

augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init()
  autocmd FileType text         call pencil#init()
augroup END

autocmd InsertLeave * :set relativenumber number
autocmd InsertEnter * :set norelativenumber
autocmd Filetype markdown :Goyo
tnoremap <Esc> <C-\><C-n>
command! -nargs=* T split | terminal <args>
command! -nargs=* VT vsplit | terminal <args>
map ; : :NERDTreeToggle<CR>
'';
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      plenary-nvim
      gruvbox-material
      mini-nvim
      (fromGitHub "HEAD" "elihunter173/dirbuf.nvim")
      (fromGitHub "HEAD" "RRethy/nvim-base16")
      vim-multiple-cursors
      surround-nvim
      nerdtree
      vim-nerdtree-tabs
      nerdtree-git-plugin
      vim-gitgutter
      goyo-vim
      vim-pencil
    ];
  };
}
