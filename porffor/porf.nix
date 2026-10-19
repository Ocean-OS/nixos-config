{ stdenv, fetchurl, autoPatchelfHook, lib, ... }:
stdenv.mkDerivation {
	version = "alpha-17";
	pname = "porffor";
	name = "porffor";

	src = if (builtins.currentSystem == "x86_64-linux") then
		(fetchurl {
		    url = "https://github.com/CanadaHonk/porffor/releases/download/alpha-17/porffor-linux-x64.tar.gz";
                    sha256 = "sha256-B0N4/GkFvRYFc9YBdBvtmemVwKAP+dlrhA47nNMznZE=";
		})
		else
		(fetchurl {
			url = "https://github.com/CanadaHonk/porffor/releases/download/alpha-17/porffor-linux-arm64.tar.gz";
			sha256 = "sha256-BHk5NQq1SwLpGWlFFgIhK6n5I7UkvvB8m8h9ENi3dTY=";
		});

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
