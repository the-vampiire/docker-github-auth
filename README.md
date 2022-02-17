# Dockerfile samples for cloning private repos / packages

## Steps

1. create a new user (only for this purpose)
2. generate an SSH key pair for the user
```sh
ssh-keygen -t rsa -b 2048 -C username@github
# no password
# save as username@github
```
3. set the public key (`username@github.pub`) on the new account at [settings/keys](https://github.com/settings/keys)
4. copy the private key (`username@github`) to the `github/` dir
5. copy / extend the `Dockerfile` to your needs

## NOtes

> **do not commit the key** add to `.gitignore`

```sh
<username>@github
```

> the key will appear in the image layer! do not share with anyone untrusted

## Usage

- script works on alpine or ubuntu (looks for `apk` or `apt` package manager)
- the script will setup the `.ssh` and `.gitconfig` files
- it will add `github.com` to known hosts
- it will test the connection and exit 0 if successful or exit 1 if it fails (to stop the rest of the build)
