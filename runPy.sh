#!/bin/bash
itr_count=3
itr=1
NORM=1

echo "Doing iteration $itr of $itr_count..."
hdfs dfs -rm -r PR/itr_$(itr)/hub
yarn jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
    -D mapreduce.job.name="HITS Job via Streaming" \
    -files $(pwd)/map_auth.py,$(pwd)/reduce_auth.py \
    -cmdenv NORM=$NORM \
    -input PR/itr_$itr/auth \
    -output PR/itr_$(itr)/hub \
    -mapper "python `pwd`/map_auth.py" \
    -reducer "python `pwd`/reduce_auth.py"
hdfs dfs -rm -r PR/itr_$((itr+1))/auth
NORM=$(hdfs dfs -tail PR/itr_(itr)/hub/part-00000)
yarn jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
    -D mapreduce.job.name="HITS Job via Streaming" \
    -files $(pwd)/map_hub.py,$(pwd)/reduce_hub.py \
    -cmdenv NORM=$NORM \
    -input PR/itr_$itr/hub \
    -output PR/itr_$((itr+1))/auth \
    -mapper "python `pwd`/map_hub.py" \
    -reducer "python `pwd`/reduce_hub.py"
for ((itr=2; itr <= $itr_count; itr++)); do
    echo "Doing iteration $itr of $itr_count..."
    hdfs dfs -rm -r PR/itr_$(itr)/hub
    NORM=$(hdfs dfs -tail PR/itr_(itr)/auth/part-00000)
    yarn jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
        -D mapreduce.job.name="HITS Job via Streaming" \
        -files $(pwd)/map_auth.py,$(pwd)/reduce_auth.py \
        -cmdenv NORM=$NORM \
        -input PR/itr_$itr/auth \
        -output PR/itr_$((itr))/hub \
        -mapper "python `pwd`/map_auth.py" \
        -reducer "python `pwd`/reduce_auth.py"
    hdfs dfs -rm -r PR/itr_$(itr+1)/auth
    NORM=$(hdfs dfs -tail PR/itr_(itr)/hub/part-00000)
    yarn jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
        -D mapreduce.job.name="HITS Job via Streaming" \
        -files $(pwd)/map_hub.py,$(pwd)/reduce_hub.py \
        -cmdenv NORM=$NORM \
        -input PR/itr_$itr/hub \
        -output PR/itr_$((itr+1))/auth \
        -mapper "python `pwd`/map_hub.py" \
        -reducer "python `pwd`/reduce_hub.py"
done
hdfs dfs -cat PR/itr_$((itr_count+1))/auth/part-00000