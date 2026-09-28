{ stdenv, fetchurl, autoPatchelfHook, lib, ... }:
stdenv.mkDerivation {
	version = "alpha-9";
	pname = "porffor";
	name = "porffor";

	src = fetchurl {
		url = "https://github.com/CanadaHonk/porffor/releases/download/alpha-9/porffor-linux-x64.tar.gz";
		sha256 = "sha256-bJEYn2Dr/AmXFYriVSUP0pct5j2cUYHNFrb0qp6dCoU=";
	};

	nativeBuildInputs = [
		autoPatchelfHook
	];

	sourceRoot = ".";
	dontBuild = true;
	installPhase = ''
		mkdir -p $out/bin
		runHook preInstall
		install -m755 -D porf $out/bin/porf
		runHook postInstall
	'';

	meta = with lib; {
		homepage = "https://porffor.dev";
		platforms = platforms.linux;
	};
}
