#!/usr/bin/env bash
set -euo pipefail

LIST_FILE="${1:-repos.txt}"
DEST_ROOT="${2:-vendor}"

mkdir -p "$DEST_ROOT"

while IFS= read -r REPO_URL; do
  [[ -z "${REPO_URL}" ]] && continue
  [[ "${REPO_URL}" =~ ^# ]] && continue

  OWNER="$(echo "$REPO_URL" | awk -F/ '{print $(NF-1)}')"
  REPO="$(echo "$REPO_URL" | awk -F/ '{print $NF}')"
  TARGET_DIR="${DEST_ROOT}/${OWNER}__${REPO}"

  echo "==> ${REPO_URL} -> ${TARGET_DIR}"

  rm -rf "$TARGET_DIR"
  mkdir -p "$DEST_ROOT"

  # Clone shallow to reduce size/time
  git clone --depth 1 "$REPO_URL" "$TARGET_DIR"

  # Remove .git folder to satisfy the requirement
  rm -rf "$TARGET_DIR/.git"

done < "$LIST_FILE"

echo "Done. Vended repos are in: ${DEST_ROOT}/"
