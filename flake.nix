{
  description = "A devshell for confluence_benchmark";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    fix-python.url = "github:GuillaumeDesforges/fix-python";
  };

  outputs = { self, nixpkgs, flake-utils, fix-python }: flake-utils.lib.eachDefaultSystem (system:
    let pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.default = pkgs.mkShell {
        name = "confluence-benchmark-env";
        buildInputs = with pkgs; [
          awscli2
          python311
          poetry
        ];
        shellHook = ''
          export AWS_DEFAULT_REGION="us-east-1"
          export AWS_REGION="us-east-1"
          # awscli2 pollutes PYTHONPATH
          # https://github.com/NixOS/nixpkgs/issues/108516
          unset PYTHONPATH
          poetry env use "${pkgs.python311}/bin/python"
          poetry install --sync --with=dev
          source "$(poetry env info --path)/bin/activate"
          [ -f /etc/NIXOS ] && ${fix-python}/fix-python --venv "$(poetry env info --path)"
        '';
      };
    }
  );
}
