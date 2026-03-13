#!/usr/bin/env fish
# Test script for wt (git worktree manager)
# Usage: fish fish/tests/test_wt.fish

set -g passed 0
set -g failed 0
set -l test_dir (mktemp -d)

function pass
    set -g passed (math $passed + 1)
    echo (set_color green)"  PASS: $argv"(set_color normal)
end

function fail
    set -g failed (math $failed + 1)
    echo (set_color red)"  FAIL: $argv"(set_color normal)
end

# Source the function under test
source (status dirname)/../functions/wt.fish

echo "Setting up test repo in $test_dir"

# Create a test repo with an initial commit
git init $test_dir/repo -b main --quiet
cd $test_dir/repo
git commit --allow-empty -m "initial" --quiet

echo
echo (set_color --bold)"--- wt ls ---"(set_color normal)

set -l ls_lines (wt ls)
# Check that at least one line contains the marker
if string match -rq '▸' -- $ls_lines
    pass "wt ls shows current marker"
else
    fail "wt ls missing current marker (got: $ls_lines)"
end

if string match -q "*main*" -- $ls_lines
    pass "wt ls shows main branch"
else
    fail "wt ls missing main branch"
end

echo
echo (set_color --bold)"--- wt new ---"(set_color normal)

wt new test-branch >/dev/null 2>&1
if test $status -eq 0
    pass "wt new exits 0"
else
    fail "wt new exited non-zero"
end

if string match -q "*test-branch*" -- (pwd)
    pass "wt new cd'd into new worktree"
else
    fail "wt new did not cd into worktree (pwd: "(pwd)")"
end

if git branch --show-current | string match -q "test-branch"
    pass "wt new created branch"
else
    fail "wt new branch not found"
end

echo
echo (set_color --bold)"--- wt new (existing branch) ---"(set_color normal)

cd $test_dir/repo
git branch existing-branch --quiet 2>/dev/null
wt new existing-branch >/dev/null 2>&1
if test $status -eq 0; and string match -q "*existing-branch*" -- (pwd)
    pass "wt new with existing branch works"
else
    fail "wt new with existing branch failed (pwd: "(pwd)")"
end
cd $test_dir/repo

echo
echo (set_color --bold)"--- wt new (no args) ---"(set_color normal)

set -l new_output (wt new 2>&1)
if test $status -eq 1; and string match -q "*Usage*" -- $new_output
    pass "wt new with no args shows usage"
else
    fail "wt new with no args should error"
end

echo
echo (set_color --bold)"--- wt ls (multiple worktrees) ---"(set_color normal)

set -l ls_lines (wt ls)
set -l line_count (count $ls_lines)
if test $line_count -ge 3
    pass "wt ls shows all worktrees ($line_count)"
else
    fail "wt ls expected 3+ worktrees, got $line_count"
end

echo
echo (set_color --bold)"--- wt <name> (switch by path) ---"(set_color normal)

cd $test_dir/repo
wt test-branch 2>/dev/null
if string match -q "*test-branch*" -- (pwd)
    pass "wt <name> switches to matching worktree"
else
    fail "wt <name> did not switch (pwd: "(pwd)")"
end

echo
echo (set_color --bold)"--- wt <name> (branch match) ---"(set_color normal)

cd $test_dir/repo
wt existing 2>/dev/null
if string match -q "*existing-branch*" -- (pwd)
    pass "wt <partial> matches branch name"
else
    fail "wt <partial> did not match branch (pwd: "(pwd)")"
end

echo
echo (set_color --bold)"--- wt <name> (no match) ---"(set_color normal)

cd $test_dir/repo
set -l nomatch_output (wt nonexistent 2>&1)
if test $status -eq 1; and string match -q "*No worktree matching*" -- $nomatch_output
    pass "wt <bad-name> errors with message"
else
    fail "wt <bad-name> should error"
end

echo
echo (set_color --bold)"--- wt rm (from inside target) ---"(set_color normal)

cd $test_dir/repo
wt test-branch 2>/dev/null
# Pipe y to confirm removal
echo y | wt rm test-branch 2>/dev/null
if not string match -q "*test-branch*" -- (pwd)
    pass "wt rm cd'd out of removed worktree"
else
    fail "wt rm did not cd out (pwd: "(pwd)")"
end

if not test -d $test_dir/repo-wt/test-branch
    pass "wt rm removed worktree directory"
else
    fail "wt rm worktree directory still exists"
end

echo
echo (set_color --bold)"--- wt rm (no args) ---"(set_color normal)

set -l rm_output (wt rm 2>&1)
if test $status -eq 1; and string match -q "*Usage*" -- $rm_output
    pass "wt rm with no args shows usage"
else
    fail "wt rm with no args should error"
end

echo
echo (set_color --bold)"--- wt prune ---"(set_color normal)

wt prune 2>&1
if test $status -eq 0
    pass "wt prune exits 0"
else
    fail "wt prune exited non-zero"
end

echo
echo (set_color --bold)"--- wt rm (cancel) ---"(set_color normal)

cd $test_dir/repo
set -l cancel_output (echo n | wt rm existing-branch 2>&1)
if string match -q "*Cancelled*" -- $cancel_output
    pass "wt rm cancel works"
else
    fail "wt rm cancel did not show Cancelled"
end

# Clean up remaining worktree
echo y | wt rm existing-branch 2>/dev/null

echo
echo "---"
echo "Cleaning up $test_dir"
rm -rf $test_dir

echo
if test $failed -eq 0
    echo (set_color --bold green)"All $passed tests passed"(set_color normal)
else
    echo (set_color --bold red)"$failed failed, $passed passed"(set_color normal)
    exit 1
end
