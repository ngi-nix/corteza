{ yarn2nix-moretea
, fetchFromGitHub
, version
, meta
, inputs
, ...
}:
yarn2nix-moretea.mkYarnPackage {
  src = inputs.admin;
}
