# Secrets

The `.nix` files in this directory are encrypted with git-crypt. After cloning, they will appear as binary garbage until you unlock them.

## Setup

**1. Copy the key to your machine**

The key file is not stored in this repo. Retrieve it and place it somewhere outside the repo, e.g. `~/git-crypt-key`.

**2. Unlock the repo**

```bash
git-crypt unlock ~/git-crypt-key
```

The secret files will immediately be decrypted in place. No need to re-clone.

**3. Verify it worked**

```bash
git-crypt status
```

All `.nix` files in this directory should show as `encrypted`.

## Locking

If you need to leave your machine and want to re-encrypt the files on disk:

```bash
git-crypt lock
```

Run `git-crypt unlock ~/git-crypt-key` again when you return.

## Adding new secret files

Any `.nix` file added to this directory is automatically encrypted on `git add` — no extra steps needed. Files of other types (e.g. `.yaml`, `.json`) are **not** encrypted, so do not store secrets in those formats here.
