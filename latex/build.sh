#!/bin/bash
# Build a course slide deck from the shared LaTeX tree.
#
# The compilable "main" .tex files live in latex/<Course>/, while the shared
# infrastructure (sections/, preamble/, images/, assets/, style_files/, the
# *.sty/*.cls themes and references.bib) lives here in latex/. LaTeX resolves
# \input{sections/...} relative to the build working directory, so the build
# MUST run from this latex/ directory (this script cd's here for you).
#
# Usage:
#   ./build.sh --file CV/Day-1_CNN_Recap.tex            # build one deck
#   ./build.sh --file NLP/Lecture-9_Prompting+RAG.tex   # any course/file
#   ./build.sh --file CV/Day-1_CNN_Recap.tex --no-move  # leave PDF in latex/
#
# By default the finished PDF is moved to ../<Course>/Lectures/.
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TEX_FILE=""
MOVE=1

while [[ $# -gt 0 ]]; do
  case $1 in
    --file)    TEX_FILE="$2"; shift 2 ;;
    --no-move) MOVE=0; shift ;;
    *) echo "Unknown option: $1"; echo "Usage: $0 --file <Course>/<file>.tex [--no-move]"; exit 1 ;;
  esac
done

[ -z "$TEX_FILE" ] && { echo "Error: --file <Course>/<file>.tex is required"; exit 1; }

cd "$SCRIPT_DIR"
[ -f "$TEX_FILE" ] || { echo "Error: '$TEX_FILE' not found under latex/"; exit 1; }

COURSE="$(dirname "$TEX_FILE")"
BASE="$(basename "$TEX_FILE" .tex)"

echo "Building $TEX_FILE ..."
# Two passes (toc / bibliography / beamer nav need a second run). Non-fatal
# content warnings are pushed through by nonstopmode.
latexmk -pdf -shell-escape -interaction=nonstopmode -file-line-error -bibtex -use-make "$TEX_FILE" || echo "Warning: build had issues but continuing..."
latexmk -pdf -shell-escape -interaction=nonstopmode -file-line-error -bibtex -use-make "$TEX_FILE" || echo "Warning: build had issues but continuing..."

# latexmk writes outputs into the working dir (latex/), named <BASE>.*
if [ "$MOVE" = "1" ] && [ -f "$BASE.pdf" ]; then
  mkdir -p "../$COURSE/Lectures"
  mv "$BASE.pdf" "../$COURSE/Lectures/"
  echo "PDF -> ../$COURSE/Lectures/$BASE.pdf"
fi

echo "Cleaning up auxiliary files..."
latexmk -C "$TEX_FILE" >/dev/null 2>&1 || true
rm -f "$BASE".nav "$BASE".snm "$BASE".out "$BASE".toc "$BASE".aux "$BASE".bbl \
      "$BASE".blg "$BASE".log "$BASE".fdb_latexmk "$BASE".fls "$BASE".vrb \
      "$BASE".bcf "$BASE".run.xml "$BASE".synctex.gz 2>/dev/null || true

echo "Done."
