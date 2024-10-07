#!/bin/bash

# Raycast git-worktree/PR dev-env creator

# Required paramters:
# @raycast.schemaVersion 1
# @raycast.title PR->worktree
# @raycast.mode fullOutput
# @raycast.packageName PR
#
# Optional parameters:
# @raycast.icon 🤖
# @raycast.currentDirectoryPath ~/worktree/valified/valified/master
# @raycast.needsConfirmation false
# @raycast.argument1 { "type": "text", "placeholder": "PR number" }
#
# Documentation:
# @raycast.description Create a valified/valified git-worktree based on the given pull request number
# @raycast.author Michael Coles
# @raycast.authorURL https://github.com/sanmiguel

branch="$1"
username="mic"

dir="../pr-${branch}"

echo "Checking out branch ${branch} into ${dir}"
git remote update -p
if [ -d ${dir} ]
then
	echo "${dir} exists"
else
	gh worktree pr ${branch} ${dir}
fi

# TODO: Figure out the changelist and somehow open those in neovide
ln -nsf ~/git/valified/valified/.envrc.local ${dir}/.envrc.local
[ -d _build ] && echo "copying _build" && cp -r _build ${dir}/_build
[ -d deps ] && echo "copying deps" && cp -r deps ${dir}/deps
[ -f .iex.exs ] && cp .iex.exs ${dir}/.iex.exs
[ -d assets ] && echo "copying assets" && cp -r ./assets ${dir}/
echo "${dir}" >> ~/.oh-my-zsh/cache/dotenv-allowed.list
gitdir=$(cd ${dir} && git rev-parse --git-dir)
echo "${issue}: " > ${gitdir}/COMMIT_EDITMSG
(cd ${dir} && source .envrc.local && neovide --fork )&
echo "Done"
