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

    workflow.url = "github:cortezaproject/corteza-webapp-workflow";
    workflow.flake = false;

    one.url = "github:cortezaproject/corteza-webapp-one";
    one.flake = false;

    admin.url = "github:cortezaproject/corteza-webapp-admin/2022.3.4";
    #admin.url = git+file:./corteza-webapp-admin;
    admin.flake = false;
  };

  outputs = { self, nixpkgs, ... }@inputs:
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

          admin =
            let flake = inputs.dream2nix.lib.makeFlakeOutputs {
              systems = [ system ];
              config.projectRoot = ./.;
              source = ./.;

              # configure package builds via overrides
              # (see docs for override system below)
              packageOverrides = {
                # name of the package
                corteza-webapp-admin = {
                  # name the override
                  add-pre-build-steps =
                    let
                      git-tag = pkgs.writeScriptBin "git" ''
                        echo 2022.3.4
                      '';
                    in
                    {
                      # update attributes
                      buildInputs = old: old ++ [ git-tag ];

                      preBuild = "echo hello";
                    };
                };
              };
            };
          admin =
            let flake = inputs.dream2nix.lib.makeFlakeOutputs {
              systems = [ system ];
              config.projectRoot = ./.;
              source = ./.;

              # configure package builds via overrides
              # (see docs for override system below)
              packageOverrides = {
                # name of the package
                corteza-webapp-admin = {
                  # name the override
                  add-pre-build-steps =
                    let
                      git-tag = pkgs.writeScriptBin "git" ''
                        echo 2022.3.4
                      '';
                    in
                    {
                      # update attributes
                      buildInputs = old: old ++ [ git-tag ];

                      preBuild = "echo hello";
                    };
                };
              };
            };
            in
            flake.packages.x86_64-linux.default;
          workflow =
            let flake = inputs.dream2nix.lib.makeFlakeOutputs {
              systems = [ system ];
              config.projectRoot = ./.;
              source = workflow;

              # configure package builds via overrides
              # (see docs for override system below)
              packageOverrides = {
                # name of the package
                corteza-webapp-admin = {
                  # name the override
                  add-pre-build-steps =
                    let
                      git-tag = pkgs.writeScriptBin "git" ''
                        echo 2022.3.4
                      '';
                    in
                    {
                      # update attributes
                      buildInputs = old: old ++ [ git-tag ];

                      preBuild = "echo hello";
                    };
                };
              };
            };
            in
            flake.packages.x86_64-linux.workflow;

          corteza = pkgs.callPackage ./corteza params;

          # privacy app missing
          # reporter app missing
          # discovery app missing
        in
        {
          inherit server admin corteza workflow;
        };
      devShells.x86_64-linux.default = pkgs.mkShell { };
      defaultPackage.x86_64-linux = self.packages.x86_64-linux.corteza;
    };
}
