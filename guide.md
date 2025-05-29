# Guide

## Prerequisites:
venv:

  ```bash
  pip install virtualenv
  ```

Will make a virtual environment; activate it
   ```
   source venvs/torch3/bin/activate
   ```

Joeynmt, installed in editable mode, inside the base folder

moses (taken from assignment 3 to install sacremoses):
   ```
    scripts/moses.sh
   ```

data files to the language pair:
   ```
   scripts/download_iwslt_2017_data.sh
   ```

## General changes / Preparation for Tasks
Configs:
Created config files for word level and 2 bpe levels, adapted for not finished training

preprocess:
   ```
    scripts/prepropress.sh
   ```

Selecting scr / trg language (default nl / de), truncating, building vocabulary files, creating folders with necessary files for training
Contains unnecessary files as well but did not want to delete them as I did not want to re-check as training is going on

train:
   ```
    scripts/train.sh
   ```
Creates logs and models folder, creates a deduplicated vocabulary for BPE 2000 (vocabulary size = 2004) as deduplication was forgotten --> BPE 1000 does not have a deduplicated vocabulary file as the higher vocabulary size got noticed during its training and thus was not changed

Define best checkpoint by concatinating unfinished training (optional, if having had to take a break once and could not finish training)
   ```
    scripts/cat_best_step.sh
   ```
Creates best_steps folder, containing files with the best steps --> manually look at the files in best_steps, change config file with the highest step size (CRTL+F ckpt_path:)

## Task 1
evaluate:
WARNING: Make sure to use the correct checkpoint as our default is not the best as training could not be finished --> CRTL+F ckpt_path: in configs
word level, vocabulary size = 2004
   ```
    scripts/evaluate.sh
   ```

BPE level, vocabulary size = 1818
   ```
    scripts/evaluate_bpe_1000.sh
   ```

BPE level, vocabulary size = 2004
   ```
    scripts/evaluate_bpe_2000.sh
   ```

Create translations folder with the BLEU score and sample sentences for each model
All of them have beam size = 5

table visualizer:
   ```
    scripts/table_visualizer.sh
   ```

Will install prettytable if not already installed, will execute scripts/table_visualizer.py
Creates visualization folder, creates a table
- BLEU_Table.txt

## Task 2
Manually read BLEU_table from Task 1, take the model with the highest BLEU score and change the model name in best_generator.sh (default is the word level model)
Evaluate BLEU scores with different beam sizes for the best model + track time:
   ```
    scripts/best_generator.sh
   ```

Creates all_beam_result folder with subfolders that contain the BLEU score, sample text. Creates time_log.txt in all_beam_result that contains the time taken for generating the BLEU scores with sample sentences.
Beam size ranges from 1-10

bar visualizer:
   ```
    scripts/beam_time_visualize.sh
   ```

Will install matplotlib if not already installed, will execute scripts/beam_time_visualize.py
Will create two PNG files in the visualization folder
- Bar plot of Beam size and time taken (Beam_size_Time_plot.png)
- Bar plot of Beam size and BLEU score (Beam_size_BLEU_plot.png)
