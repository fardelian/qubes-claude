# Install

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

The first line lets only claude-vm call this service against dom0. The second is a defense-in-depth deny for everyone else.

## Create claude-vm wrapper

Inside `claude-vm`:

Create `/usr/local/bin/dom0-run` containing [this](../files/claude-vm/usr/local/bin/dom0-run).

Make it executable:

```shell
sudo chmod +x /usr/local/bin/dom0-run
```
