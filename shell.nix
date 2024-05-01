{
  pkgs ? import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/23.11.tar.gz";
    sha256 = "1ndiv385w1qyb3b18vw13991fzb9wg4cl21wglk89grsfsnra41k";
  }) { }
}:
pkgs.mkShell {
  name = "confluence-benchmark-env";
  buildInputs = with pkgs; [
    awscli2
    python311
    poetry
  ];
  shellHook = ''
    export AWS_DEFAULT_REGION="us-east-1"
    export AWS_REGION="us-east-1"
    export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib";
    poetry env use "${pkgs.python311}/bin/python"
    poetry install --sync --with=dev
    source "$(poetry env info --path)/bin/activate"
    # this is necessary because awscli2 pollutes PYTHONPATH
    PYTHONPATH=""
  '';
}
