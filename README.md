# infrastructure
Infrastructure as Code for Libero testing and demos

## Unlock encrypted values

This repository is public, hence secrets are encrypted by default. `gyt-crypt` and optionally `gpg` are used to unlock the contents to be able to use the repository contents.

Assuming someone has added your GPG public key to the repository:

```
git-crypt unlock
```

Assuming someone has provided you with a public key:

```
git-crypt unlock /path/to/public.key
```
