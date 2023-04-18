#!/bin/sh

# shellcheck disable=SC2086,SC2048
trim_all() {
    # Usage: trim_all "   example   string    "

    # Disable globbing to make the word-splitting below safe.
    set -f

    # Set the argument list to the word-splitted string.
    # This removes all leading/trailing white-space and reduces
    # all instances of multiple spaces to a single ("  " -> " ").
    set -- $*

    # Print the argument list as a string.
    printf '%s\n' "$*"

    # Re-enable globbing.
    set +f
}

set -eux

RELEASE="$(rpm -E %fedora)"

wget -P /tmp/rpms \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${RELEASE}.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${RELEASE}.noarch.rpm

rpm-ostree install \
    /tmp/rpms/*.rpm \
    fedora-repos-archive

wget -P /etc/yum.repos.d \
    https://copr.fedorainfracloud.org/coprs/tigro/python-validity/repo/fedora-${RELEASE}/tigro-python-validity-fedora-${RELEASE}.repo

[ -e "/tmp/packages.txt" ] \
  && packages=$(cat /tmp/packages.txt) \
  || packages=$(cat packages.txt)

trimmed_packages=$(trim_all "$packages")

rpm-ostree override remove firefox firefox-langpacks fprintd fprintd-pam

rpm-ostree install $trimmed_packages

# Enable initramfs generation to fix keymap in LUKS
#rpm-ostree initramfs --enable

pip3 install --prefix=/usr yafti
