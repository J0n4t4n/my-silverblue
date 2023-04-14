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

[ -e "/tmp/packages.txt" ] \
  && packages=$(cat /tmp/packages.txt) \
  || packages=$(cat packages.txt)

trimmed_packages=$(trim_all "$packages")

rpm-ostree install $trimmed_packages
