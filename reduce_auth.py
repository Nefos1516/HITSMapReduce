#!/usr/bin/python3
import math
import sys
import os

norm = 0
old_node_id, node_id, links = None, None, None
auth_score, hub_score = 0.0, 0.0
for line in sys.stdin:
    kv = line.strip().split('\t')
    old_node_id = node_id
    node_id = kv[0]
    if old_node_id is not None and old_node_id != node_id:
        print(f'{old_node_id}\t{auth_score}\t{hub_score}\t{links}')
        norm += auth_score ** 2
        auth_score, hub_score = 0.0, 0.0
        links = None
    if len(kv) > 3:
        links = kv[3]
        hub_score = kv[2]
    else:
        auth_score += float(kv[2])
os.environ['NORM'] = str(math.sqrt(norm))
print(f'{node_id}\t{auth_score}\t{hub_score}\t{links}')