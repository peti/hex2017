# Haskell eXchange 2017

This docker image provides a development environment suitable for participating
inthe Nix workshop at [Haskell eXchange 2017]. The easiest way to use this
environment is to run the following commands:

    $ git clone git://github.com/basvandijk/nix-workshop.git
    $ docker run -it -v $PWD/nix-workshop:/root/workshop psimons/hex2017

This gives you a virtual machine with the following development tools installed
and ready for use:

* Nix 1.11.15
* Nixpkgs 17.09
* cabal2nix 2.5
* cabal-install 2.0.0.0
* stack 1.5.1
* GHC 8.0.2
* alex 3.2.2
* happy 1.19.7
* gcc 6.4.0

We have tested this functiality with docker version 17.09.0, but in all
likeliehood earlier version will work fine, too.

[Haskell eXchange 2017]: https://skillsmatter.com/conferences/8522-haskell-exchange-2017
