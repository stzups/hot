#!/bin/sh

# todo no subs
guix pack \
    --format=docker \
    --no-substitutes \
    --image-tag="$1" \
    --manifest="$1/manifest.scm"