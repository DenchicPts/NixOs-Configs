{ pkgs, unstable, inputs, ... }:

let
  # spicetify + spotify из UNSTABLE
  spicePkgs =
    inputs.spicetify-nix.legacyPackages.${unstable.stdenv.system};
in
{
  programs.spicetify = {
    enable = true;

    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];

    theme = spicePkgs.themes.starryNight;
    colorScheme = "Base";
  };
}

