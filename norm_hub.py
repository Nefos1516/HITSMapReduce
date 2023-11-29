#!/usr/bin/python3
import sys
import os
from dotenv import load_dotenv


load_dotenv()
norm = float(os.getenv('NORM'))
for line in sys.stdin:
    kv = line.strip().split("\t")
    print(f'{kv[0]}\t{kv[1]}\t{kv[2] / norm}\t{kv[3]}')