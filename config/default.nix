pkgs: 

let
  colorschemes = pkgs.vimUtils.buildVimPlugin {
    name = "colorschemes";
    src = pkgs.fetchFromGitHub {
      owner = "lunarvim";
      repo = "colorschemes";
      rev = "e29f32990d6e2c7c3a4763326194fbd847b49dac";
      hash = "sha256-HBgaXKiVXgBl3G879Hvz1F45KD4/25oR3SXeGHaN/xE=";
    };
  };
  darkplus = pkgs.vimUtils.buildVimPlugin {
    name = "darkplus";
    src = pkgs.fetchFromGitHub {
      owner = "lunarvim";
      repo = "darkplus.nvim";
      rev = "7c236649f0617809db05cd30fb10fed7fb01b83b";
      hash = "sha256-qnQfhMXbIY40axjxLc4qv+6bUcjA2zC0iHgeIiNjQ1c=";
    };
  };
  randomcolorscheme = pkgs.vimUtils.buildVimPlugin {
    name = "random-colorscheme.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "tetzng";
      repo = "random-colorscheme.nvim";
      rev = "5c82a09c5e1ed5aa945d79e001b5e531e22d10d9";
      hash = "sha256-pY2Lz0ZdhjhkHL8MPNbUTIb7Fx2Mbs7YgYw42Fhijtc=";
    };
  };
in

