#!/usr/bin/python3
import math
import sys
from dotenv import set_key

norm = 0
old_node_id, node_id, links = None, None, ''
auth_score, hub_score = 0.0, 0.0
for line in sys.stdin:
    kv = line.strip().split('\t')
    old_node_id = node_id
    node_id = kv[0]
    if old_node_id is not None and old_node_id != node_id:
        print(f'{old_node_id}\t{auth_score}\t{hub_score}\t{links[:len(links) - 1]}')
        norm += auth_score ** 2
        auth_score, hub_score = 1.0, 1.0
        links = ''
    if len(kv) > 3:
        links += f'{kv[3]};'
        auth_score += float(kv[2])
    else:
        auth_score += float(kv[1])
        hub_score = kv[2]
print(f'{node_id}\t{auth_score}\t{hub_score}\t{links[:len(links) - 1]}')
set_key('.env', 'NORM', str(math.sqrt(norm)))
