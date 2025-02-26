builders := "--builders 'ssh-ng://nunu@applin.local aarch64-darwin'"

build:
  nix build --keep-going {{builders}} .
