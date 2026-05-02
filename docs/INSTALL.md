# Install

## Transferring files

These instructions reference files in `../files/`. The repository normally
lives on a network-connected dev host; to install, get the files onto the
target qubes. The simplest path:

1. Clone or copy this repo into `claude-vm` (it has networking).
2. For `dom0` files, read them out of `claude-vm` from `dom0`:

       qvm-run --pass-io claude-vm 'cat /path/in/claude-vm' | sudo tee /target/path

## Create claude-vm

Inside `dom0`:

```shell
qvm-create --label red --template debian-13-xfce claude-vm
qvm-prefs claude-vm netvm sys-firewall
qvm-prefs claude-vm memory 4000
qvm-prefs claude-vm vcpus 2
qvm-volume extend claude-vm:private 10g
qvm-start claude-vm
```

## Install Claude

Inside `claude-vm`:

```shell
sudo apt update
sudo apt install -y curl
curl -fsSL https://claude.ai/install.sh | bash
```

## Create dom0 service

Inside `dom0`:

Create `/etc/qubes-rpc/local.Dom0Exec` containing [this](../files/dom0/etc/qubes-rpc/local.Dom0Exec).

Use `local.Dom0Exec-zenity` if you want to confirm Claude's actions before it performs them.

Make it executable:

```shell
sudo chmod +x /etc/qubes-rpc/local.Dom0Exec
```

## Install dom0 policy

Inside `dom0`:

Create `/etc/qubes/policy.d/30-claude.policy` containing [this](../files/dom0/etc/qubes/policy.d/30-claude.policy).

The first line lets only `claude-vm` call this service against dom0. The second is a defense-in-depth deny for everyone else (Qubes denies unmatched services by default; this just makes the intent explicit).

No chmod needed — policy files are read by `qrexec-policy-daemon` directly.

## Create claude-vm wrapper

Inside `claude-vm`:

Create `/usr/local/bin/dom0-run` containing [this](../files/claude-vm/usr/local/bin/dom0-run).

Make it executable:

```shell
sudo chmod +x /usr/local/bin/dom0-run
```

## Install Claude config

Inside `claude-vm`:

Create `~/.claude/CLAUDE.md` containing [this](../files/claude-vm/.claude/CLAUDE.md).

This tells Claude how to use `dom0-run` so it reaches for it automatically when a dom0 command is needed.

## Test

Inside `claude-vm`:

```shell
dom0-run "qvm-ls --raw-data NAME,STATE"
```

If you see the VM list returned, the bridge is working.
