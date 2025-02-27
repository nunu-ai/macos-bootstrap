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
