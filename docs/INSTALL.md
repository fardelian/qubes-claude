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
sudo apt install -y curl unzip
curl -fsSL https://claude.ai/install.sh | bash
```

## Transferring files

These instructions assume `~/qubes-claude` as the clone location — adjust
the paths below if you used a different one.

1. In `claude-vm`, download and extract `files.zip`:

   ```shell
   mkdir -p ~/qubes-claude
   cd ~/qubes-claude
   curl -fsSL -O https://raw.githubusercontent.com/fardelian/qubes-claude/refs/heads/main/files.zip
   unzip -o files.zip
   ```

2. In `claude-vm`, install the claude-vm files:

   ```shell
   sudo cp -rT ./files/claude-vm /
   ```

3. In `dom0`, fetch `files.zip` from claude-vm and install the dom0 files:

   ```shell
   mkdir -p ~/qubes-claude
   cd ~/qubes-claude
   qvm-run --pass-io claude-vm 'cat ~/qubes-claude/files.zip' > ./files.zip
   unzip -o ./files.zip

   sudo cp -rT ./files/dom0 /
   ```

   `cp -rT` treats `/` as the destination itself rather than a parent —
   without `-T`, it would create `/dom0/...` instead of merging into
   `/etc/...`. `unzip -o` overwrites without prompting, so re-running is safe.

4. (Optional) To use the zenity-confirm variant instead, in `dom0`:

   ```shell
   sudo cp /etc/qubes-rpc/local.Dom0Exec-zenity /etc/qubes-rpc/local.Dom0Exec
   ```

   The policy and the wrapper both reference `local.Dom0Exec` by name, so
   swapping the file content is the easiest way to switch variants.

## Test

Inside `claude-vm`:

```shell
dom0-run "qvm-ls --raw-data --fields=NAME,STATE"
```

If you see the VM list returned, the bridge is working.
