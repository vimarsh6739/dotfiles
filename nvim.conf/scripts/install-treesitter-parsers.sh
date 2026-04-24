#!/usr/bin/env bash
set -euo pipefail

# Installs prebuilt tree-sitter parser shared libraries into this config's
# parser directory. By default it copies from nvim-treesitter's cached parsers.
#
# Usage:
#   scripts/install-treesitter-parsers.sh
#   scripts/install-treesitter-parsers.sh --langs cpp,python,julia
#   scripts/install-treesitter-parsers.sh --source /path/to/parser/dir
#   scripts/install-treesitter-parsers.sh --dest /path/to/parsers/parser

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

SOURCE_DIR="${HOME}/.local/share/nvim/lazy/nvim-treesitter/parser"
DEST_DIR="${CONFIG_ROOT}/parsers/parser"

DEFAULT_LANGS=(
  cpp python julia lua rust
  cuda haskell tablegen
  starlark gitcommit git_config gitignore
  latex make
  vim vimdoc
)
LANGS=("${DEFAULT_LANGS[@]}")

usage() {
  cat <<'EOF'
Install selected tree-sitter parser binaries into parsers/parser.

Options:
  --langs LIST     Comma-separated language list (e.g. cpp,python,julia)
  --source DIR     Source directory that contains parser shared libs
  --dest DIR       Destination parser directory
  -h, --help       Show help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --langs)
      shift
      if [[ $# -eq 0 || -z "${1:-}" ]]; then
        echo "Missing value for --langs" >&2
        exit 1
      fi
      IFS=',' read -r -a LANGS <<< "$1"
      ;;
    --source)
      shift
      if [[ $# -eq 0 || -z "${1:-}" ]]; then
        echo "Missing value for --source" >&2
        exit 1
      fi
      SOURCE_DIR="$1"
      ;;
    --dest)
      shift
      if [[ $# -eq 0 || -z "${1:-}" ]]; then
        echo "Missing value for --dest" >&2
        exit 1
      fi
      DEST_DIR="$1"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "Source directory does not exist: ${SOURCE_DIR}" >&2
  exit 1
fi

mkdir -p "${DEST_DIR}"

case "$(uname -s)" in
  Darwin) primary_ext="dylib" ;;
  MINGW*|MSYS*|CYGWIN*) primary_ext="dll" ;;
  *) primary_ext="so" ;;
esac

copied=()
missing=()

for lang in "${LANGS[@]}"; do
  lang="${lang// /}"
  [[ -z "${lang}" ]] && continue

  src="${SOURCE_DIR}/${lang}.${primary_ext}"
  if [[ ! -f "${src}" ]]; then
    for ext in so dylib dll; do
      alt="${SOURCE_DIR}/${lang}.${ext}"
      if [[ -f "${alt}" ]]; then
        src="${alt}"
        break
      fi
    done
  fi

  if [[ ! -f "${src}" ]]; then
    missing+=("${lang}")
    continue
  fi

  cp -f "${src}" "${DEST_DIR}/"
  copied+=("${lang}")
done

echo "Destination: ${DEST_DIR}"
if [[ ${#copied[@]} -gt 0 ]]; then
  echo "Installed parsers (${#copied[@]}): ${copied[*]}"
else
  echo "Installed parsers (0)"
fi

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "Missing parsers (${#missing[@]}): ${missing[*]}" >&2
  exit 2
fi
