#!/bin/bash

git checkout feature/update-ray-image
git reset --hard
git clean -fd
git fetch origin
git reset --hard feature/update-ray-image
git pull
sleep 5
chmod 777 -R .