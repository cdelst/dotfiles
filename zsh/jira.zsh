# =============================================================================
# JIRA INTEGRATION FUNCTIONS
# =============================================================================

# List JIRA tickets in progress
function jip() {
  jira issue list -s'In Progress' -a cdelst@netflix.com
}

# List JIRA tickets to do
function jtodo() {
  jira issue list -s'To Do' -a cdelst@netflix.com
}

# Interactive JIRA ticket selection for Jujutsu commits
function jjira() {
  # Get list of tickets with status filtering and let user select one
  local selection=$(jira issue list -a cdelst@netflix.com -s "New" -s "To Do" -s "In Progress" --plain --no-headers --columns key,status,summary | fzf --prompt="Select ticket: ")
  
  if [[ -z "$selection" ]]; then
    echo "No ticket selected"
    return 1
  fi
  
  # Extract ticket key, status, and summary from tab-delimited selection
  local ticket=$(echo "$selection" | cut -f1)
  local ticket_status=$(echo "$selection" | cut -f2)
  local summary=$(echo "$selection" | cut -f3-)
  
  # Clean up summary (remove leading/trailing whitespace)
  summary=$(echo "$summary" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  
  # If summary is empty, get it from jira list command without status
  if [[ -z "$summary" ]]; then
    summary=$(jira issue list -a cdelst@netflix.com --plain --no-headers --columns key,summary | grep "^$ticket" | cut -f2-)
    summary=$(echo "$summary" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  fi
  
  # If ticket is "To Do", move it to "In Progress"
  if [[ "$ticket_status" == "To Do" ]]; then
    echo "Moving ticket $ticket from 'To Do' to 'In Progress'..."
    jira issue move "$ticket" "In Progress"
    if [[ $? -eq 0 ]]; then
      echo "✓ Ticket moved to In Progress"
    else
      echo "✗ Failed to move ticket"
      return 1
    fi
  fi
  
  # Create commit message
  local commit_msg="$ticket: $summary"
  
  # Create jujutsu commit
  jj commit -m "$commit_msg"
  
  echo "Created commit: $commit_msg"
}

# Interactive JIRA ticket selection for git commits
function gcjira() {
  # Get list of tickets with status filtering and let user select one
  local selection=$(jira issue list -a cdelst@netflix.com -s "New" -s "To Do" -s "In Progress" --plain --no-headers --columns key,status,summary | fzf --prompt="Select ticket: ")

  if [[ -z "$selection" ]]; then
    echo "No ticket selected"
    return 1
  fi

  # Extract ticket key, status, and summary from tab-delimited selection
  local ticket=$(echo "$selection" | cut -f1)
  local ticket_status=$(echo "$selection" | cut -f2)
  local summary=$(echo "$selection" | cut -f3-)

  # Clean up summary (remove leading/trailing whitespace)
  summary=$(echo "$summary" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  # If summary is empty, get it from jira list command without status
  if [[ -z "$summary" ]]; then
    summary=$(jira issue list -a cdelst@netflix.com --plain --no-headers --columns key,summary | grep "^$ticket" | cut -f2-)
    summary=$(echo "$summary" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  fi

  # If ticket is "To Do", move it to "In Progress"
  if [[ "$ticket_status" == "To Do" ]]; then
    echo "Moving ticket $ticket from 'To Do' to 'In Progress'..."
    jira issue move "$ticket" "In Progress"
    if [[ $? -eq 0 ]]; then
      echo "✓ Ticket moved to In Progress"
    else
      echo "✗ Failed to move ticket"
      return 1
    fi
  fi

  # Create commit message
  local commit_msg="$ticket: $summary"

  # Create git commit
  git commit -m "$commit_msg"

  echo "Created commit: $commit_msg"
}

# Interactive JIRA ticket selection for Graphite branches
function gtjira() {
  # Determine project: use argument if provided, otherwise prompt for selection
  local project="$1"

  if [[ -z "$project" ]]; then
    # Let user select project interactively
    project=$(echo -e "SAC\nARTWORK" | fzf --prompt="Select project: ")

    if [[ -z "$project" ]]; then
      echo "No project selected"
      return 1
    fi
  fi

  echo "Selected project: $project"

  # Get list of tickets with status and project filtering and let user select one
  local selection=$(jira issue list -a cdelst@netflix.com -p "$project" -s "New" -s "To Do" -s "In Progress" --plain --no-headers --columns key,status,summary | fzf --prompt="Select ticket: ")

  if [[ -z "$selection" ]]; then
    echo "No ticket selected"
    return 1
  fi

  # Extract ticket key, status, and summary from tab-delimited selection
  local ticket=$(echo "$selection" | cut -f1)
  local ticket_status=$(echo "$selection" | cut -f2)
  local summary=$(echo "$selection" | cut -f3-)

  # Clean up summary (remove leading/trailing whitespace)
  summary=$(echo "$summary" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  # If summary is empty, get it from jira list command without status
  if [[ -z "$summary" ]]; then
    summary=$(jira issue list -a cdelst@netflix.com -p "$project" --plain --no-headers --columns key,summary | grep "^$ticket" | cut -f2-)
    summary=$(echo "$summary" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  fi

  # If ticket is "To Do", move it to "In Progress"
  if [[ "$ticket_status" == "To Do" ]]; then
    echo "Moving ticket $ticket from 'To Do' to 'In Progress'..."
    jira issue move "$ticket" "In Progress"
    if [[ $? -eq 0 ]]; then
      echo "✓ Ticket moved to In Progress"
    else
      echo "✗ Failed to move ticket"
      return 1
    fi
  fi

  # Create branch name: cdelst/{TICKETID}/ticket-description-timestamp
  local branch_description=$(echo "$summary" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
  local timestamp=$(date +%Y%m%d-%H%M%S)
  local branch_name="cdelst/${ticket}/${branch_description}-${timestamp}"

  # Create commit message
  local commit_msg="$ticket: $summary"

  # Create Graphite branch with commit message
  gt create "$branch_name" -m "$commit_msg"

  echo "Created Graphite branch: $branch_name"
}

# Mark JIRA ticket as done based on current git branch
function jdone() {
  # Get current git branch
  local current_branch=$(git branch --show-current)
  
  if [[ -z "$current_branch" ]]; then
    echo "✗ Not in a git repository or no current branch"
    return 1
  fi
  
  # Extract ticket ID from branch name (looking for PROJECT-NUMBER pattern)
  local ticket=$(echo "$current_branch" | grep -o '[A-Z]\+-[0-9]\+' | head -1)
  
  if [[ -z "$ticket" ]]; then
    echo "✗ No Jira ticket found in branch name: $current_branch"
    return 1
  fi
  
  echo "Found ticket: $ticket"
  echo "Moving ticket to Done..."
  
  # Move ticket to Done
  jira issue move "$ticket" "Done"
  
  if [[ $? -eq 0 ]]; then
    echo "✓ Ticket $ticket moved to Done"
  else
    echo "✗ Failed to move ticket $ticket to Done"
    return 1
  fi
}