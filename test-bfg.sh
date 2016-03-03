#!/bin/bash

set -e # Fail fast

# Clean up last run artifacts
rm -rf private-repository temporary-repository mirror-repository public-repository

## Create empty repository representing the private repository

mkdir private-repository
cd private-repository
    git init
    mkdir folder
    echo "# This is the secret file that has to be filtered out completely from public repository" >folder/secret
    echo "# This is a public file" >folder/public

    git add folder/secret folder/public
    git commit -m "Initial two files"

    # Move the folder containing secret
    git mv folder folder-copy
    git checkout HEAD folder
    git add folder-copy
    git commit -m "Made a copy of the folder using git mv and git checkout"

    # Rename the copy using git
    git mv folder-copy/secret folder-copy/secret-renamed
    git add folder-copy/secret-renamed
    git commit -m "Renamed the secret to secret-renamed using git mv"

    # Make a copy & paste copy using normal copy operation
    cp folder/secret folder-copy/secret-workspace-copy
    git add folder-copy/secret-workspace-copy
    git commit -m "Made a workspace copy of secret using cp command"

    # Rename the copy & paste copy in workspace using mv command
    mv folder-copy/secret-workspace-copy folder-copy/secret-workspace-copy-renamed
    git add folder-copy/secret-workspace-copy-renamed
    git add folder-copy/secret-workspace-copy
    git commit -m "Renamed the secret-workspace-copy using mv command"

    # Make a now branch with all the secrets
    git checkout -b feature
    echo "# I made a change to public file" >>folder/public
    git add folder/public
    git commit -m "Changed the public file"

    # Return to master branch
    git checkout master
cd ..

# Use BFG to delete all secrets
# - https://help.github.com/articles/remove-sensitive-data/
# - http://brewformulas.org/Bfg
# - https://github.com/rtyley/bfg-repo-cleaner

# Make a temporary clone to remove the secret files from HEAD
mkdir temporary-repository
git clone --mirror private-repository temporary-repository/.git
cd temporary-repository

    git config --bool core.bare false
    git checkout master

    # First delete the secret files from HEADs
    secret_files=(
        "folder-copy/secret-renamed"
        "folder-copy/secret-workspace-copy-renamed"
        "folder/secret"
    )
    for f in ${secret_files[*]}; do git rm $f; done
    git commit -m "Removed secret files from HEAD"
cd ..

# Clone (without checkout) to clean the history
git clone --mirror temporary-repository mirror-repository
cd mirror-repository

    # Use BFG to clean up repo
    bfg --delete-files secret*
    git reflog expire --expire=now --all && git gc --prune=now --aggressive
cd ..

# Finally check out the clean repository
mkdir public-repository
git clone --mirror mirror-repository public-repository/.git
cd public-repository

    git config --bool core.bare false
    git checkout master

    git status

    git checkout feature #fails, because feature branch is missing
    git status
cd ..
