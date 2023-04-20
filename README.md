# my-silverblue

Laptop manual steps:

1. `rpm-ostree initramfs --enable`

Required to change the keymap during init to DE (for LUKS)

2. `hostnamectl hostname Jonatan-T480`
3. `rpm-ostree rebase ostree-unverified-registry:ghcr.io/j0n4t4n/my-silverblue:main`
4. `rpm-ostree install python3-validity`

python3-validity can't be installed in CI, as it fails due to no fingerprinter sensors being present.
