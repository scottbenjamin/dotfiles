# Do not add variables here. Edit ~/.config/environment.d/ only.
if not test -x /usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator
    return
end

for line in (/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
    if test -z "$line"; or string match -qr '^\s*#' -- $line
        continue
    end
    set -l pair (string split -m 1 -- '=' $line)
    test (count $pair) -eq 2; or continue
    set -l key $pair[1]
    set -l value (string trim --chars '"' -- $pair[2])
    set -gx $key $value
end
