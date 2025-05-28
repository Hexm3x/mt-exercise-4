#!/bin/bash

scripts=$(dirname "$0")
base=$scripts/..
translations=translations
models=models

# Snippet by ChatGPT - only installing prettytable if not already installed
if ! python3 -c "import prettytable" 2>/dev/null; then
    pip install prettytable
fi

# config_name for word level:
trans_con=transformer_sample_config
# model names - change if needed
model_word=word_level
model1=model_name_BPE_1000
model2=model_name_BPE_2000

# word level
filename_model_word=$models/$model_word/train.log
filename_model_word_1=$translations/$trans_con/bleu.txt

# BPE 1000
filename_model1=$models/$model1/train.log
filename_model1_1=$translations/$model1/bleu.txt

# BPE 2000
filename_model2=$models/$model2/train.log
filename_model2_1=$translations/$model2/bleu.txt

python3 $scripts/table_visualizer.py $filename_model_word $filename_model1 $filename_model2 $filename_model_word_1 $filename_model1_1 $filename_model2_1