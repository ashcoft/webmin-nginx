#!/bin/sh
# Syntax-check the Webmin nginx module (nginx/*.cgi, nginx/*.pl).
#
# The module's runtime dependencies are not installed in a bare checkout:
# WebminCore is provided by Webmin itself, and HTML::Entities by the
# libhtml-parser-perl package. `perl -c` only compiles, so stub them to keep
# this check hermetic and dependency-free.
set -e
root="$(cd "$(dirname "$0")/.." && pwd)"
stub="$(mktemp -d)"
trap 'rm -rf "$stub"' EXIT
mkdir -p "$stub/HTML"
printf 'package WebminCore;\nsub import {}\n1;\n' > "$stub/WebminCore.pm"
printf 'package HTML::Entities;\nsub import {}\n1;\n' > "$stub/HTML/Entities.pm"
cd "$root/nginx"
for f in *.cgi *.pl; do
  perl -I"$stub" -c "$f"
done
