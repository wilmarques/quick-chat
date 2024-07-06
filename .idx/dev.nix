{ pkgs, ... }: {

  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"

  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.zulu11
  ];

  # Sets environment variables in the workspace
  env = {
    SOME_ENV_VAR = "hello";
  };

  # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
  idx.extensions = [
    "dart-code.flutter"
    "dart-code.dart-code"
    "editorconfig.editorconfig"
    "ms-azuretools.vscode-docker"
    "redhat.java"
    "vscjava.vscode-java-debug"
    "DavidAnson.vscode-markdownlint"
  ];

  # # Enable previews and customize configuration
  # idx.previews = {
  #   enable = true;
  #   # previews = {
  #   #   "Flutter" = {
  #   #     command = "${pkgs.flutter313}/bin/flutter";
  #   #     args = [ "run" ];
  #   #   };
  #   # };
  # };

}
