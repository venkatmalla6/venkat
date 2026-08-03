import urllib.request
import json
import csv
import re
import os

url = 'https://result-11638.web.app/data.js'
output_file = r"d:\Btech\PROJECTS\venkat\exam_results.csv"

try:
    print("Fetching data.js...")
    req = urllib.request.urlopen(url)
    js_content = req.read().decode('utf-8')

    print("Extracting JSON...")
    # Find the array assigned to studentData
    match = re.search(r'const\s+studentData\s*=\s*(\[\s*\{.*?\}\s*\])\s*(?:;|$)', js_content, flags=re.DOTALL)
    if match:
        json_str = match.group(1)
        
        print("Parsing JSON...")
        data = json.loads(json_str)
        
        unique_names = set()
        rows = []
        
        for item in data:
            name = str(item.get('username', '')).strip()
            email = str(item.get('email', '')).strip()
            score = item.get('correct_answers', '')
            
            # Skip completely empty names if any
            if not name:
                continue
                
            name_lower = name.lower()
            if name_lower not in unique_names:
                unique_names.add(name_lower)
                rows.append([name, email, score])
                
        print("Writing to CSV...")
        with open(output_file, 'w', newline='', encoding='utf-8-sig') as f:
            writer = csv.writer(f)
            writer.writerow(['Name', 'Email', 'Score'])
            writer.writerows(rows)
            
        print(f"SUCCESS: Processed {len(rows)} unique students out of {len(data)} total entries.")
    else:
        print("Could not find studentData array in data.js")
except Exception as e:
    print(f"Error: {e}")
