#!/bin/bash

# Initialize max branch name length
max_length=0

# Array to collect branch info for later display
declare -a branch_info

# First pass: collect info and find max length
while IFS= read -r branch; do
    if [ "$branch" != "master" ]; then
        # Update max length
        if [ ${#branch} -gt $max_length ]; then
            max_length=${#branch}
        fi
        
        # Get last commit date
        last_commit=$(git log -1 --format=%cd --date=iso "$branch")
        
        # Get PR status using GitHub CLI
        pr_info=$(gh pr list --head "$branch" --state all --json state --jq '.[0].state')
        
        # Set status icon
        if [ -z "$pr_info" ]; then
            status="❌"
        elif [ "$pr_info" = "MERGED" ]; then
            status="✅"
        elif [ "$pr_info" = "OPEN" ]; then
            status="🟡"
        elif [ "$pr_info" = "CLOSED" ]; then
            status="🔴"
        fi
        
        # Store info for later
        branch_info+=("$status|$branch|$last_commit")
    fi
done < <(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/)

# Print legend
echo "Legend:"
echo "  ✅ merged PR"
echo "  🟡 open PR"
echo "  🔴 closed PR"
echo "  ❌ no PR"
echo ""

# Add some padding to max length
max_length=$((max_length + 2))

# Print header
printf "%-2s %-${max_length}s %s\n" " " "BRANCH" "LAST COMMIT"
printf "%s\n" "$(printf '%.0s-' {1..100})"

# Print branch info
while IFS='|' read -r status branch date; do
    printf "%-2s %-${max_length}s %s\n" "$status" "$branch" "$date"
done < <(printf "%s\n" "${branch_info[@]}")
