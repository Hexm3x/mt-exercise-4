#! /bin/bash

scripts=$(dirname "$0")
base=$scripts/..

data=$base/nl-de
configs=$base/configs

translations=$base/translations

mkdir -p $translations

src=nl
trg=de


num_threads=4
device=0

# vocabulary size - change if needed
vocab_size_2000=2004

# measure time

SECONDS=0

model_name=transformer_sample_config

echo "###############################################################################"
echo "model_name $model_name"

translations_sub=$translations/$model_name

mkdir -p $translations_sub

CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.yaml < $data/test_100k.$src > $translations_sub/test.$model_name.$trg

# compute case-sensitive BLEU 

cat $translations_sub/test.$model_name.$trg | sacrebleu $data/test_100k.$trg | tee $translations_sub//$model_name-bleu-$vocab_size_2000.txt # ChatGPT had the great idea to save the file


echo "time taken:"
echo "$SECONDS seconds"