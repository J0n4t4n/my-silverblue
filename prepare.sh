#!/bin/bash

set -eux

RELEASE="$(rpm -E %fedora)"

wget -P /tmp/rpms \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${RELEASE}.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${RELEASE}.noarch.rpm"

wget -P /etc/yum.repos.d \
    "https://copr.fedorainfracloud.org/coprs/tigro/python-validity/repo/fedora-${RELEASE}/tigro-python-validity-fedora-${RELEASE}.repo" \
    #https://copr.fedorainfracloud.org/coprs/abn/throttled/repo/fedora-${RELEASE}/abn-throttled-fedora-${RELEASE}.repo

# 1Password
rpm --import https://downloads.1password.com/linux/keys/1password.asc
echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://downloads.1password.com/linux/keys/1password.asc" > /etc/yum.repos.d/1password.repo
