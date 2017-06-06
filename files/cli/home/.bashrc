#!/usr/bin/env bash

# Enable xdebug on cli prefixed by php command.
alias php='php -dzend_extension=xdebug.so'
# Add some exceptions here, like PHPUnit.
alias phpunit='php $(which phpunit)'

# You can add custom rc files thanks to docker-compose volumes or entry points.
# Note that the .bashrc.d is not created by default.
if [ -d "$HOME/.bashrc.d" ]; then
  for i in "$HOME/.bashrc.d/*"; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi
