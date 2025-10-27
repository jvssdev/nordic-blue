{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}:
let
  username = "joaov";
  userDescription = "João Víctor";
  homeDirectory = "/home/${username}";
  hostName = "nordic-blue";
  timeZone = "America/Sao_Paulo";
in
{
  imports = [
    ./hardware-configuration.nix
    ./user.nix
    ../../modules/intel-drivers.nix
    inputs.home-manager.nixosModules.default
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    kernelParams = [
      "intel_pstate=active"
      "i915.enable_psr=1" # Panel self refresh
      "i915.enable_fbc=1" # Framebuffer compression
      "i915.enable_dc=2" # Display power saving
      "nvme.noacpi=1" # Helps with NVME power consumption
    ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
    };
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };

  networking = {
    hostName = hostName;
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    # firewall = {
    #   allowedTCPPorts = [ 8003 ];
    # };
    # firewall = {
    #   checkReversePath = "loose";
    # };
  };

  time.timeZone = timeZone;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  stylix = {
    enable = true;
    base16Scheme = {
      base00 = "2E3440";
      base01 = "3B4252";
      base02 = "434C5E";
      base03 = "4C566A";
      base04 = "D8DEE9";
      base05 = "E5E9F0";
      base06 = "ECEFF4";
      base07 = "8FBCBB";
      base08 = "BF616A";
      base09 = "D08770";
      base0A = "EBCB8B";
      base0B = "A3BE8C";
      base0C = "88C0D0";
      base0D = "81A1C1";
      base0E = "B48EAD";
      base0F = "5E81AC";
    };
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };

  virtualisation = {
    docker = {
      enable = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        runAsRoot = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  programs = {
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
    };
    firefox.enable = false;
    dconf.enable = true;
    fuse.userAllowOther = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = true;
    users.${username} = {
      isNormalUser = true;
      description = userDescription;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [
        #thunderbird
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    nano
    zed-editor

    inputs.zen-browser.packages."${system}".default

    go
    go-blueprint
    go-migrate
    air
    lua
    python3
    python3Packages.pip
    uv
    clang
    zig
    rustup
    fnm
    gcc
    openssl
    nodePackages_latest.live-server

    uv

    git
    lazygit
    lazydocker
    nixfmt-rfc-style
    meson
    ninja

    wget
    starship
    zoxide
    fzf

    inputs.ghostty.packages.${pkgs.system}.default

    yazi
    p7zip
    mpc
    mpd
    mpd-mpris
    playerctl
    rmpc

    gopls
    golangci-lint

    btop
    rclone

    anydesk

    qbittorrent

    pulseaudio
    pavucontrol
    ffmpeg
    mpv

    swww
    imv

    libgcc
    lxqt.lxqt-policykit
    libnotify
    ripgrep
    bat
    brightnessctl
    virt-viewer
    swappy
    appimage-run
    playerctl
    nh

    grim
    slurp
    waybar
    fuzzel
    mako
    wl-clipboard

    libvirt
    qemu
    virt-manager
    spice
    spice-gtk
    spice-protocol
    OVMF

    cliphist

    fastfetch

    networkmanagerapplet

    libsForQt5.qt5.qtgraphicaleffects
  ];

  environment.etc."sddm/wayland-sessions/river.desktop".text = ''
    [Desktop Entry]
    Name=River
    Comment= a dynamic tiling Wayland compositor with flexible runtime config
    DesktopNames=river
    Exec=/usr/bin/startriver
    Type=Application
  '';

  fonts.packages = with pkgs; [
    noto-fonts-emoji
    fira-sans
    roboto
    noto-fonts-cjk-sans
    font-awesome
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
  };

  services = {
    xserver = {
      enable = false;
      xkb = {
        layout = "br";
        variant = "";
      };
      videoDrivers = [ "modesetting" ];
    };
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "nord-sddm";
    };
    # greetd = {
    #   enable = true;
    #   vt = 3;
    #   settings = {
    #     default_session = {
    #       user = username;
    #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
    #     };
    #   };
    # };
    logind = {
      extraConfig = ''
        HandlePowerKey=suspend
      '';
    };
    # supergfxd.enable = true;
    # asusd = {
    #   enable = true;
    #   enableUserService = true;
    # };
    # tailscale = {
    #   enable = true;
    #   useRoutingFeatures = "client";
    # };
    # ollama = {
    #   enable=true;
    #   acceleration = "cuda";
    # };

    libinput.enable = true;
    upower.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    flatpak.enable = false;
    printing = {
      enable = false;
      drivers = [ pkgs.hplipWithPlugin ];
    };
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = true;
    syncthing = {
      enable = true;
      user = username;
      dataDir = homeDirectory;
      configDir = "${homeDirectory}/.config/syncthing";
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    pulseaudio.enable = false;
  };

  # powerManagement.powertop.enable = true;

  systemd.services = {
    # flatpak-repo = {
    #   path = [ pkgs.flatpak ];
    #   script = "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo";
    # };
    libvirtd = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      requires = [ "virtlogd.service" ];
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable = true;
  };

  services.blueman.enable = true;

  security = {
    rtkit.enable = true;
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        })
      '';
    };
    pam.services.swaylock.text = "auth include login";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # substituters = [ "https://hyprland.cachix.org" ];
      # trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  programs.river.enable = true;

  xdg.mime.defaultApplications = {
    "x-scheme-handler/http" = "zen.desktop";
    "x-scheme-handler/https" = "zen.desktop";
    "x-scheme-handler/chrome" = "zen.desktop";
    "text/html" = "zen.desktop";
    "application/x-extension-htm" = "zen.desktop";
    "application/x-extension-html" = "zen.desktop";
    "application/x-extension-shtml" = "zen.desktop";
    "application/x-extension-xhtml" = "zen.desktop";
    "application/xhtml+xml" = "zen.desktop";

    "inode/directory" = "org.kde.thunar.desktop";

    "text/plain" = "nvim.desktop";

    "x-scheme-handler/terminal" = "ghostty.desktop";

    "video/quicktime" = "mpv.desktop";
    "video/x-matroska" = "mpv.desktop";

    "application/pdf" = "org.pwmt.zathura.desktop";

    "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";
    "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";

    "x-scheme-handler/about" = "zen.desktop";
    "x-scheme-handler/unknown" = "zen.desktop";

    "image/png" = "imv.desktop";
    "image/jpeg" = "imv.desktop";
    "image/gif" = "imv.desktop";
    "image/webp" = "imv.desktop";
    "image/svg+xml" = "imv.desktop";
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.${username} = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  system.stateVersion = "25.05";
}
