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

# measure time

SECONDS=0

model_name=transformer_sample_config

echo "###############################################################################"
echo "model_name $model_name"

translations_sub=$translations/$model_name

mkdir -p $translations_sub

CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.yaml < $data/test_100k.$src > $translations_sub/test.$model_name.$trg

# compute case-sensitive BLEU 

cat $translations_sub/test.$model_name.$trg | sacrebleu $data/test_100k.$trg | tee $translations_sub/bleu.txt


echo "time taken:"
echo "$SECONDS seconds"

# BPE 1000
# measure time

SECONDS=0

model_name1=model_name_BPE_1000

echo "###############################################################################"
echo "model_name $model_name1"

translations_sub=$translations/$model_name1

mkdir -p $translations_sub

CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name1.yaml < $data/test_100k.$src > $translations_sub/test.$model_name1.$trg

# compute case-sensitive BLEU 
$1000=1000 #vocabulary size
head -n $1000 $data/test_100k.$trg > $data/cut_$1000.$trg

cat $translations_sub/test.$model_name1.$trg | sacrebleu $data/cut_$1000.$trg | tee $translations_sub/bleu.txt



echo "time taken:"
echo "$SECONDS seconds"


# BPE 2000
# measure time

SECONDS=0

model_name2=model_name_BPE_2000

echo "###############################################################################"
echo "model_name $model_name2"

translations_sub=$translations/$model_name2

mkdir -p $translations_sub

CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name2.yaml < $data/test_100k.$src > $translations_sub/test.$model_name2.$trg

# compute case-sensitive BLEU 
$2000=2000 #vocabulary size
head -n $2000 $data/test_100k.$trg > $data/cut_$2000.$trg

cat $translations_sub/test.$model_name2.$trg | sacrebleu $data/cut_$2000.$trg | tee $translations_sub/bleu.txt


echo "time taken:"
echo "$SECONDS seconds"