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

# BPE 1000
# measure time

SECONDS=0

VOCAB_SIZE=1818
model_name1=model_name_BPE_1000

echo "###############################################################################"
echo "model_name1 $model_name1"

translations_sub=$translations/$model_name1
mkdir -p $translations_sub

# translate using JoeyNMT
CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name1.yaml < $data/test_100k.$src > $translations_sub/test.$model_name1.$trg

# trim target to match for fair BLEU
head -n $VOCAB_SIZE $data/test_100k.$trg > $data/cut_${VOCAB_SIZE}.$trg

# compute BLEU score
cat $translations_sub/test.$model_name1.$trg | sacrebleu $data/cut_${VOCAB_SIZE}.$trg | tee $translations_sub/bleu.txt

echo "Done evaluating BPE model with vocab size $VOCAB_SIZE."

echo "time taken:"
echo "$SECONDS seconds"