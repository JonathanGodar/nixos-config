{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          python3
          # python3Packages.jupyter
          # python3Packages.ipykernel
          # python3Packages.numpy
          # python3Packages.notebook
          # python3Packages.matplotlib

          python3Packages.ipykernel
          python3Packages.jupyterlab
          python3Packages.pyzmq # Adding pyzmq explicitly
          # python3Packages.venvShellHook
          python3Packages.pip
          python3Packages.notebook
          python3Packages.numpy
          python3Packages.pygame
          python3Packages.pandas
          python3Packages.requests
          python3Packages.matplotlib
          python3Packages.scipy
          python3Packages.pyqt6
        ];
      };
    };
}
