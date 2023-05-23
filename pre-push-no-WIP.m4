changequote([, ])dnl
divert(1)dnl
dnl
dnl
dnl pre-push-no-WIP.m4
dnl ------------------
dnl
dnl SPDX-License-Identifier: CC0-1.0
dnl
dnl Written by Lawrence Velazquez <vq@larryv.me> in:
dnl   - 2018, 2020, 2022 (as pre-push-no-WIP)
dnl   - 2023 (as pre-push-no-WIP.m4)
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
divert[]dnl
[#]!ifdef([SHELL], [defn([SHELL])], [[/bin/sh]]) -

# pre-push-no-WIP - Block "work in progress" commits
# --------------------------------------------------
#
# SPDX-License-Identifier: CC0-1.0
#
# Written in 2018, 2020, 2022-2023 by Lawrence Velazquez <vq@larryv.me>.
#
undivert(1)dnl

# -------------------------------------------------------------------
# Exits with a nonzero status if any outgoing commit message contains
# a line beginning with any of the following strings (ignoring case):
#
#   - "(FIXUP)", "(NOCOMMIT)", "(REWORD)", "(SQUASH)", or "(WIP)"
#   - "[FIXUP]", etc.
#   - "{FIXUP}", etc.
#
# Exits with a zero status otherwise.
#
# See also: https://git-scm.com/docs/githooks/2.24.0#_pre_push
# -------------------------------------------------------------------

exec >&2

# Git prepends its exec directory to PATH, so this just works.
# shellcheck source=/dev/null  # I don't want to check Git's code.
. git-sh-setup

rc=0

while read -r local_ref local_sha1 remote_ref remote_sha1; do
	if test "$local_sha1" = 0000000000000000000000000000000000000000; then
		# Deleting a remote ref doesn't push any commits.
		continue
	elif test "$remote_sha1" = 0000000000000000000000000000000000000000; then
		# Creating new remote ref.
		range=$local_sha1
	else
		# Updating existing remote ref.
		range=$remote_sha1..$local_sha1
	fi

	git rev-list --pretty='%h %s' --extended-[regexp --regexp]-ignore-case \
		--grep='^\((FIXUP|NOCOMMIT|REWORD|SQUASH|WIP))' \
		--grep='^\{(FIXUP|NOCOMMIT|REWORD|SQUASH|WIP)}' \
		--grep='^\[[(FIXUP|NOCOMMIT|REWORD|SQUASH|WIP)]]' \
		"$range" \
	| (
		# If there's no input, there are no WIP commits.
		# Discard the first line, which is a "commit
		# [full SHA1]" line.
		read -r || exit

		# Print an empty line between commit lists.
		if test "$rc" -ne 0; then
			echo
		fi

		# Print a summary, then the commit list.
		printf '%s: blocked push to %s\n' "${0##*/}" "$remote_ref"
		printf '%s: WIP commits in %s:\n' "${0##*/}" "$local_ref"

		# Only the "oneline" pretty-format omits "commit [full SHA1]"
		# lines, so we have to discard them ourselves.  Let everything
		# else through.
		sed '/^commit /d'

		# https://mywiki.wooledge.org/BashFAQ/024 - Setting rc
		# from inside the pipeline is not portable, so use the
		# pipeline's exit status to set it on the outside.
	) && rc=1
done

exit "$rc"
