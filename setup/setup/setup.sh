#!/bin/bash

ls -a
if [ "$(id -u)" -ne 0 ]; then
  echo ./hot.sh | sudo -s
else
  ./hot.sh
fi