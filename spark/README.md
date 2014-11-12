# Spark Exercise

## Requirements

- [Java SE 1.7](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html)
- [Maven](http://maven.apache.org) (latest)
- [Spark 1.0 for Hadoop 2](http://spark.apache.org/downloads.html)

## Building

    $ mvn clean package

## Running

Running the Spark application and launching the MovieWeb application can be done as follows:

1. Install Python requirements:

    cd ../movieweb
    pip install -r requirements.txt

2. Start up a `mongod`:

    mkdir scratch
    mongod --dbpath scratch --logpath scratch/mongodb.log --fork

3. Run the launch script:

    bash launch.sh
