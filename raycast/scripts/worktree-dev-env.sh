#!/bin/bash

# Raycast Start a dev env from a directory

# Required paramters:
# @raycast.schemaVersion 1
# @raycast.title worktree env
# @raycast.mode fullOutput
# @raycast.packageName Linear
#
# Optional parameters:
# @raycast.icon 🤖
# @raycast.currentDirectoryPath ~/worktree/valified/valified
# @raycast.needsConfirmation false
# @raycast.argument1 { "type": "text", "placeholder": "directory" }
#
# Documentation:
# @raycast.description Open a development environment (editor, shells etc)
# @raycast.author Michael Coles
# @raycast.authorURL https://github.com/sanmiguel

directory="$1"

fullpath=$(realpath	"${directory}")

echo "Starting dev env in ${fullpath} (cwd: $PWD)"

echo "$(asdf current)"
export PATH="$PATH:/Users/sanmiguel/.asdf/shims:/Users/sanmiguel/.asdf/bin"
echo "ttab: $(which ttab)"
export TESTRUNNER="${directory}"
ttab -d ${fullpath} zsh -c "source .envrc.local && neovide --fork && [ -n \"${TESTRUNNER}\" ] && shtuff as ${TESTRUNNER}"
ttab -d ${fullpath} -v zsh
