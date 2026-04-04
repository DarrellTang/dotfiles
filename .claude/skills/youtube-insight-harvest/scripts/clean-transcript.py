#!/usr/bin/env python3
"""Clean SRT transcript: strip timestamps, deduplicate lines, output plain text."""

import re
import sys

def clean_srt(input_path, output_path):
    with open(input_path, 'r') as f:
        content = f.read()

    lines = content.split('\n')
    text_lines = []
    for line in lines:
        line = line.strip()
        if not line:
            continue
        if re.match(r'^\d+$', line):
            continue
        if re.match(r'^\d{2}:\d{2}:\d{2}', line):
            continue
        text_lines.append(line)

    deduped = []
    for line in text_lines:
        if not deduped or line != deduped[-1]:
            deduped.append(line)

    text = ' '.join(deduped)
    text = re.sub(r' +', ' ', text)

    with open(output_path, 'w') as f:
        f.write(text)

    word_count = len(text.split())
    print(f"Words: {word_count}")
    print(f"Output: {output_path}")

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: clean-transcript.py <input.srt> <output.txt>")
        sys.exit(1)
    clean_srt(sys.argv[1], sys.argv[2])
