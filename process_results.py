import csv
import re
import os

input_file = r"C:\Users\ganes\.gemini\antigravity-ide\brain\593daa54-f5c2-432d-85fe-ba03377a15d3\browser\scratchpad_3jegfkcd.md"
output_file = r"d:\Btech\PROJECTS\venkat\exam_results.csv"

unique_names = set()
data = []

with open(input_file, 'r', encoding='utf-8') as f:
    for line in f:
        # Match lines like "1. Name | email | score"
        match = re.match(r'^\d+\.\s+(.*?)\s*\|\s*(.*?)\s*\|\s*(.*)$', line.strip())
        if match:
            name = match.group(1).strip()
            email = match.group(2).strip()
            score = match.group(3).strip()
            
            # case insensitive duplicate check
            name_lower = name.lower()
            if name_lower not in unique_names:
                unique_names.add(name_lower)
                data.append([name, email, score])

with open(output_file, 'w', newline='', encoding='utf-8-sig') as f:
    writer = csv.writer(f)
    writer.writerow(['Name', 'Email', 'Score'])
    writer.writerows(data)

print(f"Processed {len(data)} unique students out of the extracted list.")
