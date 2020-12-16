#!/bin/bash

# Install script for kiambogo/dotfiles
function makeFolders () {
  mkdir -p ~/$(basename $2)
  for subobject in $2/*
  do
    if [[ -f "$subobject" ]]; then
        echo "cp -r $(pwd)/$subobject ~/$(basename $2)/$(basename $subobject)"
    fi
    if [[ -d "$subobject" ]]; then
        echo "cp -r $(pwd)/$subobject ~/$(basename $2)"
      #makeFolders $1 $subobject
    fi
  done
}

GLOBIGNORE=.
for package in *
do
  for object in $package/*
  do
    if [ "$package" != ".git" ] && [ "$package" != "powerline" ] && [ "$package" != "wallpapers" ]; then
      if [[ -d "$object" ]]; then # If it's a directory, ensure its created
          mkdir -p ~/$(basename $object) 1>/dev/null
          for subobject in $object/*
          do
              ln -s $(pwd)/$object/$(basename $subobject) ~/$(basename $object)/$(basename $subobject)
          done
      fi
      if [[ -f "$object" ]]; then
          ln -s $(pwd)/$object ~/$(basename $object)
      fi
    fi
  done
done
