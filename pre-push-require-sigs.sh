# Pre-push auxiliary hook that requires commits to have verifiable PGP
# signatures. Must be sourced from the pre-push driver hook. Returns
# zero if all commits have verifiable signatures and nonzero otherwise.
# Fatal conditions include unsigned commits, missing public keys, and
# Git/PGP misconfiguration.
#
# Refer to the githooks(1) man page for detailed information on pre-push
# hooks (https://git-scm.com/docs/githooks/2.2.0#_pre_push).

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

# Use xargs(1) to prevent the "git verify-commit" command from growing
# too long. (Unlikely but possible, given enough commits.)
if ! git rev-list "$range" | xargs git verify-commit 2>/dev/null
then
    printf >&2 'pre-push-require-sigs: %s\n' \
        "could not verify ${local_ref}" \
        'check for unsigned commits or missing PGP public keys'
    return 1
fi

unset range
