{
  # Proof-checking toolchain, derived from jasmin-nist.opam via opam-nix:
  # the opam file (jasmin version + easycrypt pin-depends) stays the single
  # source of truth. The easycrypt pin tracks a branch, so evaluation needs
  # --impure (the fetch follows the branch HEAD, like `opam update` does):
  #
  #     nix develop --impure -c make -C proofs JOBS=10
  #
  description = "Jasmin implementations and EasyCrypt proofs of ML-KEM and ML-DSA";

  inputs = {
    opam-nix.url = "github:tweag/opam-nix";
    nixpkgs.follows = "opam-nix/nixpkgs";
    flake-utils.follows = "opam-nix/flake-utils";
    # opam-nix's own opam-repository snapshot predates jasmin 2026.03.1;
    # pin our own (advance with `nix flake update opam-repository`).
    opam-repository = {
      url = "github:ocaml/opam-repository";
      flake = false;
    };
  };

  outputs =
    { self, opam-nix, nixpkgs, flake-utils, opam-repository }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        on = opam-nix.lib.${system};

        # OCaml version shared with the workflows (see .ocaml-version).
        ocamlVersion =
          nixpkgs.lib.removeSuffix "\n" (builtins.readFile ./.ocaml-version);

        # One derivation per opam package (jasmin, easycrypt, why3, ...);
        # depexts are mapped to nixpkgs automatically.
        scope' = on.buildOpamProject' { repos = [ opam-repository ]; } ./. {
          ocaml-base-compiler = ocamlVersion;
        };

        # The conf-<lib>-paths packages (mlgmpidl/apron, in jasmin's chain)
        # probe the system for a library's include/lib directories and write
        # them to a small <pkg>.config file. The probe cannot work under nix
        # (it walks the compiler's builtin search dirs, which never contain
        # store paths) — but under nix the answer is not something to
        # discover, it is an input: write the .config directly.
        ezConfProbe = libname: p: ''
          runHook preBuild
          {
            printf 'opam-version: "2.0"\n'
            printf 'variables {\n'
            printf '  prefix: "%s"\n' "${p.out}"
            printf '  incdir: "%s"\n' "${p.dev}/include"
            printf '  libdir: "%s"\n' "${p.out}/lib"
            printf '}\n'
          } > conf-${libname}-paths.config
          runHook postBuild
        '';

        # Fixups for opam's conf-* probe packages under opam-nix.
        scope = scope'.overrideScope (
          final: prev: {
            conf-git = prev.conf-git.overrideAttrs (a: {
              nativeBuildInputs = (a.nativeBuildInputs or [ ]) ++ [ pkgs.git ];
            });
            conf-gmp-paths = prev.conf-gmp-paths.overrideAttrs (_: {
              buildPhase = ezConfProbe "gmp" pkgs.gmp;
            });
            conf-mpfr-paths = prev.conf-mpfr-paths.overrideAttrs (_: {
              buildPhase = ezConfProbe "mpfr" pkgs.mpfr;
            });
            # Same fixups as EasyCrypt's own flake: the codesign shim for
            # dune's macOS link step, and a lib/easycrypt symlink so the
            # binary finds its theories and the runtest command at the
            # opam-style location.
            easycrypt = prev.easycrypt.overrideAttrs (a: {
              nativeBuildInputs =
                (a.nativeBuildInputs or [ ])
                ++ nixpkgs.lib.optionals pkgs.stdenv.isDarwin [ pkgs.darwin.sigtool ];
              postInstall = ''
                ln -s "$out/lib/ocaml/$opam__ocaml__version/site-lib/easycrypt" $out/lib/
              '';
            });
          }
        );
        # proofs/*/easycrypt.project pins Z3@4.13; nixpkgs dropped that
        # series, so build the current recipe at the 4.13.4 tag.
        z3 = pkgs.z3.overrideAttrs (_: {
          version = "4.13.4";
          name = "z3-4.13.4";
          src = pkgs.fetchFromGitHub {
            owner = "Z3Prover";
            repo = "z3";
            rev = "z3-4.13.4";
            hash = "sha256-8hWXCr6IuNVKkOegEmWooo5jkdmln9nU7wI8T882BSE=";
          };
        });
        # Under opam, the jasmin package drops a jasmin.conf into easycrypt's
        # config site (shared prefix); the nix store has no shared prefix, so
        # expose the Jasmin eclib through an easycrypt.conf on XDG_CONFIG_DIRS
        # instead (read-only; why3.conf stays in the user's XDG home).
        ecJasminConf = pkgs.writeTextDir "easycrypt/easycrypt.conf" ''
          [general]
          idirs=Jasmin:${scope.jasmin}/lib/easycrypt/jasmin
        '';
      in
      {
        packages.default = scope.jasmin-nist;

        # Toolchain for the cycle benchmarks: jasminc and a pinned C
        # toolchain (mkShell's stdenv cc), no EasyCrypt/provers — keeps the
        # bench closure small and the benchmark compiler pinned by flake.lock.
        devShells.bench = pkgs.mkShell {
          packages = [
            scope.jasmin
            pkgs.python3
            pkgs.gnumake
            pkgs.git
          ];
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ scope.jasmin-nist ];
          # The EasyCrypt commit the shell was built from (the pin follows a
          # branch, and a nix build embeds no git hash in the binary); read by
          # scripts/timing-report-to-json.py.
          EASYCRYPT_REV = scope.easycrypt.src.rev or "unknown";
          shellHook = ''
            export XDG_CONFIG_DIRS="${ecJasminConf}''${XDG_CONFIG_DIRS:+:$XDG_CONFIG_DIRS}"
          '';
          packages = [
            # SMT provers are not opam packages; versions must satisfy the
            # prefix pins in proofs/*/easycrypt.project (Z3@4.13, CVC5@1.3).
            z3
            pkgs.cvc5
            (pkgs.python3.withPackages (ps: [ ps.pyyaml ]))
          ];
        };
      });
}
