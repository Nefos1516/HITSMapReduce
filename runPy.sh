#!/bin/bash
itr_count=3
for ((itr=1; itr <= $itr_count; itr++)); do
    echo "Doing iteration $itr of $itr_count..."
    hdfs dfs -rm -r PR/itr_$((itr))/hub
    yarn jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
        -D mapreduce.job.name="PageRank Job via Streaming" \
        -files $(pwd)/map_auth.py,$(pwd)/reduce_auth.py \
        -input PR/itr_$itr/auth \
        -output PR/itr_$((itr))/hub \
        -mapper $(pwd)/map_auth.py \
        -reducer $(pwd)/reduce_auth.py
    hdfs dfs -rm -r PR/itr_$((itr+1))/auth
    yarn jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
        -D mapreduce.job.name="PageRank Job via Streaming" \
        -files $(pwd)/map_hub.py,$(pwd)/reduce_hub.py \
        -input PR/itr_$itr/hub \
        -output PR/itr_$((itr+1))/auth \
        -mapper $(pwd)/map_hub.py \
        -reducer $(pwd)/reduce_hub.py
done
hdfs dfs -cat PR/itr_$((itr_count+1))/auth/part-00000