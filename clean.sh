#!/bin/bash
files=(
    mirror-repository
    mirror-repository.bfg-report
    private-repository
    public-repository
    temporary-repository
)

for f in ${files[*]}; do rm -rf $f; done
