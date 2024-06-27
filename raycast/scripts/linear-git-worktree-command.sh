#!/bin/bash

# Raycast git-worktree/github/linear integration

# Required paramters:
# @raycast.schemaVersion 1
# @raycast.title Linear->git-worktree
# @raycast.mode fullOutput
# @raycast.packageName Linear
#
# Optional parameters:
# @raycast.icon 🤖
# @raycast.currentDirectoryPath ~/worktree/valified/valified/master
# @raycast.needsConfirmation false
# @raycast.argument1 { "type": "text", "placeholder": "linear branch" }
#
# Documentation:
# @raycast.description Create a valified/valified git-worktree based on the given linear branch name
# @raycast.author Michael Coles
# @raycast.authorURL https://github.com/sanmiguel

branch="$1"
username="mic"

case "${branch}" in
	${username}/*)
		issue_branch=$(basename ${branch})
		issue=$(echo "$issue_branch" | sed -e 's/^\(vali-[0-9]*\).*$/\1/g')
		dir="../${issue}"
		;;
	*)
		dir="../${branch}"
		;;
esac

echo "Checking out branch ${branch} into ${dir}"
git remote update -p
if [ -d ${dir} ]
then
	echo "${dir} exists"
else
	if [ `git rev-parse --verify ${branch} 2>/dev/null` ]
	then
		git worktree add ${dir} ${branch}
	else
		git worktree add --no-track ${dir} origin/master -b ${branch}
	fi
fi
ln -nsf ~/git/valified/valified/.envrc.local ${dir}/.envrc.local
[ -d _build ] && echo "copying _build" && cp -r _build ${dir}/_build
[ -d deps ] && echo "copying deps" && cp -r deps ${dir}/deps
[ -f .iex.exs ] && cp .iex.exs ${dir}/.iex.exs
[ -d assets ] && echo "copying assets" && cp -r ./assets ${dir}/
echo "${dir}" >> ~/.oh-my-zsh/cache/dotenv-allowed.list
(cd ${dir} && neovide --fork )&
echo "Done"
