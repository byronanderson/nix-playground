pkgs:

let
  nixvimConfig = (import ./config) pkgs;
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
    ref = "nixos-23.05";
  });
in
{
  imports = [
    nixvim.homeManagerModules.nixvim
  ];
  /* The home.stateVersion option does not have a default and must be set */
  home.stateVersion = "18.09";
  /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
  /* pkgs.vim */
  home.packages = [
    pkgs.slack
    pkgs.thefuck
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      # Colors (Solarized Dark)
      # co-opted from https://github.com/alacritty/alacritty-theme/blob/0ea6ab87fed0d71dc9658dea95debc4124984607/themes/solarized_dark.yaml
      colors = {
        # Default colors
        primary = {
          background = "0x002b36";
          foreground = "0x839496";
        };

        # Normal colors
        normal = {
          black = "0x073642";
          red = "0xdc322f";
          green = "0x859900";
          yellow = "0xb58900";
          blue = "0x268bd2";
          magenta = "0xd33682";
          cyan = "0x2aa198";
          white = "0xeee8d5";
        };

        # Bright colors
        bright = {
          black = "0x002b36";
          red = "0xcb4b16";
          green = "0x586e75";
          yellow = "0x657b83";
          blue = "0x839496";
          magenta = "0x6c71c4";
          cyan = "0x93a1a1";
          white = "0xfdf6e3";
        };
      };
    };
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "vicmd";
    shellAliases = {
      gst = "git status";
      vim = "nvim";
      vi = "nvim";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      # theme = "robbyrussell";
      theme = "agnoster";
    };
  };

  programs.nixvim = nixvimConfig;
  # programs.nixvim.enable = true;

  programs.git = {
    enable = true;
    userName = "byronanderson";
    userEmail = "byronanderson32@gmail.com";
    aliases = {
      st = "status";
      co = "checkout";
      ci = "commit";
    };
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
    ];
    extraConfig = ''
      	# Some tweaks to the status line
      	set -g status-right "%b %d %Y | %l:%M %p"
      	set -g status-justify centre
      	set -g status-left-length 60

      	# Highlight active window
      	set -g window-status-current-style fg=red,bg=black,bold

      	set-option -g renumber-windows on

      	# reload config file (change file location to your the tmux.conf you want to use)
      	# bind r source-file /Users/jeffometer/.tmux.conf

      	# hjkl pane navigation
      	bind h select-pane -L
      	bind j select-pane -D
      	bind k select-pane -U
      	bind l select-pane -R

      	# Enable RGB colour if running in xterm(1)
      	set-option -sa terminal-overrides ",xterm*:Tc"

      	# work with upterm
      	set-option -ga update-environment " UPTERM_ADMIN_SOCKET"

      	# useful when pairing on different sized screens
      	set-window-option -g window-size smallest

      	# Change the default $TERM to xterm-256color
      	set -g default-terminal "xterm-256color"
      	# set -g default-terminal "xterm-256color"


      	# No bells at all
      	set -g bell-action none

      	# Use focus events
      	set -g focus-events on

      	# Keep current path when creating new panes/windows
      	bind '"' split-window -c "#{pane_current_path}"
      	bind % split-window -h -c "#{pane_current_path}"
      	bind c new-window -c "#{pane_current_path}"

      	# Use vim keybindings in copy mode
      	setw -g mode-keys vi

      	# Setup 'v' to begin selection as in Vim
      	bind-key -T copy-mode-vi v send -X begin-selection

      	bind-key -T copy-mode-vi y send -X copy-selection
      	bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"


      	# Update default binding of `Enter` to also use copy-pipe
      	unbind -T copy-mode-vi Enter
      	bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"

      	# Turn the mouse on
              set -g default-terminal "tmux-256color"
      	set -g mouse on
      	bind-key -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe "pbcopy"

      	# Set window notifications
      	setw -g monitor-activity off
      	set -g visual-activity off

      	# reduce esc time for vim
      	set -g escape-time 10

      	# Automatically set window title
      	setw -g automatic-rename
      	set -g pane-border-status top
      	setw -g pane-border-format ' #P #T : #{pane_current_path} '

      	# Display pane numbers longer
      	set display-panes-time 4000

      	# Display status bar messages longer
      	set-option -g display-time 2000

      	# Start pane and window numbering at 1 instead of 0
      	setw -g base-index 1
      	setw -g pane-base-index 1

      	# pane border colors
      	set -g pane-border-style fg='#31AFD4'
      	set -g pane-active-border-style fg='#FF007F'

      	# List of plugins
      	# set -g @plugin 'tmux-plugins/tpm'
      	# set -g @plugin 'tmux-plugins/tmux-sensible'
      	# set -g @plugin 'tmux-plugins/tmux-resurrect'
      	# set -g @plugin 'tmux-plugins/tmux-continuum'
      	# set -g @plugin 'christoomey/vim-tmux-navigator'
      	# TODO plugin doesn't currently detect lvim, so doing it manually here:
      	# is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
      	#     | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"
      	# bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      	# bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      	# bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      	# bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      	# tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      	# if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
      	#     "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      	# if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
      	#     "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      	bind-key -T copy-mode-vi 'C-h' select-pane -L
      	bind-key -T copy-mode-vi 'C-j' select-pane -D
      	bind-key -T copy-mode-vi 'C-k' select-pane -U
      	bind-key -T copy-mode-vi 'C-l' select-pane -R
      	bind-key -T copy-mode-vi 'C-\' select-pane -l
    '';
  };
}

