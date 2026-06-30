{
  description = "Jonathans NixOs config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
    };

    hyprcursor-phinger = {
      url = "github:jappie3/hyprcursor-phinger";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tmuxSessionX = {
      url = "github:omerxx/tmux-sessionx";
      inputs.nixpkgs.follows = "nixpkgs";
      flake = true;
    };

    # agenix = {
    #   url = "github:ryantm/agenix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    import-tree.url = "github:denful/import-tree";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # Used to lock dependencies of open tablet driver.
    nixpkgs-9f41.url = "github:nixos/nixpkgs/9f4128e00b0ae8ec65918efeba59db998750ead6";
    opentablet-ugee = {
      url = "github:Spencer-Sawyer/OpenTabletDriver/2b84e38477bd3a2e8790d96bdbf4bcaae8e49e80";
      flake = false;
    };

    rnote-export.url = "github:JonathanGodar/rnote_export";
  };

  outputs =
    {
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake {
      inherit inputs;
    } (inputs.import-tree ./flake_modules);
}
