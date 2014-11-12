#!/bin/bash
#
# This script conveniently launches HDFS, loads MongoDB, runs the spark app, and
# then launches MovieWeb.
#
# Assumptions:
# - This script has to be run inside the 'spark' directory.
# - A mongod instance is already running on port 27017.

# -- Extract dataset from mlsmall archive.
if [ ! -d ../dataset/mlsmall ]; then
    movielens_data=../dataset/mlsmall.tar.gz
    tar xzvf $movielens_data -C ../dataset/
fi

# -- Start HDFS.
bash $HADOOP_PREFIX/sbin/start-dfs.sh

# -- Set up Hadoop file structure.
do_dfs="$HADOOP_PREFIX/bin/hdfs dfs"
$do_dfs -mkdir /movielens
$do_dfs -put ../dataset/mlsmall/*.bson /movielens/

# -- Load dataset into MongoDB, so that it's easy to show off what the data looks like.
for file in $(ls ../dataset/mlsmall/*.bson); do
    mongorestore $file
done

# -- Start spark application. This takes a few minutes to run on the 'mlsmall' dataset.
# Read the spark directory from the first argument, or try to find it in the parent
# directory of HADOOP_PREFIX.
SPARK=${1:-$HADOOP_PREFIX/../spark*}
bash $SPARK/bin/spark-submit \
    --master local \
    --class com.mongodb.workshop.SparkExercise \
    --jars target/lib/mongo-hadoop-core-1.3.0.jar,target/lib/mongo-java-driver-2.12.3.jar,target/spark-1.0-SNAPSHOT.jar \
    target/spark-1.0-SNAPSHOT.jar hdfs://localhost:8020 mongodb://127.0.0.1:27017/movielens predictions

# -- Spark application has finished. Results are in the movielens.predictions collection.
# Launch the movieweb frontend.
python ../movieweb/app.py > ../movieweb/app.log &
