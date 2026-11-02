{
  flake.templates = {
    python_sci = {
      path = ./_python_sci;
      description = "Python environment with nix-direnv and essential science packages";
    };

    python_nb = {
      path = ./_python_nb;
      description = "Python environment with nix-direnv and jupyter nb and essential science packages";
    };
  };
}
