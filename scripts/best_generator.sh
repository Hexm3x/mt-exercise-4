#!/bin/bash

scripts=$(dirname "$0")
base=$scripts/..

configs=$base/configs


num_threads=4

beam_results=$base/beam_results

# insert the model that you want to test on
best_model=modelname 

mkdir -p $beam_results
time_log="$beam_results/time_log.txt" # time log idea by ChatGPT

# ChatGPT told me how to do loops in .sh (I would have copy-pasted the command - like I already did before)
for nr in 1, 2, 3, 4, 5, 6, 7, 8, 9, 10; do # ten different beam sizes - beam size can be changed here
    # ChatGPT told me that joeynmt translate is more flexible in regards to beam size (does not need multiple yaml files)
    SECONDS=0
    python3 -m joeynmt translate $configs/$best_model.yaml --beam_size $nr --output_path $beam_results/$best_model-$nr-beam.txt
    echo "model number:" $nr "time taken:" $SECONDS >> $time_log # append time to the others
done

# Getting the BLEU scores with various beam sizes plus visualizations for the best model
python3 BLEU_best_model.py
