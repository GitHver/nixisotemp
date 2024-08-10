
# Overview

This guide is meant both for people new to Nix and Linux. No prior experience with Nix or Linux is expected nor any know-how of the internal workings of either, though I do assume that you heard of them and know what Linux and Nix are in it's most basic form. If you are already on NixOS and are struggling or are an experienced user and you're looking for a way to introduce your friends to Nix, then this guide is also for you.

### Why Nix?

One of the biggest question about ***Nix*** is why everyone who uses it praises it like some religious icon, but to answer your, you firstly need to understand what exactly ***Nix*** is, because "***Nix***" is actually three things: A package manager and repository (Nixpkgs), a programming language (NixLang), and a Linux distribution (NixOS).

[Nix-holy-trinity.png](https://media.hachyderm.io/media_attachments/files/111/071/129/711/481/861/original/cb247e197294b62a.png)

Nix, *the Linux distribution*, is really just the implementation of Nix, *the package manager*, on a larger scale, using Nix, *the programming language*, to configure the entire system, giving you the full ***Nix*** experience. So what is it that the ***Nix*** experience provides that can make even the most jumpy distro hopper settle down? It can become quite evident by going over the features nix provides:

- No dependency hell. Each package is built in isolation and has it's own dependencies.  When a package needs a new dependency, it simply gets rebuild with a symlink to the new dependency. No packages are removed. Any shared dependencies are just symlinks to the specific program, so no space is wasted.

- Plenty of packages. The nixpkgs repository is the largest package repository in the world, having over a 100'000 packages. You won't ever have to look at another package manager again!

- Stable. The stability of a package manager really boils down to two things: Whether or not its is running ustable/experimental builds of packages and how well the dependency conflicts are handled. Since Nix eliminates the latter, all you have to do to run a stable system is to use the stable channel that only uses verified working packages and Nix takes care of the rest.

- Bleeding edge. The nixpkgs-unstable is a rolling release channel that sports the most up-to-date packages in the Linux world, making sure you have access to the newest packages of everything. With flakes you can run both the stable and the unstable channels at the same time allowing you to use the stable for programs that cannot break and the unstable for programs that need the newest updates.

- Atomic updates. Updates in Nix either happen fully, or not at all. With each package being uniquely identified by their hash, new ones don't override old ones, so if something goes wrong during an update you aren't left with a broken system.

- Configuration files. The entirety of your system is configured through configuration files making managing your system incredibly easy and everything you do is self documenting, so no need to look up those commands you always forget, just read your code.

- Reproducible. Since everything about your system is stored in a single git repository, sharing your system with others is as easy as sending them zip file or a link to a remote repository. And with flakes, everything is guaranteed to be an exact replication, down to the exact commit of each package.

- Rollbacks. With Nix you can rollback to previous configurations, meaning that if an update contains a broken package or an experimental change you don't like, you can just revert to the state before the update as if it never happened.

- Dynamic environments. Nix gives you access to the Nix shell which is an environment where you can specify whatever packages you want and use them for the duration of the shell. If you have Python3.x on your system, but for a specific task you need Python3.y, then all you have to do is initiate a shell with Python3.y and it will be gone when you leave the shell.

- Purely functional. Nix is a declarative, purely functional language. This means that functions have no effect on external state. This may take some time getting used to, but it allows the interpreter to make a whole bunch of assumptions which is the key to its reproducible nature. This also forces you into a pattern that rarely produces bugs, keeping your system stable.

- Lazily evaluated. Nix only evaluates values if they are called. Any errors like divisions by zero and anything that would take eons to compute is not calculated unless it is needed. You don't pay for what you don't use.

With a feature set like this it can be hard to not see the appeal.

### Why SputNix?

SputNix (this repository) is what you'd call a NixOS configuration/flake. It's a collection of configuration files all managed by the top-level `flake.nix`. It very closely resembles my personal repository, but has had some personal tastes/preferences and nested structures removed for ease of understanding. It's not a distribution derived from NixOS, but rather a starter template configuration for you to get up to speed with everything Nix has to offer as fast as possible, and exposing you to good practises in managing your system.

Getting this configuration to the point it is at took a lot of time, the reason being that the documentation for NixOS is not the best. The main problem with NixOS documentation isn't necessarily that it is bad, lackluster or shallow (though it often can be), but rather that it is all scattered throughout the internet like a broken vase, and the ones you find often require 

This is why so many NixOS users may have such varied configurations, with some aspects of them being very clever, while simultaneously having some extremely questionable aspects, like tons of `if else` statements because the user hasn't heard about the config/options system, and just used the knowledge they had available to modularize their configuration.

This also results in many configurations being quite hard to navigate, making those GitHub pages newbies get linked to *use as reference* mostly useless as in order to use anything from someones configuration, you need to be able to untangle that one weird/over-complicated aspect that plaques everything, which often requires a lot of effort and know-how, which the newbies that stand to gain the most from it don't have.

So while robust, most configurations are built upon a very personal knowledge and learning journey, making the experience akin to those textbooks that leave the proof to the reader, "*as it is trivial to prove*" (it never is).

SputNix aims to be a one-stop shop for all the basics that you need in order to have a functional configuration at the start of your NixOS journey with all the features you would have otherwise found yourself rewriting your configuration in order to accommodate, like flakes, home-manager, disko and sops-nix, while also explaining what these are, why you want them and how to modify them to your preference, instead of just blindly giving you a configuration with these features, reproducing the problems mentioned above.
