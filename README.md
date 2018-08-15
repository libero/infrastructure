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

## Adding a new user's public key

Generate a public key if not having one already:

```
gpg --gen-key
```

Reasonable defaults: `RSA and RSA`, `2048` bits, no expiration, your work email address.

Export your new key with

```
gpg --armor --output myname.gpg --export myname@example.com
```

Now someone with an unlocked repository copy can use your `myname.gpg` public key:

```
gpg --import myname.gpg
git-crypt add-gpg-user myname@example.com  # creates a new commit
git push
```
