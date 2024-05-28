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
  # globals."slime_target" = "tmux";
# globals.slime_default_config = ''{"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.2"}'';
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
    insert."jk" = "<Esc>";

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
    normal."gl" = {
      silent = true;
      action = "<cmd>lua vim.diagnostic.open_float()<CR>";
    };
    normal."[d" = {
      silent = true;
      action = "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded' })<CR>";
    };
    normal."]d" = {
      silent = true;
      action = "<cmd>lua vim.diagnostic.goto_next({ border = 'rounded' })<CR>";
    };
    normal."[e" = {
      silent = true;
      action = "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded', severity = vim.diagnostic.severity.ERROR })<CR>";
    };
    normal."]e" = {
      silent = true;
      action = "<cmd>lua vim.diagnostic.goto_next({ border = 'rounded', severity = vim.diagnostic.severity.ERROR})<CR>";
    };
    normal."<leader>q" = {
      silent = true;
      action = "<cmd>lua vim.diagnostic.setloclist()<CR>";
    };

  };

   plugins.luasnip.enable = true;

   plugins.nvim-cmp = {
     enable = true;
     snippet.expand = "luasnip";
     sources = [
       {
         name = "nvim_lsp";
       }
       {
         name = "buffer";
       }
       {
         name = "luasnip";
       }
       {
         name = "path";
       }
     ];
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
        servers.java-language-server.enable = true;
        servers.denols.enable = true;

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

        plugins.which-key = {
          enable = true;
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
          "markdown"
          "nix"
          "python"
          "regex"
          "rust"
          "yaml"
        ];
      plugins.vim-slime = {
        enable = true;
        target = "tmux";
        defaultConfig = {
          socket_name = "default";
          target_pane = ":.2";
        };
      };

    extraPlugins = [
      pkgs.vimPlugins.vim-vinegar
      pkgs.vimPlugins.vim-commentary
      pkgs.vimPlugins.vimux # "benmills/vimux"
      pkgs.vimPlugins.vim-test # "janko/vim-test"
      pkgs.vimPlugins.vim-tmux-navigator # christoomey/vim-tmux-navigator
      colorschemes
      # pkgs.vimPlugins.vim-slime # jpalardy/vim-slime
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
    extraConfigLua = ''
      local mappings = {
        ["b"] = {
          "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
          "Buffers",
        },
        ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
        ["w"] = { "<cmd>wa!<CR>", "Save" },
        ["q"] = { "<cmd>q!<CR>", "Quit" },
        ["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
        ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
        ["f"] = {
          "<cmd>lua require('telescope.builtin').git_files(require('telescope.themes').get_dropdown())<cr>",
          "Find files",
        },
        ["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
        ["P"] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
        ["C"] = { "<cmd>:NewColor<CR>", "Random Colorscheme" },
        ["\""] = { "<cmd>Telescope registers<cr>", "Registers" },

        p = {
          name = "Packer",
          c = { "<cmd>PackerCompile<cr>", "Compile" },
          i = { "<cmd>PackerInstall<cr>", "Install" },
          s = { "<cmd>PackerSync<cr>", "Sync" },
          S = { "<cmd>PackerStatus<cr>", "Status" },
          u = { "<cmd>PackerUpdate<cr>", "Update" },
        },

        g = {
          name = "Git",
          g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
          j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
          k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
          l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
          p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
          r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
          R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
          s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
          u = {
            "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
            "Undo Stage Hunk",
          },
          o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
          b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
          c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
          d = {
            "<cmd>Gitsigns diffthis HEAD<cr>",
            "Diff",
          },
        },

        l = {
          name = "LSP",
          a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
          d = {
            "<cmd>Telescope diagnostics<cr>",
            "Diagnostics",
          },
          w = {
            "<cmd>Telescope lsp_workspace_diagnostics<cr>",
            "Workspace Diagnostics",
          },
          f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
          i = { "<cmd>LspInfo<cr>", "Info" },
          I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
          j = {
            "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
            "Next Diagnostic",
          },
          k = {
            "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
            "Prev Diagnostic",
          },
          l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
          q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
          R = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
          r = { "<cmd>Telescope lsp_references<cr>", "Find References" },
          s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
          S = {
            "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
            "Workspace Symbols",
          },
        },
        s = {
          name = "Search",
          b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
          c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
          h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
          M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
          r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
          R = { "<cmd>Telescope registers<cr>", "Registers" },
          k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
          C = { "<cmd>Telescope commands<cr>", "Commands" },
        },

        t = {
          name = "Terminal",
          n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
          u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
          t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
          p = { "<cmd>l a _PYTHON_TOGGLE()<cr>", "Python" },
          f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
          h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
          v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
        },
      }

      local opts = {
        mode = "n", -- NORMAL mode
        prefix = "<leader>",
        buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
        silent = true, -- use `silent` when creating keymaps
        noremap = true, -- use `noremap` when creating keymaps
        nowait = true, -- use `nowait` when creating keymaps
      };

      require("which-key").register(mappings, opts);
    '';

};


  


  # https://github.com/nix-community/nixvim/issues/97
}
