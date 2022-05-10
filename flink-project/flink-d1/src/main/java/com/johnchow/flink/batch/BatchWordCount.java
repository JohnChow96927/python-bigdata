package com.johnchow.flink.batch;

import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.api.java.ExecutionEnvironment;
import org.apache.flink.api.java.operators.AggregateOperator;
import org.apache.flink.api.java.operators.DataSource;
import org.apache.flink.api.java.operators.FlatMapOperator;
import org.apache.flink.api.java.operators.MapOperator;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.util.Collector;

/**
 * 使用Flink计算引擎实现离线批处理：词频统计WordCount
 * 1.执行环境-env
 * 2.数据源-source
 * 3.数据转换-transformation
 * 4.数据接收器-sink
 * 5.触发执行-execute
 */
public class BatchWordCount {

    public static void main(String[] args) throws Exception {
        // 1.执行环境-env
        ExecutionEnvironment env = ExecutionEnvironment.getExecutionEnvironment();

        // 2.数据源-source
        DataSource<String> inputDataSet = env.readTextFile("datas/wordcount.data");

        // 3.数据转换-transformation
		/*
			spark flink spark hbase spark
						|flatMap
			分割单词: spark, flink, spark
						|map
			转换二元组：(spark, 1)  (flink, 1) (spark, 1)， TODO：Flink Java API中提供元组类Tuple
						|groupBy(0)
			分组：spark -> [(spark, 1), (spark, 1)]  flink -> [(flink, 1)]
						|sum(1)
			求和：spark -> 1 + 1 = 2,   flink = 1
		 */
        // 3-1. 分割单词
        FlatMapOperator<String, String> wordDataSet = inputDataSet.flatMap(new FlatMapFunction<String, String>() {
            @Override
            public void flatMap(String line, Collector<String> out) throws Exception {
                String[] words = line.trim().split("\\s+");
                for (String word : words) {
                    out.collect(word);
                }
            }
        });

        // 3-2. 转换二元组
        MapOperator<String, Tuple2<String, Integer>> tupleDataSet = wordDataSet.map(new MapFunction<String, Tuple2<String, Integer>>() {
            @Override
            public Tuple2<String, Integer> map(String word) throws Exception {
                return Tuple2.of(word, 1);
            }
        });

        // 3-3. 分组及求和, TODO: 当数据类型为元组时，可以使用下标指定元素，从0开始
        AggregateOperator<Tuple2<String, Integer>> resultDataSet = tupleDataSet.groupBy(0).sum(1);

        // 4.数据接收器-sink
        resultDataSet.print();

        // 5.触发执行-execute， TODO：批处理时，无需触发，流计算必须触发执行
        //env.execute("BatchWordCount") ;
    }

}