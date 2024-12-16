{ ... }: {
    nix.settings = {
      builders-use-substitutes = true;
      # extra substituters to add
      extra-substituters = [
      ];

      extra-trusted-public-keys = [
      ];
    };
}
