pkgs: {
  # Import all your configuration modules here
  imports = [
    ./bufferline.nix
  ];

config = {
  globals.mapleader = " ";

  options = {
    # -- clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
    cmdheight = 2;                           # more space in the neovim command line for displaying messages
    fileencoding = "utf-8";                  # the encoding written to a file
    hlsearch = true;                         # highlight all matches on previous search pattern
    ignorecase = true;                       # ignore case in search patterns
    mouse = "a";                             # allow the mouse to be used in neovim
    pumheight = 10;                          # pop up menu height
    showmode = false;                        # we don't need to see things like -- INSERT -- anymore
    showtabline = 2;                         # always show tabs
    smartcase = true;                        # smart case
    smartindent = true;                      # make indenting smarter again
    splitbelow = true;                       # force all horizontal splits to go below current window
    splitright = true;                       # force all vertical splits to go to the right of current window
    swapfile = false;                        # creates a swapfile
    termguicolors = true;                    # set term gui colors (most terminals support this)
    timeoutlen = 500;                        # time to wait for a mapped sequence to complete (in milliseconds)
    undofile = false;                         # enable persistent undo
    # --undodir = os.getenv("HOME") .. '/.vim/undodir';
    updatetime = 300;                        # faster completion (4000ms default)
    writebackup = false;                     # if a file is being edited by another program (or was written to file while editing with another program); it is not allowed to be edited
    expandtab = true;                        # convert tabs to spaces
    shiftwidth = 2;                          # the number of spaces inserted for each indentation
    tabstop = 2;                             # insert 2 spaces for a tab
    cursorline = true;                       # highlight the current line
    number = true;                           # set numbered lines
    relativenumber = false;                  # set relative numbered lines
    numberwidth = 4;                         # set number column width
    signcolumn = "yes";                      # always show the sign column; otherwise it would shift the text each time
    wrap = true;                             # display lines as one long line
    scrolloff = 8;                           # is one of my fav
    sidescrolloff = 8;
    # guifont = "monospace:h17";               # the font used in graphical neovim applications
  };

  maps = {
      normalVisualOp.";" = ":";
      normal."<leader>" = {
        silent = true;
        action = "<Nop>";
      };
      normal."<leader>m" = {
        # silent = true;
        action = "<cmd>echo 'hi'<CR>";
      };
      normal."<leader>h" = {
        # silent = true;
        action = "<cmd>set nohlsearch<CR>";
      };
    };

  plugins.null-ls = {
    enable = true;
    sources.formatting.black.enable = true;
    sources.formatting.prettier.enable = true;
    sources.diagnostics.shellcheck.enable = true;
  };

  plugins.lsp = {
        enable = true;
        servers.elixirls.enable = true;
      };

       plugins.treesitter.enable = true;
       plugins.treesitter.ensureInstalled = [
       "elixir"
          "bash"
          "cpp"
          "css"
          "go"
          "html"
          "java"
          "json"
          "latex"
          "lua"
          "make"
          "nix"
          "python"
          "regex"
          "rust"
          "yaml"
        ];
    extraPlugins = [
      pkgs.vimPlugins.vim-fugitive
      pkgs.vimPlugins.vim-vinegar
    ];
};


  


  # https://github.com/nix-community/nixvim/issues/97
}
