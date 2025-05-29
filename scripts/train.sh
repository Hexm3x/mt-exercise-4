#!/bin/bash

scripts=$(dirname "$0")
base=$scripts/..

models=$base/models
configs=$base/configs

mkdir -p $models

num_threads=4

# measure time

SECONDS=0

logs=$base/logs

model_name="transformer_sample_config" # Word level
# To run them in one single session
model_name_BPE_1000="model_name_BPE_1000" # BPE with vocab size = 1000
model_name_BPE_2000="model_name_BPE_2000" # BPE with vocab size = 2000

mkdir -p $logs

mkdir -p $logs/$model_name
# To run them in one single session
mkdir -p $logs/$model_name_BPE_2000
mkdir -p $logs/$model_name_BPE_1000

# Train:
OMP_NUM_THREADS=$num_threads python3 -m joeynmt train $configs/$model_name.yaml > $logs/$model_name/out 2> $logs/$model_name/err

echo "time taken:"
echo "$SECONDS seconds"

# To run them in one single session
# Train:
SECONDS=0

OMP_NUM_THREADS=$num_threads python3 -m joeynmt train $configs/$model_name_BPE_1000.yaml > $logs/$model_name_BPE_1000/out 2> $logs/$model_name_BPE_1000/err

echo "time taken:"
echo "$SECONDS seconds"

# My bad, I forgot to deduplicate - I realized during the "1000" (in reality, it has a vocab size of 1818 - probably with many duplicates which may make training time longer (according to ChatGPT - it will probably not affect the result drastically, I cannot check that)) vocab file training so I did not adapt it anymore
deduplicate_2000=nl-de-bpe-2000
# head -n 2000 used to really only take (roughly) 2000 vocabulary, with some specials I guess (2004)
cat ./$deduplicate_2000/vocab1_2000.txt ./$deduplicate_2000/vocab2_2000.txt | cut -f1 | sort | uniq | head -n 2000 > ./$deduplicate_2000/joint_vocab_2000_dedu.txt 

# Train:
SECONDS=0

OMP_NUM_THREADS=$num_threads python3 -m joeynmt train $configs/$model_name_BPE_2000.yaml > $logs/$model_name_BPE_2000/out 2> $logs/$model_name_BPE_2000/err

echo "time taken:"
echo "$SECONDS seconds"
