# Pre-push auxiliary hook that prevents pushing WIP ("work in progress")
# commits. Must be sourced from the pre-push driver hook. Returns
# nonzero if any outbound commits are WIPs and zero otherwise.
#
# A commit is considered to be a WIP if its commit message begins with
# a keyword indicating as much (ignoring leading whitespace). The
# following keywords are recognized in a case-sensitive manner:
#   - FIXUP
#   - REWORD
#   - SQUASH
#   - WIP
# They can be bare ("WIP") or enclosed in braces ("{WIP}"), brackets
# ("[WIP]"), or parentheses ("(WIP)"). Word boundaries are not taken
# into consideration, so overly enthusiastic messages like "REWORDED
# COMMENTS" and "SQUASHED BUGS" are false positives. Don't be overly
# enthusiastic.
#
# Refer to the githooks(1) man page for detailed information on pre-push
# hooks (https://git-scm.com/docs/githooks/2.16.2#_pre_push).

if [ "${local_sha1}" = 0000000000000000000000000000000000000000 ]
then
    # Nothing to do because deleting a remote ref doesn't push any commits.
    return 0
fi

if [ "${remote_sha1}" = 0000000000000000000000000000000000000000 ]
then
    # Creating new remote ref.
    range=${local_sha1}
else
    # Updating existing remote ref.
    range=${remote_sha1}..${local_sha1}
fi

WIP_keywords='(FIXUP|REWORD|SQUASH|WIP)'

WIP_commit_count=$(git rev-list --count --extended-regexp \
                    --grep="^[[:space:]]*\[${WIP_keywords}]" \
                    --grep="^[[:space:]]*\(${WIP_keywords})" \
                    --grep="^[[:space:]]*\{${WIP_keywords}}" \
                    --grep="^[[:space:]]*${WIP_keywords}" \
                    "$range")
if [ "${WIP_commit_count}" -gt 0 ]
then
    printf >&2 'pre-push-no-WIP: %s\n' \
        "found WIP-ish commits in ${local_ref}"
    return 1
fi

unset range WIP_keywords WIP_commit_count
