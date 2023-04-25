#!/bin/sh

set -eux

rpm-ostree install \
    /tmp/rpms/*.rpm \
    fedora-repos-archive

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

pip3 install --prefix=/usr yafti
