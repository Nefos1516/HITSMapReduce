#!/usr/bin/python3
import sys
import os

norm = os.environ['NORM']
for line in sys.stdin:
    kv = line.strip().split("\t")
    node_id = kv[0]
    links = kv[3].split(';')
    auth_score, hub_score = kv[1:2]
    for link in links:
        print(f'{link}\t{auth_score / norm}\t{hub_score}')
    print(f'{node_id}\t{auth_score / norm}\t{hub_score}\t{";".join(links)}')