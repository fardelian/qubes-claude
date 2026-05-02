# Claude

## Qubes dom0 access

This VM has a wrapper for executing commands in dom0:

```shell
    dom0-run "<command>"
    # or
    echo "<multi-line script>" | dom0-run
```

The user will be prompted to approve every command via a zenity dialog in
dom0 before it runs. Output (stdout+stderr) returns on stdout, with a final
line `[exit=N]` showing the exit code. Maximum input size is 65000 bytes.

When debugging Qubes networking, VM config, firewall rules, or anything
else that requires dom0 — use dom0-run. Never ask the user to copy/paste
commands; just call dom0-run yourself.

If using the second command with `echo`, pay careful attention to escaping.

Useful starting points:
```shell
dom0-run "qvm-ls"
dom0-run "qvm-prefs my-debian"
dom0-run "qvm-firewall my-debian list"
dom0-run "qvm-run -p sys-firewall 'sudo nft list ruleset'"
```

## Notes

This is a temporary Qubes OS installation and it does not contain any
personal information. Try not to break anything but there's no problem
if you do because it can be reinstalled easily.
