#!/bin/sh

# Usage:
# ./deploy.sh ["Optional commit message"]

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# Build the project.
# hugo # if using a theme, replace with `hugo -t <YOURTHEME>`
# hugo -t "even"
# hugo -D -t "even"
hugo -D -t "even" -d ../m3at.github.io

# Go To Public folder
# cd public
cd ../m3at.github.io

# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
    msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin main
