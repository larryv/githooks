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

# ----------------------------------------------------------------------
# Exits with a nonzero status if any outgoing commit message begins with
# any of the following strings (whitespace included):
#
#   - "(FIXUP) ", "(NOCOMMIT) ", "(REWORD) ", "(SQUASH) ", or "(WIP) "
#   - "[FIXUP] ", etc.
#   - "{FIXUP} ", etc.
#   - "amend! ", "fixup! ", or "squash! "
#
# Exits with a zero status otherwise.
#
# See also:
#   - https://git-scm.com/docs/githooks/2.24.0#_pre_push
#   - https://git-scm.com/docs/git-rebase/2.40.0#Documentation/git-rebase.txt---autosquash
# ----------------------------------------------------------------------

# Git prepends its exec directory to PATH, so this just works.
# shellcheck source=/dev/null
. git-sh-setup

wip_re=\
['^[^ ]+ \((FIXUP|NOCOMMIT|REWORD|SQUASH|WIP))( |$)
^[^ ]+ \{(FIXUP|NOCOMMIT|REWORD|SQUASH|WIP)}( |$)
^[^ ]+ \[(FIXUP|NOCOMMIT|REWORD|SQUASH|WIP)]( |$)
^[^ ]+ (amend|fixup|squash)![ ]']

err() {
	printf '%s: %s\n' "${0##*/}" "$*" >&2
}

rc=0

while read -r local_ref local_obj remote_ref remote_obj
do
	# Of the characters that cannot appear in reference names (see
	# git-check-ref-format(1)), ":" is the easiest to work with.
	[case $local_ref:$local_obj:$remote_ref:$remote_obj in
		?*:*[!0]*:?*:*[!0]*)
			# Updating existing remote ref.
			range=$remote_obj..$local_obj
			;;
		?*:*[!0]*:?*:?*)
			# Creating new remote ref.
			range=$local_obj
			;;
		?*:?*:?*:*[!0]*)
			# Deleting existing remote ref; nothing to push.
			continue
			;;
		*)
			# Git is unlikely to provide invalid input, so
			# there's no real need for detailed feedback.
			err 'invalid standard input provided'
			exit 1
			;;
	esac]

	if
		# Filter with grep(1) because "git rev-list --grep"
		# applies its pattern linewise and cannot limit matches
		# to the beginnings of commit messages.
		git rev-list --oneline "$range" | grep -Ee "$wip_re" | (
			# If there's no input, there are no WIP commits.
			read -r first_line || exit

			# Print an empty line between commit lists.
			if test "$rc" -ne 0
			then
				echo
			fi

			# Print a summary, then the commit list.
			err "blocked push to $remote_ref"
			err "WIP commits in $local_ref:"
			printf %s\\n "$first_line"
			cat

			# Ensure rc gets set to 1.
			:
		) >&2
	then
		# https://mywiki.wooledge.org/BashFAQ/024 - Setting rc
		# from inside the pipeline is not portable, so use the
		# pipeline's exit status to set it on the outside.
		rc=1
	fi
done

exit "$rc"
