#!/usr/bin/python3
import sys
import os

norm = float(os.environ['NORM'])
for line in sys.stdin:
    kv = line.strip().split("\t")
    node_id = kv[0]
    links = kv[3].split(';')
    auth_score, hub_score = kv[1], float(kv[2])
    for link in links:
        print(f'{link}\t{auth_score}\t{hub_score / norm}')
    print(f'{node_id}\t{auth_score}\t{hub_score / norm}\t{";".join(links)}')
