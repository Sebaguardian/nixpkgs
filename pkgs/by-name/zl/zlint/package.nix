{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  zlint,
}:

buildGoModule rec {
  pname = "zlint";
  version = "3.6.4";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = "zlint";
    tag = "v${version}";
    hash = "sha256-FFgBRuNvm4Cnjls9y+L256vMGGNu10x7Vh+V9HBon70=";
  };

  modRoot = "v3";

  vendorHash = "sha256-RX7B9RyNmEO9grMR9Mqn1jXDH5sgT0QDvdhXgY1HYtQ=";

  postPatch = ''
    # Remove a package which is not declared in go.mod.
    rm -rf v3/cmd/genTestCerts
  '';

  excludedPackages = [
    "lints"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = zlint;
    command = "zlint -version";
  };

  meta = with lib; {
    description = "X.509 Certificate Linter focused on Web PKI standards and requirements";
    longDescription = ''
      ZLint is a X.509 certificate linter written in Go that checks for
      consistency with standards (e.g. RFC 5280) and other relevant PKI
      requirements (e.g. CA/Browser Forum Baseline Requirements).
    '';
    homepage = "https://github.com/zmap/zlint";
    changelog = "https://github.com/zmap/zlint/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ baloo ];
  };
}
