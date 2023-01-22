# borg

A container image including borg, openssh-server and SSSD.

## Quickstart

```bash
docker run -e "SSHD_CONF=<content of sshd_config here>" -v sssd-pipes:/var/lib/sss/pipes:ro ghcr.io/borg-fleet/sssd
```

The sssd-pipes volume must be provided by a container with a running SSSD inside it. See [ghcr.io/borg-fleet/sssd](https://github.com/borg-fleet/sssd) for an example.
