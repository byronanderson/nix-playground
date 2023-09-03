pkgs: 

let
  colorschemes = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "colorschemes";
    src = pkgs.fetchFromGitHub {
      owner = "lunarvim";
      repo = "colorschemes";
      rev = "e29f32990d6e2c7c3a4763326194fbd847b49dac";
      hash = "sha256-HBgaXKiVXgBl3G879Hvz1F45KD4/25oR3SXeGHaN/xE=";
    };
  };
  darkplus = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "darkplus";
    src = pkgs.fetchFromGitHub {
      owner = "lunarvim";
      repo = "darkplus.nvim";
      rev = "7c236649f0617809db05cd30fb10fed7fb01b83b";
      hash = "sha256-qnQfhMXbIY40axjxLc4qv+6bUcjA2zC0iHgeIiNjQ1c=";
    };
  };
in

{
  # Import all your configuration modules here
  imports = [
    ./bufferline.nix
  ];

config = {
  globals.mapleader = " ";
  globals."test#strategy" = "vimux";
  globals."slime_target" = "tmux";
globals.slime_default_config = ''{"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.2"}'';
  colorschemes.onedark.enable = true;

  options = {
    clipboard = "unnamedplus";               # allows neovim to access the system clipboard
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
    # navigating up/down/left/right to other split windows
    normal."<C-j>" = "<cmd>:wincmd j<cr>";
    normal."<C-h>" = "<cmd>:wincmd h<cr>";
    normal."<C-k>" = "<cmd>:wincmd k<cr>";
    normal."<C-l>" = "<cmd>:wincmd l<cr>";

    # fuzzy finders
    normal."<leader>f" = "<cmd>:Telescope git_files<cr>";
    normal."<leader>F" = "<cmd>:Telescope live_grep<cr>";

    # force a format
    normal."<leader>d" = "<cmd>lua vim.lsp.buf.format({ async = false })<cr>";
    normalVisualOp.";" = ":";
    normal."<leader>" = {
      silent = true;
      action = "<Nop>";
    };
    normal."<leader>h" = {
      # silent = true;
      action = "<cmd>set nohlsearch<CR>";
    };
    normal."<C-t><C-n>" = {
      silent = true;
      action = "<cmd>:wa <bar> TestNearest<CR>";
    };
    normal."<C-t><C-f>" = {
      silent = true;
      action = "<cmd>:wa <bar> TestFile<CR>";
    };
    normal."<C-t><C-s>" = {
      silent = true;
      action = "<cmd>:wa <bar> TestSuite<CR>";
    };
    normal."<C-t><C-l>" = {
      silent = true;
      action = "<cmd>:wa <bar> TestLast<CR>";
    };
    normal."<C-t><C-t>" = {
      silent = true;
      action = "<cmd>:wa <bar> TestLast<CR>";
    };
    normal."<C-t><C-g>" = {
      silent = true;
      action = "<cmd>:wa <bar> TestVisit<CR>";
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
        servers.nixd.enable = true;

        keymaps = {
          silent = false;
          lspBuf = {
            "gd" = "definition";
            "gD" = "references";
            # "gt" = "type_definition";
            "gi" = "implementation";
            "K" = "hover";
          };
        };

        onAttach = ''
        '';

      };

       plugins.telescope.enable = true;

       plugins.fugitive.enable = true;

       plugins.gitsigns = {
         enable = true;

         onAttach.function = ''
         function(bufnr)
           -- if vim.api.nvim_buf_get_name(bufnr):match(<PATTERN>) then
             -- Don't attach to specific buffers whose name matches a pattern
             -- return false
           -- end
           -- Setup keymaps
           vim.api.nvim_buf_set_keymap(bufnr, 'n', ']c', '<cmd>lua require"gitsigns".next_hunk()<CR>', {})
           vim.api.nvim_buf_set_keymap(bufnr, 'n', '[c', '<cmd>lua require"gitsigns".prev_hunk()<CR>', {})
         end
         '';
       };

       plugins.treesitter.enable = true;
       plugins.treesitter.incrementalSelection.enable = true;
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
      pkgs.vimPlugins.vim-vinegar
      pkgs.vimPlugins.vim-commentary
      pkgs.vimPlugins.vimux # "benmills/vimux"
      pkgs.vimPlugins.vim-test # "janko/vim-test"
      pkgs.vimPlugins.vim-tmux-navigator # christoomey/vim-tmux-navigator
      colorschemes
      pkgs.vimPlugins.vim-slime # jpalardy/vim-slime
      pkgs.vimPlugins.nvim-ts-context-commentstring # JoosepAlviste/nvim-ts-context-commentstring
      darkplus
    ];
    extraConfigVim = ''
     augroup _lsp
       autocmd!
       autocmd BufWritePre * lua vim.lsp.buf.format({ async = false })
     augroup end

     set autoread
     au FocusGained * checktime
    '';
};


  


  # https://github.com/nix-community/nixvim/issues/97
}
