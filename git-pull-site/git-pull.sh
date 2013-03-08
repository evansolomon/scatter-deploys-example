#!/usr/bin/env bash

cd /path/to/repo/on/server
git reset HEAD --hard
git clean -fd
git pull origin master
