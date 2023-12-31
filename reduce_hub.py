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
        norm += hub_score ** 2
        auth_score, hub_score = 0.0, 0.0
        links = ''
    if len(kv) > 3:
        links += f'{kv[3]};'
        hub_score += float(kv[1])
    else:
        hub_score += float(kv[1])
        auth_score = kv[1]
print(f'{node_id}\t{auth_score}\t{hub_score}\t{links[:len(links) - 1]}')
set_key('.env', 'NORM', str(math.sqrt(norm)))
