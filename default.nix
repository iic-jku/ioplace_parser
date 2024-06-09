{
  antlr4_10,
  black,
  lib,
  nix-gitignore,
  buildPythonPackage,
  pytest,
  coverage,
}:

let
  antlr4_10-python3-runtime = buildPythonPackage rec {
    pname = "antlr4-python3-runtime";
    inherit (antlr4_10.runtime.cpp) version src;

    sourceRoot = "source/runtime/Python3";
    
    doCheck = false;

    meta = with lib; {
      description = "Runtime for ANTLR";
      homepage = "https://www.antlr.org/";
      license = licenses.bsd3;
    };
  };
in buildPythonPackage rec {
  name = "ioplace_parser";

  version_file = builtins.readFile ./ioplace_parser/__version__.py;
  version_list = builtins.match ''.+''\n__version__ = "([^"]+)"''\n.+''$'' version_file;
  version = builtins.head version_list;

  src = nix-gitignore.gitignoreSourcePure ./.gitignore ./.;
  
  PIP_DISABLE_PIP_VERSION_CHECK = "1";

  nativeBuildInputs = [
    antlr4_10
    black
  ];
  
  nativeCheckInputs = [
    pytest
    coverage
  ];

  preBuild = "make antlr";
  checkPhase = "pytest";

  propagatedBuildInputs = [
    antlr4_10-python3-runtime
  ];
}
