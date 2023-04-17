changequote([, ])dnl
divert(1)dnl
dnl
dnl
dnl omnihook.m4
dnl -----------
dnl
dnl SPDX-License-Identifier: CC0-1.0
dnl
dnl Written by Lawrence Velazquez <vq@larryv.me> in:
dnl   - 2018, 2020, 2022-2023 (as omnihook)
dnl   - 2023 (as omnihook.m4)
dnl
# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide.  This software is distributed without any
# warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication
# along with this software.  If not, see
# <https://creativecommons.org/publicdomain/zero/1.0/>.
dnl
dnl
divert[]dnl
#!/bin/sh

# omnihook - Polymorphic driver hook
# ----------------------------------
#
# SPDX-License-Identifier: CC0-1.0
#
# Written in 2018, 2020, 2022-2023 by Lawrence Velazquez <vq@larryv.me>.
#
undivert(1)dnl


# When installed to a repository's hooks directory as FOO and invoked by
# Git, runs every executable file named FOO-* in that directory, passing
# along all relevant information.  Exits with a nonzero status if any
# invoked executable does so (or if Git is extremely broken) and zero
# otherwise.
#
# See also: https://git-scm.com/docs/githooks/2.24.0


# Git prepends its exec directory to PATH, so this just works.
. git-sh-setup

# Helper function for cleanup traps.
cleanup() {
    rm -f -- "$tmpfile"
}

# https://www.etalabs.net/sh_tricks.html, "Getting non-clobbered output
# from command substitution"
hooks_dir=$(git rev-parse --git-path hooks && echo .) || exit
hooks_dir=${hooks_dir%??}

# Git executes hooks "normally", so $0 should contain the pathname.
hooks_prefix=${0##*/}

# If receiving data on standard input, save it to be repeatedly fed to
# the invoked hooks later.  Using a temporary file is more complicated
# and possibly slower than using a variable and here-document, but it
# ensures predictable memory usage.
case $hooks_prefix in
    post-receive | post-rewrite | pre-push | pre-receive)
        # https://mywiki.wooledge.org/BashFAQ/062
        # https://mywiki.wooledge.org/SignalTrap

        hostname=${HOSTNAME:-${HOST:-$(hostname 2>/dev/null)}}
        tmpfile=~/.githooks_${hooks_prefix}${hostname:+_$hostname}_$$.tmp
        cleanup || exit

        trap cleanup EXIT
        for sig in HUP INT QUIT TERM; do
            # Let the shell produce its "killed by signal" exit status.
            trap "cleanup; trap - $sig; kill -s $sig"' "$$"' "$sig"
        done

        cat >"$tmpfile" || exit
        ;;
    *)
        tmpfile=
        ;;
esac

for hook in "$hooks_dir/$hooks_prefix"-*; do
    # Ignore nonexecutable hooks because Git does.  Technically there's
    # a TOCTOU bug here, but I don't think it's worth worrying about.
    [[ -f "$hook" ] && [ -x "$hook" ]] || continue

    if [[ -n "$tmpfile" ]]; then
        "$hook" "$@" <"$tmpfile"
    else
        "$hook" "$@"
    fi || exit
done
