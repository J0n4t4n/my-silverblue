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

# Throttled
rpm-ostree install python3-cairo-devel cairo-gobject-devel gobject-introspection-devel dbus-glib-devel python3-devel make libX11-devel
cd /tmp
git clone https://github.com/erpalma/throttled.git
mkdir -p /var/opt/throttled
./throttled/install.sh
cd -


pip3 install --prefix=/usr yafti
