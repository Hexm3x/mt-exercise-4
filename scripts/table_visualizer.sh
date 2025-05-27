#!/bin/bash

scripts=$(dirname "$0")
base=$scripts/..

configs=$base/configs

bleu_results=$base/bleu_results
mkdir -p $bleu_results
log="$bleu_results/log.txt"

num_threads=4

for fil in $configs/*.yaml; do
    SECONDS=0
    filename=$(basename "$fil" .yaml) # ChatGPT's work
    python3 -m joeynmt test $fil --output_path $bleu_results/${filename}-bleu.txt # kind of ChatGPT as well - I did not know about {}
    echo "Time taken for $filename:" $SECONDS "seconds" >> $log # append
done

# Getting the BLEU scores table for all models
# python3 BLEU_all_model.py
