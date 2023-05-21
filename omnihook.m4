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
# To the extent possible under law, the author has dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide.  This software is distributed without any
# warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication
# along with this software.  If not, see
# <https://creativecommons.org/publicdomain/zero/1.0/>.
dnl
dnl
divert(-1)

dnl Validate given hook name and configure behavior appropriately.
undefine([USE_STDIN_CACHE])
ifdef([HOOK],
      [ifelse(defn([HOOK]), [applypatch-msg], [],
              defn([HOOK]), [commit-msg], [],
              defn([HOOK]), [fsmonitor-watchman], [],
              defn([HOOK]), [p4-changelist], [],
              defn([HOOK]), [p4-post-changelist], [],
              defn([HOOK]), [p4-pre-submit], [],
              defn([HOOK]), [p4-prepare-changelist], [],
              defn([HOOK]), [post-applypatch], [],
              defn([HOOK]), [post-checkout], [],
              defn([HOOK]), [post-commit], [],
              defn([HOOK]), [post-index-change], [],
              defn([HOOK]), [post-merge], [],
              defn([HOOK]), [post-receive], [define([USE_STDIN_CACHE])],
              defn([HOOK]), [post-rewrite], [define([USE_STDIN_CACHE])],
              defn([HOOK]), [post-update], [],
              defn([HOOK]), [pre-applypatch], [],
              defn([HOOK]), [pre-auto-gc], [],
              defn([HOOK]), [pre-commit], [],
              defn([HOOK]), [pre-merge-commit], [],
              defn([HOOK]), [pre-push], [define([USE_STDIN_CACHE])],
              defn([HOOK]), [pre-rebase], [],
              defn([HOOK]), [pre-receive], [define([USE_STDIN_CACHE])],
              defn([HOOK]), [prepare-commit-msg], [],
              defn([HOOK]), [proc-receive], [],
              defn([HOOK]), [push-to-checkout], [],
              defn([HOOK]), [reference-transaction], [],
              defn([HOOK]), [sendemail-validate], [],
              defn([HOOK]), [update], [],
              [errprint([omnihook.m4: invalid HOOK value: ]defn([HOOK])[
])m4exit(1)])],
      [errprint([omnihook.m4: HOOK undefined
])m4exit(1)])

dnl Concatenates ARG2 copies of ARG1.  Expands to null if ARG2 doesn't
dnl evaluate to a positive integer.  Not recognized without arguments.
define([repeat], [ifelse([$#], 0, [[$0]], [$0_([$1], eval([$2]))])])
define([repeat_], [ifelse(eval(len([$1]) && $2 > 0), 1, [$0_($@)])])
define([repeat__], [ifelse([$2], 0, [], [$0([$1], decr([$2]))$1])])

divert[]dnl
[#]!ifdef([SHELL], [defn([SHELL])], [[/bin/sh]]) -

[#] defn([HOOK])
[#] repeat(-, len(defn([HOOK])))
#
# SPDX-License-Identifier: CC0-1.0
#
# Written by Lawrence Velazquez <vq@larryv.me> in:
#   - 2018, 2020, 2022-2023 (as omnihook)
#   - 2023 (as part of omnihook.m4)
#
undivert(1)dnl

dnl TODO: Dynamically wrap this comment somehow.
# ----------------------------------------------------------------------
[#] Runs every "defn([HOOK])-" executable in the hooks directory of the
# current Git repository, repeatedly passing along its arguments and
# standard input.  Exits with a nonzero status if any of those
# executables does so, if a Git repository cannot be found, or if the
# standard-input cache cannot be written; exits with zero otherwise.
#
# See also: https://git-scm.com/docs/githooks/2.24.0
# ----------------------------------------------------------------------

# Git prepends its exec directory to PATH, so this just works.
# shellcheck source=/dev/null  # I don't want to check Git's code.
. git-sh-setup

ifdef([USE_STDIN_CACHE],
[# Deletes temporary files.
cleanup() {
    if test "$stdin_cache"; then
        rm -f -- "$stdin_cache"
    fi
}

])dnl
# Get a pathname to the hooks directory.  Handle it robustly [3].
hooks_dir=$(git rev-parse --git-path hooks && echo .) || exit
hooks_dir=${hooks_dir%??}

ifdef([USE_STDIN_CACHE],
[# Generate temporary pathname.  $HOME is private, so don't worry about
# malicious symbolic links and such [4].  (Ill-gotten write access to
# $HOME is decidedly out of scope here.)
# shellcheck disable=SC3028
hostname=${HOSTNAME:-${HOST:-$(hostname 2>/dev/null)}}
stdin_cache=~/.githooks.defn([HOOK]).stdin${hostname:+.$hostname}.$$

# Clean up on normal exit.
trap cleanup EXIT

# Clean up upon receiving a default-fatal signal.
for sig in HUP INT QUIT TERM; do
    # Self-signal to inform the caller of the abnormal exit [7].
    # shellcheck disable=SC2064
    trap "cleanup; trap - $sig; kill -s $sig"' "$$"' "$sig"
done

# Cache standard input to pass along to the invoked hooks.
cat >"$stdin_cache" || exit

])dnl
for hook in "$hooks_dir"/defn([HOOK])-*; do
    # Ignore nonexecutable hooks because Git does.  Technically there's
    # a TOCTOU bug here, but I don't think it's worth worrying about.
    if test -f "$hook" && test -x "$hook"; then
        "$hook" "$@" ifdef([USE_STDIN_CACHE], [<"$stdin_cache" ])|| exit
    fi
done

# References
#  3. https://www.etalabs.net/sh_tricks.html
#  4. https://mywiki.wooledge.org/BashFAQ/062
#  7. https://mywiki.wooledge.org/SignalTrap
