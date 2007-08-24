#!/bin/sh

mkdir -p -- "$WORKDIR/Metadata"
p="$WORKDIR/Metadata/alterator-apt.profile"

echo "(" > "$p"
for f in `find "$WORKDIR/ALTLinux" -type f \( ! -name 've-build-scripts-*' -a ! -name 've-base-*' -a -name 've-*' \)`; do
	name= descr=
	values="`rpmquery -p --qf='name=%{name:shescape}; descr=%{summary:shescape};' -- "$f"`" || continue
	eval $values
	[ -z "$name" ] || echo "(\"$name\" summary \"$descr\")"
done >> "$p"
echo ")" >> "$p"
