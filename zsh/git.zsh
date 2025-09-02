# =============================================================================
# GIT FUNCTIONS
# =============================================================================

# Quick git add, commit, push
function gnv() {
  git add . && git commit -nm "$1" && git push
}

# Undo work in progress commit
function uwip() {
  git reset --mixed HEAD^
}

# GitHub CLI wrapper for corp repos
function ghrepo() {
    if [[ -e .git/ ]]; then
        $(which gh) -R corp/$(basename $PWD) "$@"
    else
        $(which gh) "$@"
    fi
}