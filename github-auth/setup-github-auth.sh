#!/usr/bin/env sh

set -e

# SET TO YOUR KEY HERE
ssh_key_name='username@github'
ssh_dir=/root/.ssh

if [ "$(command -v apt)" ]; then
  # for ubuntu
  DEBIAN_FRONTEND=noninteractive
  apt update -y
  apt -y install git openssh-client
elif [ "$(command -v apk)" ]; then
  # for alpine
  apk update
  apk add --no-cache git openssh
else
  echo "unknown package manager (not apt or apk)"
  exit 1
fi

mkdir $ssh_dir
mv /github/$ssh_key_name $ssh_dir/$ssh_key_name

cat >"$ssh_dir/config" <<EOF
Host github github.com
  HostName github.com
  IdentityFile ~/.ssh/$ssh_key_name
EOF

cat >"/root/.gitconfig" <<EOF
[url "ssh://git@github.com/"]
  insteadOf = https://github.com/
EOF

ssh-keyscan github.com > $ssh_dir/known_hosts

test="$(ssh -T git@github.com || echo $?)"

if [ $test -eq 1 ]; then
  # successfully authenticate with GitHub
  exit 0
else 
  # failed to authenticate with GitHub
  exit 1
fi
