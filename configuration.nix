# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
    
  fileSystems."/" =
    { 
      options = [ "rw" "compress=zstd:1" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    };

  fileSystems."/home" =
    { 
      options = [ "rw" "compress=zstd:1" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    };

  fileSystems."/root" =
    { 
      options = [ "rw" "compress=zstd:1" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    };

  fileSystems."/persist" =
    { 
      options = [ "rw" "compress=zstd:1" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    };

  fileSystems."/nix" =
    { 
      options = [ "rw" "compress=zstd:1" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    };

  fileSystems."/.snapshots" =
    { 
      options = [ "rw" "compress=zstd:1" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    };

  fileSystems."/var/log" =
    { 
      options = [ "rw" "compress=zstd:1" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    };

  fileSystems."/var/lib/docker" =
    { 
      options = [ "rw" "compress=zstd:1" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    };

  fileSystems."/var/lib/libvirt/images" =
    { 
      options = [ "rw" "compress=zstd:1" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    };

  fileSystems."/var/lib/machines" =
    { 
      options = [ "rw" "compress=zstd:1" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    };

  fileSystems."/boot" =
    { 
      options = [ "fmask=0077" "dmask=0077" ];
    };
    
  fileSystems."/data/games" =
    { device = "/dev/disk/by-uuid/a510978d-7996-49fa-a930-d7255a9b021e";
      fsType = "btrfs";
      options = [ "noatime" "nofail" "x-systemd.device-timeout=10" ];
    };
    
  fileSystems."/data/media" =
    { device = "/dev/disk/by-uuid/a9836fc5-74a6-4bea-8846-94f2f86d6bf6";
      fsType = "btrfs";
      options = [ "noatime" "nofail" "x-systemd.device-timeout=10" ];
    };
    
  fileSystems."/data/downloads" =
    { device = "/dev/disk/by-uuid/ac03eb56-b5c7-497f-9041-6d910f34d2dd";
      fsType = "xfs";
      options = [ "noatime" "nofail" "x-systemd.device-timeout=10" ];
    };
    
  fileSystems."/data/storage" =
    { device = "/dev/disk/by-uuid/09924e80-eccb-4187-9489-7b03877c1b21";
      fsType = "xfs";
      options = [ "noatime" "nofail" "x-systemd.device-timeout=10" ];
    };
    
  fileSystems."/data/music" =
    { device = "/dev/disk/by-uuid/f3c9136f-92eb-406b-a5b0-137685f445ea";
      fsType = "xfs";
      options = [ "noatime" "nofail" "x-systemd.device-timeout=10" ];
    };
    
   fileSystems."/data/movies" =
    { device = "/dev/disk/by-uuid/6ed11e78-0e4d-4c64-a978-98f49747e768";
      fsType = "xfs";
      options = [ "noatime" "nofail" "x-systemd.device-timeout=10" ];
    };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Kernel
    # Linux Kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.kernelParams = [ 
    "quiet"
    "splash"
    "module_blacklist=pcspkr,snd_pcsp"
  ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  
  # Optimize storage and automatic scheduled GC running
  # If you want to run GC manually, use commands:
  # `nix-store --optimize` for finding and eliminating redundant copies of identical store paths
  # `nix-store --gc` for optimizing the nix store and removing unreferenced and obsolete store paths
  # `nix-collect-garbage -d` for deleting old generations of user profiles
  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kevin = {
    isNormalUser = true;
    description = "Kevin";
    extraGroups = [ "networkmanager" "wheel" "lp" "audio" "floppy" "cdrom" "video" "adm" "users" "kvm" "input" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJ1YsYIiU5Bgk4okuZP/EKNOIl3h1qGebemKX7q43Fs home" ];
    packages = with pkgs; [
      kdePackages.kate
      
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Flatpak support
  services.flatpak.enable = true;
  
  # Gaming
  programs.steam.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      pkgs.eza
      pkgs.thefuck
      pkgs.fd
      pkgs.fzf
      pkgs.ripgrep
      pkgs.zsh
      pkgs.git
      pkgs.neovim
      pkgs.wget
      pkgs.tmux
      pkgs.btop
      pkgs.btrfs-progs
      pkgs.xfsprogs
      pkgs.nvme-cli
      pkgs.wireguard-tools
      pkgs.libva-utils
      pkgs.vscode-with-extensions
      pkgs.brave
      pkgs.weechat
      pkgs.weechatScripts.highmon
      pkgs.weechatScripts.autosort
      pkgs.weechatScripts.url_hint
      pkgs.weechatScripts.weechat-otr
      pkgs.weechatScripts.weechat-notify-send
      pkgs.weechatScripts.weechat-matrix
      pkgs.kdePackages.konversation
      kdePackages.kdsoap-ws-discovery-client
      pkgs.kdePackages.flatpak-kcm
      pkgs.qbittorrent-nox
      pkgs.stremio
      pkgs.docker
      pkgs.docker-ls
      pkgs.docker-compose
      pkgs.docker
      pkgs.lazydocker
      pkgs.distrobox
      pkgs.boxbuddy
      pkgs.mpv
      pkgs.mpvScripts.modernx
      pkgs.python312
      pkgs.python312Packages.pip
      pkgs.element-desktop
      pkgs.xmrig
      pkgs.monero-gui
      pkgs.p2pool
      pkgs.protonup-qt
      pkgs.protontricks
      pkgs.gamemode
      pkgs.winePackages.staging
      pkgs.lutris
      pkgs.bottles
      pkgs.heroic
      pkgs.papirus-icon-theme
      pkgs.papirus-folders
      pkgs.vimix-cursors
      pkgs.vimix-icon-theme
      pkgs.vimix-gtk-themes
      pkgs.materia-kde-theme
      pkgs.materia-theme
      pkgs.qemu
      pkgs.libvirt
      pkgs.easyeffects
      pkgs.nerdfonts
      pkgs.btrfs-assistant
      pkgs.snapper
      pkgs.kitty
      pkgs.kitty-img
      pkgs.cmatrix
      pkgs.pipes-rs
      pkgs.rsclock
      pkgs.cava
      pkgs.figlet
      pkgs._64gram
      pkgs.vesktop
      pkgs.gpt4all
      pkgs.xwayland
      pkgs.supersonic-wayland
  ];

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      pkgs.amdvlk
      vaapiVdpau
      libvdpau-va-gl
      mesa
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiVdpau
      mesa
      libvdpau-va-gl
      pkgs.driversi686Linux.amdvlk
    ];
  };
  
  # AMD vulkan and vaapi
  hardware.opengl.driSupport = true;
  
  environment.variables.AMD_VULKAN_ICD = "RADV";
  
  # Configuration
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];    
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "kevin" ];
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
   networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable"; # Did you read the comment?

}