{
  # Import all your configuration modules here

  config = {
    globals.mapleader = " ";
    globals."test#strategy" = "vimux";
    colorschemes.onedark.enable = true;
    colorschemes.gruvbox.enable = true;
    colorschemes.catppuccin.enable = true;
    colorscheme = "gruvbox";

    opts = {
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

    keymaps = [
      { mode = "i"; key = "jk"; action = "<Esc>"; }
      { mode = "n"; key = "<leader>"; action = "<Nop>"; options.silent = true; }

      # navigating up/down/left/right to other split windows
      { mode = "n"; key = "<C-h>"; action = "<cmd>:wincmd h<cr>"; }
      { mode = "n"; key = "<C-j>"; action = "<cmd>:wincmd j<cr>"; }
      { mode = "n"; key = "<C-k>"; action = "<cmd>:wincmd k<cr>"; }
      { mode = "n"; key = "<C-l>"; action = "<cmd>:wincmd l<cr>"; }
      # fuzzy finders
      { mode = "n"; key = "<leader>f"; action = "<cmd>:Telescope git_files<cr>"; }
      { mode = "n"; key = "<leader>F"; action = "<cmd>:Telescope live_grep<cr>"; }
#   # force a format
      { mode = "n"; key = "<leader>d"; action = "<cmd>lua vim.lsp.buf.format({ async = false })<cr>"; }

      { mode = "n"; key = "<leader>h"; action = "<cmd>set nohlsearch<cr>"; }
      { mode = "n"; key = "<C-t><C-n>"; action = "<cmd>:wa <bar> TestNearest<CR>"; }
      { mode = "n"; key = "<C-t><C-f>"; action = "<cmd>:wa <bar> TestFile<CR>"; }
      { mode = "n"; key = "<C-t><C-s>"; action = "<cmd>:wa <bar> TestSuite<CR>"; }
      { mode = "n"; key = "<C-t><C-l>"; action = "<cmd>:wa <bar> TestLast<CR>"; }
      { mode = "n"; key = "<C-t><C-t>"; action = "<cmd>:wa <bar> TestLast<CR>"; }
      { mode = "n"; key = "<C-t><C-g>"; action = "<cmd>:wa <bar> TestVisit<CR>"; }

      { mode = "n"; key = "[d"; action = "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded' })<CR>"; options.silent = true; }
      { mode = "n"; key = "]d"; action = "<cmd>lua vim.diagnostic.goto_next({ border = 'rounded' })<CR>"; options.silent = true; }

      { mode = "n"; key = "[e"; action = "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded', severity = vim.diagnostic.severity.ERROR })<CR>"; options.silent = true; }
      { mode = "n"; key = "]e"; action = "<cmd>lua vim.diagnostic.goto_next({ border = 'rounded', severity = vim.diagnostic.severity.ERROR })<CR>"; options.silent = true; }

      { mode = "n"; key = "gl"; action = "<cmd>lua vim.diagnostic.setloclist()<CR>"; options.silent = true; }
      { mode = "n"; key = "<leader>q"; action = "<cmd>lua vim.diagnostic.open_float()<CR>"; options.silent = true; }

      { mode = "n"; key = ";"; action = ":"; }
      { mode = "v"; key = ";"; action = ":"; }
      { mode = "o"; key = ";"; action = ":"; }
    ];

    plugins.luasnip.enable = true;
    plugins.bufferline.enable = true;


#  plugins.nvim-cmp = {
#    enable = true;
#    snippet.expand = "luasnip";
#    sources = [
#      {
#        name = "nvim_lsp";
#      }
#      {
#        name = "buffer";
#      }
#      {
#        name = "luasnip";
#      }
#      {
#        name = "path";
#      }
#    ];
#  };

    plugins.none-ls = {
      enable = true;
      sources.formatting.prettier.enable = true;
      # sources.formatting.black.enable = true;
      # sources.diagnostics.shellcheck.enable = true;
    };

    plugins.lsp = {
      enable = true;

      servers.elixirls.enable = true;
      servers.elixirls.cmd = ["/Users/byron/workspace/koi/elixir-ls"];
      # servers.elixirls.installLanguageServer = false;
   
      servers.nixd.enable = true;
      servers.java_language_server.enable = true;
      # servers.denols.enable = true;
      servers.tsserver.enable = true;

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

    plugins.mini.enable = true;
    # plugins.mini.modules.icons = true;
    # plugins.mini.mockDevIcons = true;
    plugins.telescope.enable = true;
    plugins.fugitive.enable = true;

    plugins.treesitter.enable = true;
    plugins.treesitter.settings.highlight.enable = true;
    plugins.treesitter.settings.incremental_selection.enable = true;
    # plugins.treesitter.settings.ensure_installed = [
    plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      elixir
      bash
      cpp
      css
      go
      html
      java
      json
      latex
      lua
      make
      markdown
      nix
      python
      regex
      rust
      yaml
    ];

    plugins.vim-slime = {
      enable = true;
      settings.target = "tmux";
      settings.default_config = {
        socket_name = "default";
        target_pane = ":.2";
      };
    };

    plugins.which-key.enable = true;

    plugins.gitsigns = {
      enable = true;

      settings.on_attach = ''
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

    extraPlugins = [
      pkgs.vimPlugins.vim-vinegar
      pkgs.vimPlugins.vim-commentary
      pkgs.vimPlugins.vimux # "benmills/vimux"
      pkgs.vimPlugins.vim-test # "janko/vim-test"
      pkgs.vimPlugins.vim-tmux-navigator # christoomey/vim-tmux-navigator
      # colorschemes
      # pkgs.vimPlugins.vim-slime # jpalardy/vim-slime
      pkgs.vimPlugins.nvim-ts-context-commentstring # JoosepAlviste/nvim-ts-context-commentstring
      # darkplus
      randomcolorscheme
      pkgs.vimPlugins.vim-abolish # tpope/vim-abolish
    ];

    extraConfigVim = ''
     augroup _lsp
       autocmd!
       autocmd BufWritePre * lua vim.lsp.buf.format({ async = false })
     augroup end

     autocmd BufRead,BufNewFile *.livemd set filetype=markdown

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
        ["C"] = { "<cmd>lua require('random-colorscheme').set()<CR>:colorscheme<cr>", "Random Colorscheme" },
        ["\""] = { "<cmd>Telescope registers<cr>", "Registers" },

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
          f = { "<cmd>lua vim.lsp.buf.format({ async = false })<cr>", "Format" },
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
        mode = {"n"}
      };

      require("which-key").register(mappings, opts);
    '';
        # prefix = "<leader>",
        # buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
        # silent = true, -- use `silent` when creating keymaps
        # noremap = true, -- use `noremap` when creating keymaps
        # nowait = true, -- use `nowait` when creating keymaps


  };

  # https://github.com/nix-community/nixvim/issues/97
}
