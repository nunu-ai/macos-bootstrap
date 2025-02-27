{
  description = "Nunu.ai infrastructure MacOS bootstrap flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nix-darwin,
      ...
    }:
    let
      ssh-keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPy8CJvxjK1mPCHym+pBVoKeNNYRP9cfRY2k5yF7Io9s thomas@nunu.ai"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDSrAF5vXHXEqm5Kv8Nca2+EwkZCREbAoPqpOIB+Nl7teULpicfBpVGZ6XzJcKyaJjFt78YH7LNuE6D4I3t5oseEeWhX+JneTDFsp7JYNq02OMXKwxy1Bei63E0ArimVwGoWGXh9srt+hU72BC15saKD6I7VeXBcxYS6sjfszIj4s6ntGbiafeNtzSIOlo/DnrAToi7vjOCb3swUnibQTpI8NB5O1dLUdQuZ2dnY5otZgcxy3eZ1BjQxH9R5MrNvM7ub0l4X5knqLU2PFrtxKvkAC7M89k7pFCIoJoJsF14XR1HVIv4Cug31WrT4f/T3lt2vV7XFf5pS5g5b/l7qa8CyyFQs/ZMNK7/9B4xLt0vHGLdCVgiWJIy9DzTaCNXwpBlCsXcvJRaSs5GzWyldj3J5GijpbYTF1p1JuzvJY3IQx3fIbJGnAQHX8wHv54xUsiXg8iQjSk4YYsHDvki9X4MskULpIPqlF0Vl+dP8iTybcxDa1XLiltfKfByPWwJH0gDbxZs91/NMzfGfBcG9qObOK3wZrmlhk5xOpj+Y6Ok2aDRoHlIXWuvqkvl8fHTqVAochr8IcXdPjmAIsUQuAehg8Uv0MaBRT0erVKwbGVxst0IXQ+gi8L6VooG+eo1cHV2JQ3pQMP5g0Z15EzSEn2g3AIT571ZPIA0uK7Xhp03DQ== kyrill@nunu.ai"
      ];
      hostname = builtins.getEnv "NAME";
    in
    {
      darwinConfigurations."${hostname}" =
        let
          system = "aarch64-darwin";
        in
        nix-darwin.lib.darwinSystem {
          system = system;
          modules = [
            {
              networking.computerName = "${hostname}";
              networking.localHostName = "${hostname}";

              nix.settings.experimental-features = "nix-command flakes";
              nix.settings.trusted-users = [ "nunu" ];

              services.nix-daemon.enable = true;
              security.sudo.extraConfig = ''
                nunu ALL = (ALL) NOPASSWD: ALL
              '';

              services.openssh.enable = true;
              users.users.nunu.openssh.authorizedKeys.keys = ssh-keys;

              # Used for backwards compatibility, please read the changelog before changing.
              # $ darwin-rebuild changelog
              system.stateVersion = 5;
              nixpkgs.hostPlatform = system;
            }
          ];
        };
    };
}
