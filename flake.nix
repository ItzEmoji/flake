
{
  description = "Dev shells for Python, C, and Java";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    # Define the architectures you want to support
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

    # A function that returns the devShells for a given system
    devShellsForSystem = { system, pkgs }: {
      # Python dev shell
      python = pkgs.mkShell {
        packages = with pkgs; [
          python3
          python3Packages.pip
          python3Packages.virtualenv
        ];

        shellHook = ''
          echo "Python development shell"
        '';
      };

      # C dev shell
      c = pkgs.mkShell {
        packages = with pkgs; [
          gcc
          gdb
          make
        ];

        shellHook = ''
          echo "C development shell"
        '';
      };

      # Java dev shell
      java = pkgs.mkShell {
        packages = with pkgs; [
          openjdk17
          maven
        ];

        shellHook = ''
          echo "Java development shell"
        '';
      };

      # Default dev shell (includes all)
      default = pkgs.mkShell {
        packages = with pkgs; [
          python3
          python3Packages.pip
          python3Packages.virtualenv
          gcc
          gdb
          make
          openjdk17
          maven
        ];

        shellHook = ''
          echo "Combined development shell"
        '';
      };
    };

  in {
    devShells = builtins.listToAttrs (map (system: {
      name = system;
      value = devShellsForSystem {
        system = system;
        pkgs = nixpkgs.legacyPackages.${system};
      };
    }) systems);
  };
}
