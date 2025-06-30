#!/bin/bash

git checkout feature/update-to-nfs-server
git reset --hard
git clean -fd
git fetch origin
git reset --hard feature/update-to-nfs-server
git pull