import re
from prettytable import PrettyTable
import sys

# Taken from exercise 3, adapted for own need

# ChatGPT improvement of not listing all sys
train_logs = sys.argv[1:4]
bleu_files = sys.argv[4:7]

# Patterns:
model_name = r'cfg.name : (.*)'
level = r'level=(bpe|word)'
vocab_size = r'Number of unique Src tokens \(vocab_size\): (\d+)'
bleu_score = r'"score": (\d+\.\d+)'

# initialize lists
list_model_name = []
list_level = []
list_vocab_size = []
list_bleu_score = []

# open files
for train_log in train_logs:
    with open(train_log, "r") as t:
        train = t.read()

        name_match = re.search(model_name, train)
        level_match = re.search(level, train)
        vocab_match = re.search(vocab_size, train)
        # ChatGPT helping again with the grouping and the if statement
        list_model_name.append(name_match.group(1) if name_match else "N/A")
        list_level.append(level_match.group(1) if level_match else "N/A")
        list_vocab_size.append(vocab_match.group(1) if vocab_match else "N/A")

for bleu_file in bleu_files:
    with open(bleu_file, "r") as b:
        bleu = b.read()
        bleu_match = re.search(bleu_score, bleu)
        list_bleu_score.append(bleu_match.group(1) if bleu_match else "N/A")

# Initialize PrettyTable - a small introduction can be found here: https://www.geeksforgeeks.org/creating-tables-with-prettytable-library-python/
columns = [list_model_name, list_level, list_vocab_size, list_bleu_score]
column_names = ["Model name", "Level", "Vocabulary size", "BLEU score"]

validation_table = PrettyTable()

# good idea of ChatGPT to use zip to reduce lines of codes and errors
for name, column in zip(column_names, columns):
    validation_table.add_column(name, column)

# save the data - discussion is found here: https://stackoverflow.com/questions/22431252/how-do-i-save-table-from-prettytable
validation_BLEU_prettytable = str(validation_table)
with open('BLEU_Table.txt', 'w') as f:
    f.write(validation_BLEU_prettytable)
