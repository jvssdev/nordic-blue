{
  config,
  pkgs,
  ...
}:
let
  userName = "joaov";
  homeDirectory = "/home/${userName}";
  stateVersion = "25.05";
in
{
  home = {
    username = userName;
    homeDirectory = homeDirectory;
    stateVersion = stateVersion;
    file = {
      ".config/river".source = ../../dotfiles/.config/river;
      ".config/mako".source = ../../dotfiles/.config/mako;
      ".config/rmpc".source = ../../dotfiles/.config/rmpc;
      ".config/mpd".source = ../../dotfiles/.config/mpd;
      ".config/zed".source = ../../dotfiles/.config/zed;
      ".config/wleave/icons".source = ../../config/wleave;
      ".zshrc".source = ../../dotfiles/.config/zsh/.zshrc;
      #".gitconfig".source = ../../dotfiles/.gitconfig;
      ".local/bin/wallpaper".source = ../../dotfiles/.local/bin/wallpaper;
      ".config/fastfetch".source = ../../dotfiles/.config/fastfetch;
      ".config/btop".source = ../../dotfiles/.config/btop;
      ".config/lazygit".source = ../../dotfiles/.config/lazygit;
      #".config/mpv".source = ../../dotfiles/.config/mpv;
      ".config/waybar".source = ../../dotfiles/.config/waybar;
      ".config/yazi".source = ../../dotfiles/.config/yazi;
      ".config/ghostty".source = ../../dotfiles/.config/ghostty;
      ".config/starship.toml".source = ../../dotfiles/.config/starship.toml;
      ".zen" = {
        source = ../../dotfiles/.zen;
        recursive = true;
      };

      ".config/zathura".source = ../../dotfiles/.config/zathura;
    };
    sessionVariables = {
      # Default applications
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "ghostty";
      BROWSER = "zen";
      # XDG Base Directories
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
      # PATH = "$HOME/.local/bin:$HOME/go/bin:$PATH";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "River";
      XDG_SESSION_DESKTOP = "River";
      LC_ALL = "en_US.UTF-8";
    };
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/go/bin"
    ];
  };

  imports = [
    ../../config/wleave.nix
  ];

  programs = {
    home-manager.enable = true;

    zathura = {
      enable = true;
      package = pkgs.zathura.override {
        useMupdf = false; # Use poppler instead of mupdf
      };
    };
  };

  stylix.targets.waybar.enable = false;

  gtk = {
    iconTheme = {
      name = "Nordzy-dark";
      package = pkgs.nordzy-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme.name = "qtct";
  };

  # services.hypridle = {
  #   settings = {
  #     general = {
  #       after_sleep_cmd = "hyprctl dispatch dpms on";
  #       ignore_dbus_inhibit = false;
  #       lock_cmd = "hyprlock";
  #     };
  #     listener = [
  #       {
  #         timeout = 900;
  #         on-timeout = "hyprlock";
  #       }
  #       {
  #         timeout = 1200;
  #         on-timeout = "hyprctl dispatch dpms off";
  #         on-resume = "hyprctl dispatch dpms on";
  #       }
  #     ];
  #   };
  # };
}
