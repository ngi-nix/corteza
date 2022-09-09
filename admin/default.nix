{ yarn2nix-moretea
, fetchFromGitHub
, version
, meta
, inputs
, ...
}:
yarn2nix-moretea.mkYarnPackage {
  src = inputs.admin;
  yarnLock = ./yarn.lock;
  buildPhase = ''
    yarn build
  '';
  distPhase = ":";
  installPhase = "ls -hal";
}
