let
	nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-26.05";
	pkgs = import nixpkgs { config = {}; overlays = []; };
in
{
	sv = pkgs.callPackage ./sv.nix { };
}
