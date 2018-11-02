FROM nixos/nix

# Update our installation to the current nixpkgs-unstable version.
RUN nix-channel --update \
 && nix-env -u --always \
 && nix-collect-garbage --delete-old \
 && nix-store --optimise

# Make bash and coreutils available in the system.
RUN nix-env -f "<nixpkgs>" -iA bash-completion bashInteractive coreutils \
 && echo >>/etc/shells /nix/var/nix/profiles/default/bin/bash \
 && echo >>/etc/profile 'test -z "${BASH_VERSION:-}" || . /etc/bash.bashrc' \
 && echo >>/etc/bash.bashrc BASH_COMPLETION_COMPAT_DIR=~/.nix-profile/etc/bash_completion.d \
 && echo >>/etc/bash.bashrc 'test -z "${PS1:-}" || . ~/.nix-profile/share/bash-completion/bash_completion' \
 && nix-store --optimise

# Just to be sure ...
RUN nix-store --verify --check-contents

# Set up a basic Haskell development environment.
RUN nix-env -f "<nixpkgs>" -iA  \
      cabal-install             \
      cabal2nix                 \
      curl                      \
      dnsutils                  \
      gcc                       \
      ghc                       \
      haskellPackages.alex      \
      haskellPackages.happy     \
      pkgconfig                 \
      stack                     \
      wget                      \
 && nix-store --optimise

# binutils and gcc conflict in 'as' even though both provide the exact same
# binary. :-( So we must perform priority magic to install both of them into
# the same environment. We need binutils for "ar", which is missing from gcc.
RUN eval nix-env --set-flag priority 0 $(nix-instantiate --eval "<nixpkgs>" -A gcc.name) \
 && nix-env -f "<nixpkgs>" -iA binutils                                                  \
 && nix-store --optimise

WORKDIR /root
CMD ["/nix/var/nix/profiles/default/bin/bash", "--login", "-i"]
