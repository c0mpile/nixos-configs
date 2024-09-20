# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  fileSystems = {
    "/".options = [ "rw" "compress=zstd:3" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    "/home".options = [ "rw" "compress=zstd:3" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    "/root".options = [ "rw" "compress=zstd:3" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    "/nix".options = [ "rw" "compress=zstd:3" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    "/persist".options = [ "rw" "compress=zstd:3" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    "/.snapshots".options = [ "rw" "compress=zstd:3" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    "/var/log".options = [ "rw" "compress=zstd:3" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    "/var/lib/docker".options = [ "rw" "compress=zstd:3" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    "/var/lib/libvirt/images".options = [ "rw" "compress=zstd:3" "noatime" "ssd" "commit=120" "space_cache=v2" ];
    "/var/lib/machines".options = [ "rw" "compress=zstd:3" "noatime" "ssd" "commit=120" "space_cache=v2" ];
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

   # Networking
  networking.hostName = "thinkpad";
  networking.networkmanager.enable = true;

  # Time zone.
  time.timeZone = "America/New_York";

  # Locale
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

  # X11
  services.xserver.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Desktop environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;


  # Printing
  services.printing.enable = true;

  # Sound
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  # Touchpad
  services.libinput.enable = true;

  # User
  users.users.kevin = {
    isNormalUser = true;
    description = "Kevin";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      eza
      thefuck
      fd
      fzf
      zsh
      rustup
      nerd-font-patcher
      git
    ];
  };

  # Firefox
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    neovim
    wget
    tmux
    btop
    btrfs-progs
    xfsprogs
    nvme-cli
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  system.stateVersion = "24.05"; # Did you read the comment?

}
