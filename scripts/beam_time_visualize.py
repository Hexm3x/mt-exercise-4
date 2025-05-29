import re
import matplotlib.pyplot as plt
import sys
from pathlib import Path

# Time / Beam size
time_list = []
model_list = []

model_time_pattern = r"model number: (\d+) time taken: (\d+)"
with open("all_beam_result/time_log.txt", "r") as t:
    time_log = t.read()

matches = re.findall(model_time_pattern, time_log)

for model, time in matches:
    model_list.append(int(model))
    time_list.append(int(time))

plt.bar(model_list, time_list)

plt.xlabel("Beam size")
plt.ylabel("Time [Seconds]")
plt.title("Time per Beam size")
plt.savefig("visualizations/Beam_size_Time_plot.png", dpi=300)
plt.close()

# BLEU / Beam size
folders = sys.argv[1:]
bleu_score = r'"score": (\d+\.\d+)'
beam_pattern = r'beam(\d+)'
bleu_list = []

for folder in folders:
    folder_str = str(folder)
    beam_match = re.search(beam_pattern, folder_str)
    beam_num = int(beam_match.group(1))

    # ChatGPT - probably would have done it with os
    bleu_file_path = Path(folder) / "bleu.txt"
    if bleu_file_path.exists():
        with open(bleu_file_path, "r") as b:
            content = b.read()
            match = re.search(bleu_score, content)
            if match:
                bleu = float(match.group(1))
                # ChatGPT - matching beam size with BLEU score (else it would do 1, 10, 2, ...)
                bleu_list.append((beam_num, bleu))

# ChatGPT
bleu_list.sort(key=lambda x: x[0])

# ChatGPT
beam_nums, bleu_scores = zip(*bleu_list)

plt.bar(beam_nums, bleu_scores)
plt.xlabel("Beam size")
plt.ylabel("BLEU score")
plt.title("BLEU score per Beam size")
plt.savefig("visualizations/Beam_size_BLEU_plot.png", dpi=300)
plt.close()
