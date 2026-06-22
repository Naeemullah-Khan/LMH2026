# LMH2026 repository structure

## Layout

```
LMH2026/
├── latex/                      # Shared LaTeX project (compile from here)
│   ├── preamble/               #   shared \input{preamble/...}
│   ├── sections/               #   shared slide content \input{sections/...}
│   ├── images/                 #   shared figures
│   ├── assets/                 #   shared per-lecture assets
│   ├── style_files/            #   logos + .sty helpers
│   ├── *.sty *.cls references.bib   # beamer theme + bib (build deps)
│   ├── build.sh                #   build script (see below)
│   ├── CV/                     #   compilable main .tex  (31 files)
│   ├── NLP/                    #   compilable main .tex  (21 files)
│   ├── GenAI/                  #   compilable main .tex  (11 files)
│   ├── IntroToAI/              #   compilable main .tex  (8 files)
│   ├── RL/                     #   compilable main .tex  (4 files)
│   └── Review_needed/          #   draft "New-Lecture" main .tex (10 files)
│
├── CV/        Lectures/ (pdf)  Labs/ (ipynb, + Homeworks/)   CV Content.docx
├── NLP/       Lectures/ (pdf)  Labs/ (ipynb, + Homeworks/)   NLP content.docx
├── GenAI/     Lectures/ (pdf)  Labs/ (ipynb)                 GenAI Content.docx
├── IntroToAI/ Lectures/ (pdf)  Labs/ (ipynb, + Homeworks/)   Intro Content.docx
├── RL/        Lectures/ (pdf)  Labs/ (ipynb, + Homeworks/)
├── Review_needed/  Lectures/ (pdf)
├── Incomplete_Labs/            # cross-course WIP notebooks (not per-course)
└── Exams/                      # 2025 / 2026 exam material (cross-course)
```

The compilable decks live under `latex/<Course>/`, but the `sections/`,
`preamble/`, `images/` etc. are **shared** (kept intact, not duplicated per
course). LaTeX resolves `\input{sections/...}` relative to the build working
directory, so builds must run from `latex/`.

## Building a deck

```bash
cd latex
./build.sh --file CV/Day-1_CNN_Recap.tex          # -> ../CV/Lectures/Day-1_CNN_Recap.pdf
./build.sh --file NLP/Lecture-9_Prompting+RAG.tex
./build.sh --file CV/Day-1_CNN_Recap.tex --no-move # leave PDF in latex/ for preview
```

(Verified: `CV/Day-1_CNN_Recap.tex` compiles to a 69-page PDF from this layout.)

## Course organisation

Each course has its compilable decks under `latex/<Course>/`, its compiled
slides under `<Course>/Lectures/`, and its notebooks under `<Course>/Labs/`
(with `Homeworks/` where applicable).

Notes:
- **GenAI** `Labs/` are curated from the CV, NLP, and `New_Labs/` notebooks,
  copied in and prefixed `NN_` to match the lecture day they support.
- `Incomplete_Labs/` and `Exams/` span multiple courses and are kept at the top
  level rather than split per course.
