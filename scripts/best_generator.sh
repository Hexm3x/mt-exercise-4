#!/bin/bash

scripts=$(dirname "$0")
base=$scripts/..
data=$base/nl-de

configs=$base/configs

num_threads=4
device=0

src=nl
trg=de

beam_results=$base/all_beam_result

# insert the model that you want to test on
model_name=transformer_sample_config 

mkdir -p $beam_results
time_log="$beam_results/time_log.txt" # time log idea by ChatGPT

> "$time_log"
# ChatGPT told me how to do loops in .sh (I would have copy-pasted the command)
for nr in {1..10}; do # ten different beam sizes - beam size can be changed here
    
    tmp_config="$configs/tmp_$model_name.yaml" # ChatGPT being smart as always and making a temporary file with different beam sizes
    cp "$configs/$model_name.yaml" "$tmp_config"
    sed -i "s/beam_size: .*/beam_size: $nr/" "$tmp_config"

    output_dir="$beam_results/$model_name-beam$nr"
    mkdir -p "$output_dir"

    SECONDS=0
    CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate "$tmp_config"  < $data/test_100k.$src > $output_dir/hypotheses.txt

    hypotheses=$output_dir/hypotheses.txt
    reference=$data/test_100k.$trg

    sacrebleu "$reference" < "$hypotheses" | tee "$output_dir/bleu.txt"
    echo "model number:" $nr "time taken:" $SECONDS >> $time_log # append time to the others
    rm "$tmp_config"
done