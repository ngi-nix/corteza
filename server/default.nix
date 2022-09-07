{ buildGoModule
, fetchFromGitHub
, version
, meta
,
}:

buildGoModule rec {
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
}
