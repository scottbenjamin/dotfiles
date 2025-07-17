# Create a fish function called gfm which will do the following
# - identify the default branch
# - git fetch --all -prune
# - check out or fetch all changes from default branch
# - can be run from any branch and only affect the default branch

function gfm
    set -l default_branch (git remote show origin | awk '/HEAD branch/ {print $NF}')
    echo "Default branch is: $default_branch"
    echo "Fetching all remotes and pruning deleted branches..."
    git fetch --all --prune
    echo "Updating local $default_branch with latest from origin..."
    git fetch origin $default_branch:$default_branch
    echo "Done. Don't forget to pull."
end
