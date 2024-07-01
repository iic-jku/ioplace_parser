{
  antlr4_10,
  black,
  lib,
  nix-gitignore,
  buildPythonPackage,
  poetry-core,
  setuptools,
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
in buildPythonPackage {
  name = "ioplace_parser";
  version = (builtins.fromTOML (builtins.readFile ./pyproject.toml)).tool.poetry.version;
  format = "pyproject";

  src = nix-gitignore.gitignoreSourcePure ./.gitignore ./.;
  
  nativeBuildInputs = [
    poetry-core
    antlr4_10
  ];

  propagatedBuildInputs = [
    antlr4_10-python3-runtime
  ];
  
  nativeCheckInputs = [
    pytest
    black
    coverage
  ];

  preBuild = "make antlr";
  checkPhase = "pytest";
}
