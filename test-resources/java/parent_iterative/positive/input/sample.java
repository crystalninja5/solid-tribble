package com.piranha;

import org.apache.spark.SparkConf;
import org.apache.spark.sql.SparkSession;

class Sample {
  void main() {
  
    val conf1 = new SparkConf()
      .setMaster(master1)
      .setAppName(appName1)
      .setExecutorEnv("spark.executor.extraClassPath1", "test1");

    val conf2 = new SparkConf()
      .setAppName(appName2)
      .setMaster(master2)
      .setSparkHome(sparkHome2)
      .setExecutorEnv("spark.executor.extraClassPath2", "test2");

    val conf3 = new SparkConf()
      .setExecutorEnv("spark.executor.extraClassPath3", "test3")
      .setAppName(appName3)
      .setMaster(master3)
      .setSparkHome(sparkHome3);
  }
}
