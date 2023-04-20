#!/bin/sh

set -eux

RELEASE="$(rpm -E %fedora)"

wget -P /tmp/rpms \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${RELEASE}.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${RELEASE}.noarch.rpm

rpm-ostree install \
    /tmp/rpms/*.rpm \
    fedora-repos-archive

wget -P /etc/yum.repos.d \
    https://copr.fedorainfracloud.org/coprs/tigro/python-validity/repo/fedora-${RELEASE}/tigro-python-validity-fedora-${RELEASE}.repo \
    #https://copr.fedorainfracloud.org/coprs/abn/throttled/repo/fedora-${RELEASE}/abn-throttled-fedora-${RELEASE}.repo

while read -r line
do
    [[ $line = \#* ]] && continue
    removePackages="${removePackages:-} ${line}"
done < "/tmp/remove-packages.txt"

rpm-ostree override remove ${removePackages}

while read -r line
do
    [[ $line = \#* ]] && continue
    installPackages="${installPackages:-} ${line}"
done < "/tmp/install-packages.txt"

rpm-ostree install ${installPackages}

# 1Password https://support.1password.com/install-linux/#centos-fedora-or-red-hat-enterprise-linux
rpm --import https://downloads.1password.com/linux/keys/1password.asc
echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo
rpm-ostree install 1password

# Enable initramfs generation to fix keymap in LUKS
#rpm-ostree initramfs --enable

pip3 install --prefix=/usr yafti
