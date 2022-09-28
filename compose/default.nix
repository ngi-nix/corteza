{ compose-src, dream2nix, system, pkgs }:
dream2nix.lib.makeFlakeOutputs
  {
    systems = [ system ];
    config.projectRoot = compose-src;
    source = compose-src;

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
          };
      };
    };
  }
