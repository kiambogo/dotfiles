#!/bin/bash

# Install script for kiambogo/dotfiles
function makeFolders () {
  mkdir -p ~/$(basename $2)
  for subobject in $2/*
  do
    if [[ -f "$subobject" ]]; then
      cp -r $subobject ~/$(basename $2)/$(basename $subobject)
    fi
    if [[ -d "$subobject" ]]; then
      cp -r $subobject ~/$(basename $2)
      #makeFolders $1 $subobject
    fi
  done
}

GLOBIGNORE=.
for package in *
do
  for object in $package/*
  do
    if [ "$package" != ".git" ] && [ "$package" != "powerline" ]; then
      if [[ -d "$object" ]]; then # If it's a directory
        # handle sub directories and files
        makeFolders $package $object
      fi

      if [[ -f "$object" ]]; then
        cp $object ~/$(basename $object)
      fi
    fi
  done
done
