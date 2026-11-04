#!/usr/bin/env bash
# Field Cut checks. Run from the field-cut folder:  bash scripts/check.sh
# Fails (exit 1) on any error. Warnings are printed but do not fail.
cd "$(dirname "$0")/.." || exit 1
fail=0

echo "1. JavaScript syntax"
if ! command -v node >/dev/null; then
  echo "   WARNING: node not installed, skipping syntax checks"
else
  # Pull every <script> block out of index.html and syntax-check each one.
  tmp=$(mktemp -d)
  node -e '
    const fs=require("fs"),html=fs.readFileSync("index.html","utf8"),out=process.argv[1];
    let n=0;for(const m of html.matchAll(/<script>([\s\S]*?)<\/script>/g)){fs.writeFileSync(out+"/s"+(++n)+".js",m[1])}
    console.log("   found "+n+" script blocks");
  ' "$tmp"
  for f in "$tmp"/s*.js; do
    node --check "$f" 2>"$tmp/err" || { echo "   ERROR in $(basename "$f"):"; sed 's/^/   /' "$tmp/err" | head -8; fail=1; }
  done
  node --check rec-worklet.js 2>"$tmp/err" || { echo "   ERROR in rec-worklet.js"; cat "$tmp/err"; fail=1; }
  rm -rf "$tmp"
fi

echo "2. Outside web links in the page (must be none that load anything)"
# Only look for links that load things: href, src, url(), import, fetch. Comment links are fine.
hits=$(grep -nE '(href|src)=["'"'"']?https?://|url\(["'"'"']?https?://|@import|fetch\(["'"'"']?https?://|import\(["'"'"']?https?://' index.html | cut -c1-160)
if [ -n "$hits" ]; then echo "   ERROR: page loads something from the internet:"; echo "$hits" | sed 's/^/   /'; fail=1; fi

echo "3. Font files exist"
for f in IBMPlexMono-Regular IBMPlexMono-Medium IBMPlexSansCondensed-Medium IBMPlexSansCondensed-SemiBold IBMPlexSans-Regular IBMPlexSans-Medium IBMPlexSans-SemiBold; do
  [ -s "fonts/$f.woff2" ] || { echo "   ERROR: missing fonts/$f.woff2"; fail=1; }
  grep -q "fonts/$f.woff2" index.html || { echo "   ERROR: index.html does not use fonts/$f.woff2"; fail=1; }
done

echo "4. Original backup untouched"
[ -s original/index.html ] || { echo "   ERROR: original/index.html is missing"; fail=1; }

if [ $fail -eq 0 ]; then echo "ALL CHECKS PASSED"; else echo "CHECKS FAILED"; fi
exit $fail
