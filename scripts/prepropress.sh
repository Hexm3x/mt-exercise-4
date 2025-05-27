#!/bin/bash

scripts=$(dirname "$0")
base=$scripts/..

configs=$base/configs


num_threads=4

# measure time

SECONDS=0


# Change this for different languages
scr=nl
trg=de

# Change this for different vocabulary size (if changing vocabulary size, please rename model_name_BPE and change the vocabulary size inside those yaml documents)
number_s_1000=1000
number_s_2000=2000


model_name=transformer_sample_config # Word level
# To run them in one single session
model_name_BPE_1000=transformer_BPE_$number_s_1000 # BPE with vocab size = 1000
model_name_BPE_2000=transformer_BPE_$number_s_2000 # BPE with vocab size = 2000

# Preprocessing:
# cut off number:
head_100000=100000

data=$base/data
model_language=$scr-$trg
mkdir -p $base/$model_language

# Thanks to ChatGPT for telling me to use head (no need to randomize)
head -n $head_100000 $data/train.$model_language.$trg > $base/$model_language/train_100k.$trg 
head -n $head_100000 $data/train.$model_language.$scr > $base/$model_language/train_100k.$scr 

# Apparently one has to apply BPE to dev and test as well - according to ChatGPT
head -n $head_100000 $data/dev.$model_language.$trg > $base/$model_language/dev_100k.$trg
head -n $head_100000 $data/dev.$model_language.$scr > $base/$model_language/dev_100k.$scr

head -n $head_100000 $data/test.$model_language.$trg > $base/$model_language/test_100k.$trg
head -n $head_100000 $data/test.$model_language.$scr > $base/$model_language/test_100k.$scr

# For whole word level
cat $base/$model_language/train_100k.$scr $base/$model_language/train_100k.$trg > $base/$model_language/train.joint
cat $base/$model_language/dev_100k.$scr $base/$model_language/dev_100k.$trg > $base/$model_language/dev.joint
cat $base/$model_language/test_100k.$scr $base/$model_language/train_100k.$trg > $base/$model_language/test.joint

# How to make BPE - by ChatGPT, modified for own need
# BPE 1000
BPE_1000=$model_language-bpe-$number_s_1000
mkdir -p $base/$BPE_1000

subword-nmt learn-bpe --total-symbols -s $number_s_1000 < $base/$model_language/train.joint > $base/$BPE_1000/$model_language-codes_$number_s_1000.bpe

subword-nmt apply-bpe -c $base/$BPE_1000/$model_language-codes_$number_s_1000.bpe < $base/$model_language/train_100k.$scr > $base/$BPE_1000/train.$scr
subword-nmt apply-bpe -c $base/$BPE_1000/$model_language-codes_$number_s_1000.bpe < $base/$model_language/train_100k.$trg > $base/$BPE_1000/train.$trg

subword-nmt apply-bpe -c $base/$BPE_1000/$model_language-codes_$number_s_1000.bpe < $base/$model_language/dev_100k.$scr > $base/$BPE_1000/dev.$scr
subword-nmt apply-bpe -c $base/$BPE_1000/$model_language-codes_$number_s_1000.bpe < $base/$model_language/dev_100k.$trg > $base/$BPE_1000/dev.$trg

subword-nmt apply-bpe -c $base/$BPE_1000/$model_language-codes_$number_s_1000.bpe < $base/$model_language/test_100k.$scr > $base/$BPE_1000/test.$scr
subword-nmt apply-bpe -c $base/$BPE_1000/$model_language-codes_$number_s_1000.bpe < $base/$model_language/test_100k.$trg > $base/$BPE_1000/test.$trg

subword-nmt get-vocab < $base/$BPE_1000/train.$scr > $base/$BPE_1000/vocab1_$number_s_1000.txt
subword-nmt get-vocab < $base/$BPE_1000/train.$trg > $base/$BPE_1000/vocab2_$number_s_1000.txt

cat $base/$BPE_1000/vocab1_$number_s_1000.txt $base/$BPE_1000/vocab2_$number_s_1000.txt > $base/$BPE_1000/joint_vocab_$number_s_1000.txt
cat $base/$BPE_1000/train.$scr $base/$BPE_1000/train.$trg > $base/$BPE_1000/train_$number_s_1000.joint
cat $base/$BPE_1000/dev.$scr $base/$BPE_1000/dev.$trg > $base/$BPE_1000/dev_$number_s_1000.joint
cat $base/$BPE_1000/test.$scr $base/$BPE_1000/test.$trg > $base/$BPE_1000/test_$number_s_1000.joint

# BPE 2000
BPE_2000=$model_language-bpe-$number_s_2000
mkdir -p $base/$BPE_2000

subword-nmt learn-bpe --total-symbols -s $number_s_2000 < $base/$model_language/train.joint > $base/$BPE_2000/$model_language-codes_$number_s_2000.bpe

subword-nmt apply-bpe -c $base/$BPE_2000/$model_language-codes_$number_s_2000.bpe < $base/$model_language/train_100k.$scr > $base/$BPE_2000/train.$scr
subword-nmt apply-bpe -c $base/$BPE_2000/$model_language-codes_$number_s_2000.bpe < $base/$model_language/train_100k.$trg > $base/$BPE_2000/train.$trg

subword-nmt apply-bpe -c $base/$BPE_2000/$model_language-codes_$number_s_2000.bpe < $base/$model_language/dev_100k.$scr > $base/$BPE_2000/dev.$scr
subword-nmt apply-bpe -c $base/$BPE_2000/$model_language-codes_$number_s_2000.bpe < $base/$model_language/dev_100k.$trg > $base/$BPE_2000/dev.$trg

subword-nmt apply-bpe -c $base/$BPE_2000/$model_language-codes_$number_s_2000.bpe < $base/$model_language/test_100k.$scr > $base/$BPE_2000/test.$scr
subword-nmt apply-bpe -c $base/$BPE_2000/$model_language-codes_$number_s_2000.bpe < $base/$model_language/test_100k.$trg > $base/$BPE_2000/test.$trg

subword-nmt get-vocab < $base/$BPE_2000/train.$scr > $base/$BPE_2000/vocab1_$number_s_2000.txt
subword-nmt get-vocab < $base/$BPE_2000/train.$trg > $base/$BPE_2000/vocab2_$number_s_2000.txt

cat $base/$BPE_2000/vocab1_$number_s_2000.txt $base/$BPE_2000/vocab2_$number_s_2000.txt > $base/$BPE_2000/joint_vocab_$number_s_2000.txt
cat $base/$BPE_2000/train.$scr $base/$BPE_2000/train.$trg > $base/$BPE_2000/train_$number_s_2000.joint
cat $base/$BPE_2000/dev.$scr $base/$BPE_2000/dev.$trg > $base/$BPE_2000/dev_$number_s_2000.joint
cat $base/$BPE_2000/test.$scr $base/$BPE_2000/test.$trg > $base/$BPE_2000/test_$number_s_2000.joint

echo "time taken:"
echo "$SECONDS seconds"