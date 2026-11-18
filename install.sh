#!/bin/sh
# Installs axs mem's hooks and MCP into Codex or Cursor (macOS, Linux). The dashboard shows this line:
#   curl -fsSL https://raw.githubusercontent.com/axs-sh/claude/<version tag>/install.sh | sh -s -- codex <server>
# The device token is never an argument (shell history, ps): it comes from MASTERMEM_TOKEN, else a browser login
# (the helper prints and opens a link, the person approves it in the dashboard). It downloads axs-mem for this
# machine and runs `axs-mem install <client> --server <server>` with the token on stdin, or with --login; the
# helper copies itself into the client's config dir, so the download is removed afterwards.
set -eu
usage() {
  echo "usage: install.sh codex|cursor <server>   (the token: MASTERMEM_TOKEN, else a browser login)" >&2
  exit 2
}
client=${1:-}
server=${2:-}
case "$client" in codex | cursor) ;; *) usage ;; esac
[ -n "$server" ] || usage
if [ $# -gt 2 ]; then
  echo "axs mem: do not pass the token as an argument; leave it out (browser login) or set MASTERMEM_TOKEN" >&2
  exit 2
fi
tmp=
trap '[ -z "$tmp" ] || rm -rf "$tmp"' EXIT
trap 'exit 130' INT TERM
token=${MASTERMEM_TOKEN:-}
os=$(uname -s | tr '[:upper:]' '[:lower:]')
case "$(uname -m)" in x86_64 | amd64) arch=amd64 ;; arm64 | aarch64) arch=arm64 ;; *)
  echo "axs mem: unsupported CPU $(uname -m)" >&2
  exit 1
  ;;
esac
case "$os" in linux | darwin) ;; *)
  echo "axs mem: unsupported system $os (Windows: see the README)" >&2
  exit 1
  ;;
esac
# The release this script belongs to (publish.sh sets the tag) and its signing key (allowed_signers): the helper is
# only run when SHA256SUMS carries a valid signature of that key and lists the downloaded file with its hash.
version=v0.18.0
signer='mastermem-release ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN2CxwEGYaZbQAYM/mlghTalJzTqbTu+5YAUKzqtz5mD'
repo=${MASTERMEM_RELEASE_BASE:-https://raw.githubusercontent.com/axs-sh/claude/$version}
tmp=$(mktemp -d)
command -v ssh-keygen >/dev/null || { echo "axs mem: ssh-keygen (OpenSSH) is needed to check the download" >&2; exit 1; }
curl -fsSLo "$tmp/SHA256SUMS" "$repo/SHA256SUMS"
curl -fsSLo "$tmp/SHA256SUMS.sig" "$repo/SHA256SUMS.sig"
printf '%s\n' "$signer" >"$tmp/allowed_signers"
ssh-keygen -q -Y verify -f "$tmp/allowed_signers" -I mastermem-release -n mastermem-release -s "$tmp/SHA256SUMS.sig" <"$tmp/SHA256SUMS" >/dev/null || {
  echo "axs mem: the release signature does not check out; nothing was installed" >&2
  exit 1
}
file=plugins/mem/hooks/bin/$os-$arch/axs-mem
curl -fsSLo "$tmp/axs-mem" "$repo/$file"
want=$(awk -v f="$file" '$2 == f { print $1 }' "$tmp/SHA256SUMS")
if command -v sha256sum >/dev/null; then got=$(sha256sum "$tmp/axs-mem" | cut -d' ' -f1); else got=$(shasum -a 256 "$tmp/axs-mem" | cut -d' ' -f1); fi
[ -n "$want" ] && [ "$got" = "$want" ] || {
  echo "axs mem: the downloaded helper does not match the signed release; nothing was installed" >&2
  exit 1
}
chmod +x "$tmp/axs-mem"
if [ -n "$token" ]; then
  printf '%s\n' "$token" | "$tmp/axs-mem" install "$client" --server "$server"
else
  "$tmp/axs-mem" install "$client" --server "$server" --login </dev/null
fi
