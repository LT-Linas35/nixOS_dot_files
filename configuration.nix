
{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];



  nix.settings.system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-skylake" ];
#£  nixpkgs.localSystem = {
#    system = "x86_64-linux";
#    gcc.arch = "skylake";
#    extraPackages = pkgs: [ pkgs.llvmPackages.latest ];
#  };

#  nix.buildMachines = [
#    {
#      hostName = "localhost";
#      system = "x86_64-linux";
#      maxJobs = 12;
#      supportedFeatures = [ "nixarch-skylake" ];
#      mandatoryFeatures = [ "gccarch-skylake" ];
#    }
#  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_lqx;

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "linas" ];



  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Vilnius";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.displayManager.sddm.wayland.enable = true;



  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  console.keyMap = "uk";

  services.printing.enable = false;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

  };


  users.users.linas = {
    isNormalUser = true;
    description = "Linas M.";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [
      kdePackages.kate
      transmission_4-gtk
    ];
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "linas";

  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    pkgs.vscodium
    pkgs.google-chrome
    pkgs.git
    pkgs.oh-my-zsh
    pkgs.zsh
    pkgs.zsh-completions
    pkgs.zsh-powerlevel10k
    pkgs.zsh-syntax-highlighting
    pkgs.zsh-history-substring-search
    pkgs.libva-utils
    pkgs.vdpauinfo
    pkgs.vulkan-tools
    pkgs.vulkan-validation-layers
    pkgs.libvdpau-va-gl
    pkgs.egl-wayland
    pkgs.wgpu-utils
    pkgs.mesa
    pkgs.libglvnd
    pkgs.nvtop
    pkgs.nvitop
    pkgs.libGL
    grim
    slurp
    wl-clipboard
    mako
    pkgs.lutris
  ];

  services.gnome.gnome-keyring.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };


  system.stateVersion = "24.04";

  services.xserver.videoDrivers = ["nvidia"];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };


  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    #package = pkgs.unstable.linuxPackages.nvidiaPackages.latest;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };

   virtualisation.virtualbox.host.enable = true;
   users.extraGroups.vboxusers.members = [ "linas" ];
   virtualisation.virtualbox.host.enableExtensionPack = true;


#  nixpkgs.config.nvidia.acceptLicense = true;

#  hardware.nvidia = {
#    package = config.boot.kernelPackages.nvidiaPackages.latest;
#    modesetting.enable = true;
#		powerManagement.enable = true;
#		powerManagement.finegrained = false;
#    open = false;
#    nvidiaSettings = true;
#  };
}
