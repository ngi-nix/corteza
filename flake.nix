{
  # Stolen/borrowed from Corteza forums: Blog post: https://forum.cortezaproject.org/t/nix-custom-build-auth-callback-path-returning-404/252/2
  description = "A very basic flake";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs";
      dream2nix.url = "github:nix-community/dream2nix";

      server.url = "github:cortezaproject/corteza-server";
      server.flake = false;

      compose-src.url = "github:cortezaproject/corteza-webapp-compose/2022.3.4";
      compose-src.flake = false;

      workflow-src.url = "github:cortezaproject/corteza-webapp-workflow/2022.3.4";
      workflow-src.flake = false;

      one-src.url = "github:cortezaproject/corteza-webapp-one/2022.3.4";
      one-src.flake = false;

      admin-src.url = "github:cortezaproject/corteza-webapp-admin/2022.3.4";
      admin-src.flake = false;
    };

  outputs = { self, nixpkgs, admin-src, dream2nix, workflow-src, compose-src, one-src, ... }@inputs:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      system = "x86_64-linux";
      mergeFlakes = with builtins; foldl' (a: b: a // b.packages.x86_64-linux) { };
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

          corteza = pkgs.callPackage ./corteza params;

          # privacy app missing
          # reporter app missing
          # discovery app missing
        in
        {
          inherit server corteza;
        } // mergeFlakes [
          (import ./admin/default.nix { inherit dream2nix system pkgs admin-src; })
          (import ./workflow/default.nix { inherit dream2nix system pkgs workflow-src; })
          (import ./compose/default.nix { inherit dream2nix system pkgs compose-src; })
          (import ./one/default.nix { inherit dream2nix system pkgs one-src; })
        ];
      devShells.x86_64-linux.default = pkgs.mkShell { };
      defaultPackage.x86_64-linux = self.packages.x86_64-linux.corteza;
    };
}
