#!/bin/bash

scripts=$(dirname "$0")
base=$scripts/..

best_steps=$base/best_steps
mkdir -p $best_steps

models=$base/models

# Concatenates validation files from different folders and saves the best step (needed for evaluate.sh). Useful if multiple training were used and the training hasn't ended
model_name="word_level"
model_name_new="word_level_new"

model_name1="model_name_BPE_1000"
model_name1_new="model_name_BPE_1000_new"

model_name2="model_name_BPE_2000"
model_name2_new="model_name_BPE_2000_new"

#Whole word
cat $models/$model_name/validations.txt  $models/$model_name_new/validations.txt | grep '\*$' | tail -n 1 > $best_steps/best_step_$model_name.txt
# 1000
cat $models/$model_name1/validations.txt  $models/$model_name1_new/validations.txt | grep '\*$' | tail -n 1 > $best_steps/best_step_$model_name1.txt
# 2000
cat $models/$model_name2/validations.txt  $models/$model_name2_new/validations.txt | grep '\*$' | tail -n 1 > $best_steps/best_step_$model_name2.txt
