#!/bin/bash
# Make Armbian v22.08 build a Debian 11 (bullseye) rootfs after Debian 11 reached end of life
# (31 Aug 2026): security + backports suites are gone from the regular Debian mirrors and
# nala (installed by default) can no longer be installed on bullseye.
set -euo pipefail
BUILD_DIR="${1:?usage: $0 <armbian build dir>}"
cd "$BUILD_DIR"

# 1) nala: drop from the package list and don't add its apt repo
sed -i '/^nala$/d' config/cli/bullseye/main/packages
# (remove the whole dir: an empty dir would make Armbian's '*.source' glob loop run on a literal name)
rm -rf config/cli/bullseye/main/sources/apt

# 2) sources.list for bullseye: keep main + updates, drop backports and security (404 now)
python3 - <<'PY'
import re
p = "lib/general.sh"
s = open(p).read()
m = re.search(r"(\tbullseye\|bookworm\|trixie\)\n.*?\tEOF\n)", s, re.S)
assert m, "bullseye sources block not found"
block = m.group(1)
new = re.sub(r"\n\tdeb http://\$\{DEBIAN_MIRROR\} \$\{release\}-backports[^\n]*\n\t#deb-src[^\n]*\n", "\n", block)
new = re.sub(r"\n\tdeb http://\$\{DEBIAN_SECURTY\} \$\{release\}-security[^\n]*\n\t#deb-src[^\n]*\n", "\n", new)
assert new != block and "backports" not in new and "SECURTY" not in new
open(p, "w").write(s.replace(block, new))
print("patched lib/general.sh and nala removed")
PY
