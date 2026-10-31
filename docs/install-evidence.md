# Install evidence

Every install command on `install/index.html` was run in a throwaway environment
before publishing. Host: Linux x86_64 (kernel 6.18), uv 0.13.5 already present on PATH.
Every run used a temporary `HOME` under `/tmp/sitecheck/` so no real shell profile,
config or tool directory was touched.

## 1. clud: latest

Date: 2026-10-31T06:40:57Z

```sh
export HOME=/tmp/sitecheck/home UV_TOOL_DIR=/tmp/sitecheck/tools \
       UV_TOOL_BIN_DIR=/tmp/sitecheck/bin UV_CACHE_DIR=/tmp/sitecheck/uvcache CLUD_NO_PATH=1
curl -fsSL https://raw.githubusercontent.com/talos-hq/clud/main/install.sh | sh   # exit 0
/tmp/sitecheck/bin/clud --version                                                 # exit 0
```

Output tail:

```
Installed 1 executable: clud
CLUD_NO_PATH set — skipping shell PATH update

clud installed at: /tmp/sitecheck/bin/clud
Add this directory to your current shell with:
  export PATH="/tmp/sitecheck/bin:$PATH"
clud 2.8.47
```

**Version reported: `clud 2.8.47`.** The script also ran its built-in `clud __cmd-scan`
deny/allow self-check, which passed (any failure would have made it exit non-zero).

Prerequisites: POSIX `sh`, `curl`. uv is bootstrapped from astral.sh if missing. That
bootstrap branch was **not** exercised because uv was already installed.

## 2. clud: pinned (`CLUD_VERSION`)

Date: 2026-10-31

```sh
export HOME=/tmp/sitecheck/home UV_TOOL_DIR=/tmp/sitecheck/tools-pin \
       UV_TOOL_BIN_DIR=/tmp/sitecheck/bin-pin UV_CACHE_DIR=/tmp/sitecheck/uvcache CLUD_NO_PATH=1
curl -fsSL https://raw.githubusercontent.com/talos-hq/clud/main/install.sh | CLUD_VERSION=2.8.47 sh   # exit 0
/tmp/sitecheck/bin-pin/clud --version
```

```
installing clud==2.8.47 via uv tool
Installed 1 executable: clud
clud 2.8.47
```

**Version reported: `clud 2.8.47`.**

## 3. Agent (talos-hq/hermes-slim): clone and activate

Date: started 2026-10-31T06:55:15Z, finished about 07:15Z (roughly 20 minutes).

```bash
export HOME=/tmp/sitecheck/home-act UV_CACHE_DIR=/tmp/sitecheck/uvcache-act
git clone https://github.com/talos-hq/hermes-slim && cd hermes-slim && source ./activate   # activate_rc=0
hermes --version                                                                         # exit 0
```

Output tail (download progress lines left out):

```
✓ chromium
✓ cua-driver
✓ Tools + dependencies installed (hash-verified via pm + uv.lock)
activate_rc=0
Hermes Agent v0.22.5+3129.gd4f228a (2026.9.24) · upstream d4f228ac
Install directory: /tmp/sitecheck/act/hermes-slim
Install method: git
Python: 3.14.9
OpenAI SDK: 2.54.0
Up to date
```

**Version reported: `Hermes Agent v0.22.5+3129.gd4f228a`** at commit
`d4f228ac265af37d1a52ff65b28d884fd4b1aa22`. This string comes from the CLI's git
describe. The package metadata says `hermes-agent 0.0.0`. The site does not quote
either one as a product version.

Prerequisites: `git` and `bash`/`zsh`. Activate staged its own pinned uv 0.13.5 and
CPython 3.14.9, and downloaded bundled tools (ffmpeg, chromium, cua-driver and others).
Disk used: about 1.6 GB for the checkout plus about 2.1 GB under `$HOME`.

### Pinned (commit) variant

In the same clone: `git checkout d4f228ac265af37d1a52ff65b28d884fd4b1aa22 && source ./activate`
gave `rc=0` and `hermes --version` printed `Hermes Agent v0.22.5+3129.gd4f228a`.
That commit was HEAD at test time, so this shows the command sequence works. It does not
show that an older commit still installs.

## Rejected paths (not on the site)

- `uv tool install "git+https://github.com/talos-hq/hermes-slim"` **fails** (exit 1). The
  build backend refuses non-editable installs on purpose and tells you to use
  `source ./activate`.
- `curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash` (linked from the
  fork's README) installs **upstream** Hermes Agent, not this fork. It was not run and is
  not offered.
- The draft release / tag `v0.1.0` exists but was not used as an install target.

## Not verified

- macOS, Windows (`activate.ps1`), fish (`activate.fish`): only Linux + bash was tested.
- clud's uv-bootstrap branch (uv was already installed on the test host).
- The PATH edit from `uv tool update-shell` (skipped with `CLUD_NO_PATH=1` so no shell
  profile would be changed).
- Running the agent against a model provider (that needs API credentials, which were not used).
