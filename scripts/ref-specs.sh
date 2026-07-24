#!/usr/bin/env bash
# Spec files touched recently that import helpers calling a given function.
# Repo-root-relative, most recently touched first. Stage counts go to stderr
# so an empty run shows which stage came up dry.
#
# Usage: ref-specs.sh [-c call] [-i import_prefix] [-d defs_dir] [-s since]
#   -c  function the helpers must call    -i  import prefix in specs
#   -d  helper definitions dir            -s  git --since window
set -euo pipefail

call="performMutation"
import_prefix="@/actions/"
defs_dir=""              # default: find dirs named after the prefix segment
since="3 months ago"

while getopts "c:i:d:s:" opt; do
  case $opt in
    c) call=$OPTARG ;;
    i) import_prefix=$OPTARG ;;
    d) defs_dir=$OPTARG ;;
    s) since=$OPTARG ;;
    *) exit 2 ;;
  esac
done

note() { echo "ref-specs: $*" >&2; }
die()  { note "$*"; exit 1; }

cd "$(git rev-parse --show-toplevel)"

if [[ -n $defs_dir ]]; then
  [[ -d $defs_dir ]] || die "no dir '$defs_dir' under $PWD"
  dirs=("$defs_dir")
else
  seg=$(basename "${import_prefix%/}")
  mapfile -t dirs < <(find . -type d -name "$seg" \
    -not -path '*/node_modules/*' -not -path '*/.git/*' \
    -not -path '*/dist/*' -not -path '*/build/*')
  ((${#dirs[@]})) || die "no directory named '$seg' — pass -d"
fi

mapfile -t defs < <(rg -l "${call}\(" "${dirs[@]}" -g '*.ts' -g '!*.spec.ts' || true)
note "stage 1: ${#defs[@]} files in ${dirs[*]} call ${call}("
((${#defs[@]})) || die "check -c and -d"

# File-level: sibling exports that don't call $call themselves match too.
names=$(
  {
    printf '%s\n' "${defs[@]}" \
      | xargs -r -d '\n' rg -oNI 'export (?:async )?(?:function (\w+)|const (\w+))' -r '$1$2' || true
    printf '%s\n' "${defs[@]}" \
      | xargs -r -d '\n' rg -oNIU 'export\s*\{[^}]*\}' \
      | grep -oE '[A-Za-z_]\w*' | grep -vxE 'export|as|type|default' || true
  } | sort -u
)
[[ -n $names ]] || die "stage 2: no parseable exports"
note "stage 2: helpers: $(paste -sd' ' <<<"$names")"

# One rg per file: a single call over all files loses git's newest-first
# order. (/…)? also matches barrel imports.
base="${import_prefix%/}"
re="import[^;]*\b($(paste -sd'|' <<<"$names"))\b[^;]*from ['\"]${base}(/[^'\"]*)?['\"]"

mapfile -t recent < <(git log --since="$since" --name-only --pretty=format: -- '*.spec.ts' \
  | awk 'NF && !seen[$0]++')
note "stage 3: ${#recent[@]} spec files touched since '$since'"

n=0
for f in "${recent[@]}"; do
  if rg -qU "$re" "$f" 2>/dev/null; then
    printf '%s\n' "$f"
    n=$((n + 1))
  fi
done
note "stage 3: $n of ${#recent[@]} import those helpers from $base"
