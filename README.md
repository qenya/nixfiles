# nixfiles

My NixOS configuration files.

The canonical location for this repository is https://git.unspecified.systems/qenya/nixfiles. If you're viewing it elsewhere, it is a mirror and may not be up-to-date.

## Machines

### Managed
* `kilgharrah`: Custom-built personal desktop; also currently running Jellyfin, Navidrome and Audiobookshelf servers (and an FTP server, for shits and giggles)
* `tohru`: Dell Latitude 5300, personal laptop
* `elucredassa`: Acer Aspire A315-53, old laptop with a broken keyboard that now sits in a corner being a backup server
* `yevaud`: Oracle Cloud free AMD VM, hosts a Forgejo instance and WireGuard server for the other machines in the network
* `orm`: Oracle Cloud free AMD VM, hosts an instance of Actual Budget and a PostgreSQL server for other services that need one
* `kalessin`: Oracle Cloud free ARM VM, currently idling

### Referenced only
* `shaw`: [My girlfriend's NAS](https://github.com/randomnetcat/nix-configs/tree/main/hosts/shaw)
* `latias`: My Steam Deck

## Usage

### Building

To build locally, run `nixos-rebuild switch --flake .#[hostname]` as root.

To build the remote machines, run `colmena apply`. See the [colmena documentation](https://colmena.cli.rs/) for command-line options. Notable options include:
* `--on [hostname]`: build a specific machine only
* `--reboot`: reboot after building (but note [this bug](https://github.com/zhaofengli/colmena/issues/166) means it may hang even when the reboot completes successfully)

### Updating

`nix flake update --commit-lock-file`
