#!/usr/bin/env bash

# REQ: Adds the Microsoft Debian APT repository. <eris 2023-05-27>
# SEE: https://github.com/microsoft/linux-package-repositories <>

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

arch=$(dpkg --print-architecture)
readonly arch

readonly repo='https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod'

# PORT: Bookworm not yet supported. <eris 2023-05-27>
readonly distro='bullseye'
readonly components=('main')

readonly keyring='/usr/share/keyrings/microsoft.gpg'

readonly source="deb [arch=$arch signed-by=$keyring] $repo $distro ${components[*]}"

readonly list="/etc/apt/sources.list.d/microsoft-debian.list"

sudo bash -c "echo ${source@Q} >> ${list@Q}"

sudo apt-get update
readonly packages=(
  dotnet-sdk-7.0
  azure-functions-core-tools
)

sudo apt-get update

dotnet --version

func --version
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1
if ! grep --line-regexp --silent "export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1" ~/.bash_profile; then
  echo "export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1" >> ~/.bash_profile
fi
