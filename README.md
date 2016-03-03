# bfg-example

Bfg-repo-cleaner is a tool to remove all traces of a file from git repository history. This script serves as an example of using BFG in a minimal repository.

## Description

This small script demonstrates using https://rtyley.github.io/bfg-repo-cleaner/ 

The script generates a repository, adds a public and secret file to it, makes some copies of files, adds a branch and uses BFG
to strip the secret and its copies from the repository.

This can be used as training material learning how to make a private repository public while maintaining history.

## Usage

Clone this repository and run the test-bfg script. I recommend using `bash -x ./test-bfg.sh` command to get the debug output
while running the script.

The script assumes write permission to the working directory.

Subsequential runs clean up the generated repository folders.
