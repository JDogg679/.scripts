#!/bin/bash



function clean_dir() {
  echo "Cleaning directory ..."
  GLOBIGNORE=.git:PKGBUILD:"$(basename "$0")"
  rm -rvi *
  unset GLOBIGNORE

  return 0
}

if [ -f "PKGBUILD" ]; then
  clean_dir
else
  clean_dir
  echo "Creating PKGBUILD ..."
  cat /usr/share/pacman/PKGBUILD.proto > PKGBUILD
fi

! git -C ./ rev-parse &> /dev/null \
  && echo -n "Enter repo name: " \
  && read -r REPO \
  && echo "Creating repo ..." \
  && git clone "ssh://aur@aur4.archlinux.org/${REPO}.git"

echo "
You are ready to edit PKGBUILD!
Make sure you have configured SSH correctly,
  ssh-keygen
  touch ~/.ssh/config
  chmod 600 ~/.ssh/config
  # copy the public key to the AUR profile
  # validate the changes with the command below
  ssh aur@aur4.archlinux.org help
Remember to run 'mksrcinfo' every time you edit PKGBUILD,
Finally,
  git add .
  git commit -m 'some feature'
  git push origin master
"

exit 0
