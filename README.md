# infrastructure
Infrastructure as Code for Libero testing and demos

## Scope

Resources belonging to a Libero AWS account are managed here:

### Servers

EC2 instances are used to demonstrate working versions of Libero's projects.

They run inside the default VPC for `us-east-1` and are based on a minimal Ubuntu OS running Docker and `docker-compose`. Software is deployed in the form of container images.

### DNS

DNS entries for `libero.pub` and similar domains are managed under this AWS account, hence here.

## Terraform usage

Create a new environment (here named `unstable`):

```
scripts/generate-keypair.sh unstable
cd tf/
terraform init --backend-config="key=unstable/terraform.tfstate"
terraform plan -out=my.plan
terraform apply my.plan
```

Update the environment:

```
terraform plan -out=my.plan
terraform apply my.plan
```

SSH into an instance:

```
ssh -i tf/single-node--unstable.key ubuntu@$(terraform output single_node_ip)
```

## Secrets management

This repository is public, hence secrets are encrypted by default. `gyt-crypt` and optionally `gpg` are used to unlock the contents to be able to use the repository contents.

`git-crypt` encrypts data with a symmetric key, and places encrypted versions of that key in `.git-crypt`; one value for each public key of the users that should be able to access that data. It is easy to add new users, more complex to remove them.

### Unlock encrypted values

Assuming someone has added your GPG public key to the repository:

```
git-crypt unlock
```

### Adding a new user's public key

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

### Removing a user

You can remove a user's key from `.git-crypt/keys/default/0/` but this will not prevent them from using their own copy to continue decrypting. What is needed is to [reinitialize `git-crypt` and re-add all the other keys](https://gist.github.com/developerinlondon/6a853fe175178d4aacb0aa55a4cb09a1). Secrets up to the point of change will still be available to that user, this is no different than for a private repository.
