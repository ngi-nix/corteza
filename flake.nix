{
  # Stolen/borrowed from Corteza forums: Blog post: https://forum.cortezaproject.org/t/nix-custom-build-auth-callback-path-returning-404/252/2
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    dream2nix.url = "github:nix-community/dream2nix";

    server.url = "github:cortezaproject/corteza-server";
    server.flake = false;

    compose.url = "github:cortezaproject/corteza-webapp-compose";
    compose.flake = false;

    workflow-src.url = "github:cortezaproject/corteza-webapp-workflow";
    workflow-src.flake = false;

    one.url = "github:cortezaproject/corteza-webapp-one";
    one.flake = false;

    admin-src.url = "github:cortezaproject/corteza-webapp-admin/2022.3.4";
    admin-src.flake = false;
  };

  outputs = { self, nixpkgs, admin-src, dream2nix, ... }@inputs:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      system = "x86_64-linux";
    in
    {
      packages.x86_64-linux = with pkgs;
        let
          meta = with lib; {
            description = "Corteza is the only 100% free, open-source, standardized and enterprise-grade Low-code platform";
            homepage = "https://cortezaproject.org/";
            license = licenses.asl20;
            # maintainers = [ maintainers. ];
          };
          version = "2022.3.4";
          params = { inherit meta version server one admin compose workflow inputs; };
          server = pkgs.callPackage ./server params;

          admin = import ./admin/default.nix {inherit dream2nix system pkgs admin-src; };
          
          workflow = import ./workflow/default.nix {inherit dream2nix system pkgs; };

          corteza = pkgs.callPackage ./corteza params;

          # privacy app missing
          # reporter app missing
          # discovery app missing
        in
        {
          inherit server admin corteza;
        };
      devShells.x86_64-linux.default = pkgs.mkShell { };
      defaultPackage.x86_64-linux = self.packages.x86_64-linux.corteza;
    };
}
