{ stdenv, version, meta, server, one, admin, compose, workflow, ... }:
stdenv.mkDerivation
rec {
  pname = "corteza";
  inherit version meta;
  src = ./.;
  installPhase = ''
    mkdir -p $out/webapp/admin $out/webapp/compose $out/webapp/workflow
    cp -r ${server}/* $out
    tar -xzmokf ${one} --directory=$out/webapp
    tar -xzmokf ${admin} --directory=$out/webapp/admin
    tar -xzmokf ${compose} --directory=$out/webapp/compose
    tar -xzmokf ${workflow} --directory=$out/webapp/workflow
  '';
}

