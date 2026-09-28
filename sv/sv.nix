{ stdenv, lib, fetchFromGitHub, nodejs_26, pnpm_10, ... }:
stdenv.mkDerivation {
	name = "sv";
	pname = "sv";
	version = "0.17.1";

	src = fetchFromGitHub {
		owner = "sveltejs";
		repo = "cli";
		rev = "d2b2f4dad30b9cb68a4193ce0c43b17d21349b70";
		sha256 = "0n4b0zjhrlnq3zjp7rvj7ic93hnxxnaxvxxqz4vicqw4jfwdkjvd";
	};

	sourceRoot = "./source";
	buildInputs = [ nodejs_26 pnpm_10 ];
	installPhase = ''
		mkdir -p $out/bin
		runHook preInstall
		pnpm i
		pnpm build
		ls
		runHook postInstall
	'';

	meta = with lib; {
		homepage = "https://svelte.dev";
		platforms = platforms.linux;
	};
}
