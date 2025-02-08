#!/bin/bash

# Function to check if the current directory is a git repository
function check_git_repo() {
    if [ ! -d ".git" ]; then
        echo "This is not a git repository. Please navigate to a git repository and try again."
        exit 1
    fi
}

# Function to split commits into separate branches
function split_commits_to_branches() {
    # Fetch the latest changes from the main branch
    git fetch origin main

    # Get the list of commits in the current branch
    commits=$(git log --oneline main..HEAD)

    # Save the current branch name
    original_branch=$(git rev-parse --abbrev-ref HEAD)

    # Look for a ticket pattern of the form "(.*)-([0-9]+)" and extract it
    ticket_pattern="([A-Z]+-[0-9]+)"
    base_ticket=""
    if [[ "$original_branch" =~ $ticket_pattern ]]; then
        base_ticket=${BASH_REMATCH[1]}
    fi

    # get the user from the ~/ path
    user=$(echo $HOME | awk -F'/' '{print $3}')

    # Iterate over each commit
    echo "$commits" | while IFS= read -r commit; do
        # Extract the commit hash and message
        commit_hash=$(echo $commit | awk '{print $1}')
        commit_message=$(echo $commit | cut -d' ' -f2-)

        # look for a ticket pattern in the commit message
        commit_ticket=""
        if [[ "$commit_message" =~ $ticket_pattern ]]; then
            commit_ticket=${BASH_REMATCH[1]}
        fi

        branch_safe_commit_message=$(echo $commit_message | tr ' ' -)  # Replace spaces with underscores

        # if we find a commit ticket in the commit, we want to remove it from the commit message.
        if [[ -n "$commit_ticket" ]]; then
            branch_safe_commit_message=$(echo $branch_safe_commit_message | sed -E "s/$commit_ticket-//")
        fi

        # if the commit message is now empty, we want to use the hash
        if [[ -z "$branch_safe_commit_message" ]]; then
            branch_safe_commit_message=$commit_hash
        fi

        # Prompt the user to decide if they want to split this commit
        echo "Do you want to split out the commit: '$commit_message'? (y/n)"
        read -n 1 -r user_input < /dev/tty

        if [[ "$user_input" == "y" || "$user_input" == "Y" || "$user_input" == "" ]]; then
            # Default branch name
            if [[ -n "$commit_ticket" ]]; then
                default_branch_name="${user}/${commit_ticket}/${branch_safe_commit_message}"
            elif [[ -n "$base_ticket" ]]; then
                default_branch_name="${user}/${base_ticket}/${branch_safe_commit_message}"
            else
                default_branch_name="${user}/${branch_safe_commit_message}"
            fi

            # Prompt the user to enter a new branch name or press enter to use the default
            echo "Enter a new branch name or press enter to use the default ('$default_branch_name'):"

            read -r branch_name < /dev/tty

            # Use the default branch name if no input is provided
            branch_name=${branch_name:-$default_branch_name}

            # Create a new branch for each commit
            git checkout -b "$branch_name" main

            # Cherry-pick the commit onto the new branch
            git cherry-pick "$commit_hash"

            # Push the new branch to the remote repository
            git push origin "$branch_name"

            # Optionally, create a pull request using a CLI tool like GitHub CLI
            # Uncomment the line below if you have GitHub CLI installed
            # gh pr create --base main --head "$branch_name" --title "$commit_message"
        else
            echo "Skipping commit: '$commit_message'"
        fi
    done

    # Checkout back to the original branch
    git checkout "$original_branch"
}

# Main script execution
check_git_repo
split_commits_to_branches
