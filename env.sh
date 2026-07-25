# Please run:
#     source env.sh
#
# This file sets up environment variables to make Open Watcom usable on my
# system (Arch-based Linux runnin on x86_64 computer). Please update these
# variables according to your system.

# See also:
# * /opt/watcom/owsetenv.sh
# * https://flaterco.com/kb/ow.html
# * https://github.com/Lethja/lua-watcom/blob/master/BUILD.md#setup-open-watcom-build-environment

export WATCOM=/opt/watcom
export PATH="${PATH}:${WATCOM}/binl64:${WATCOM}/binl"
export EDPATH="${WATCOM}/eddat"

# These variables change based on compilation target.
# For DOS:
export INCLUDE="$WATCOM/h"
# export LIB =
