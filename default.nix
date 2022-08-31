{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchurl
}:
let
  meta = with lib; {
    description = "Corteza is the only 100% free, open-source, standardized and enterprise-grade Low-code platform";
    homepage = "https://cortezaproject.org/";
    license = licenses.asl20;
    # maintainers = [ maintainers. ];
  };
  version = "2022.3.4";
  server = buildGoModule rec {
    pname = "corteza-server";
    inherit version meta;
    src = fetchFromGitHub {
      owner = "cortezaproject";
      repo = pname;
      rev = "${version}";
      sha256 = "sha256-e+LBQGJN0mAFrEQ1zxh1Q3HhPUoFHfV0sx0MnAF5P8k=";
    };
    vendorSha256 = null;
    subPackages = [ "cmd/corteza" ];
    postInstall = ''
      cp -r provision $out
      rm -f $out/provision/README.adoc $out/provision/update.sh
      cp -r auth/assets $out/auth
    '';
    doCheck = false;
  };
  releasesURL = "https://releases.cortezaproject.org/files";
  webapp = app: "${releasesURL}/corteza-webapp-${app}-${version}.tar.gz";
  admin = fetchurl { url = webapp "admin"; sha256 = "sha256-IUGj++SU8mqXLfOhlJN12Q5H4zw9Pw3Lv+qP3JNL/bA="; };
  compose = fetchurl { url = webapp "compose"; sha256 = "sha256-2DPzWmoFfnIfCi/VLATyD4DfzMx+NkRwqGPOZoOxFrg="; };
  workflow = fetchurl { url = webapp "workflow"; sha256 = "sha256-VuViU2twRMx0/bpamUZUt16XanK6rmHRaa8pm4WVTus="; };
  one = fetchurl { url = webapp "one"; sha256 = "sha256-M4R5aaDh9bBkjlCJA7jOUwgFGyzrPhMbAIBCk68EtTg="; };
in
stdenv.mkDerivation rec {
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
