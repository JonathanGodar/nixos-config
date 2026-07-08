{ inputs, ... }:
{
  flake.modules = {
    nixos.catppuccin =
      { ... }:
      {
        imports = [
          inputs.catppuccin.nixosModules.catppuccin
        ];

        catppuccin = {
          enable = true;
          autoEnable = false;

          flavor = "mocha";
          grub.enable = true;
          sddm.enable = true;
          tty.enable = true;
        };
      };

    homeManager.catppuccin =
      { pkgs, ... }:
      {
        imports = [
          inputs.catppuccin.homeModules.catppuccin
        ];

        gtk = {
          enable = true;
          theme = {
            package = pkgs.catppuccin-gtk;
            name = "Catppuccin-Mocha-Standard-Blue-Dark";
          };
        };

        catppuccin = {
          enable = true;
          autoEnable = false;

          atuin.enable = true;
          bat.enable = true;
          btop.enable = true;
          dunst.enable = true;
          eza.enable = true;
          firefox.enable = true;
          fzf.enable = true;
          ghostty.enable = true;
          # helix.enable = true;
          hyprland.enable = true;
          # hyprlock.enable = true;
          kitty.enable = true;
          lazygit.enable = true;
          nushell.enable = true;
          obsidian.enable = true;
          rofi.enable = true;
          sioyek.enable = true;
          starship.enable = true;
          thunderbird.enable = true;
          # tmux.enable = true;
          vicinae.enable = true;
          waybar.enable = true;
          yazi.enable = true;
          zellij.enable = true;
          # zsh-syntax-highlighting.enable = false;

          nvim.enable = false;
        };
      };
  };

}
