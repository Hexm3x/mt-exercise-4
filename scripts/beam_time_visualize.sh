#!/bin/bash

scripts=$(dirname "$0")
base=$scripts/..
translations=translations
models=models
all_beam_result=$base/all_beam_result

# Snippet by ChatGPT - only installing matplotlib if not already installed
if ! python3 -c "import matplotlib" 2>/dev/null; then
    pip install matplotlib
fi

subfolders=($all_beam_result/transformer*) # change name if needed
python3 $scripts/beam_time_visualize.py ${subfolders[@]}
