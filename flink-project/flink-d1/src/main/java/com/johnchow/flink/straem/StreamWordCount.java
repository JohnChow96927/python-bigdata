package com.johnchow.flink.straem;

import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.datastream.SingleOutputStreamOperator;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.util.Collector;

/**
 * 使用Flink计算引擎实现实时流计算：词频统计WordCount，从TCP Socket消费数据，结果打印控制台。
 * 1.执行环境-env
 * 2.数据源-source
 * 3.数据转换-transformation
 * 4.数据接收器-sink
 * 5.触发执行-execute
 */
public class StreamWordCount {

    public static void main(String[] args) throws Exception {
        // 1.执行环境-env
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        // 2.数据源-source
        DataStreamSource<String> inputDataStream = env.socketTextStream("node1.itcast.cn", 9999);

        // 3.数据转换-transformation
        SingleOutputStreamOperator<Tuple2<String, Integer>> resultDataStream = inputDataStream
                // 3-1. 分割单词
                .flatMap(new FlatMapFunction<String, String>() {
                    @Override
                    public void flatMap(String line, Collector<String> out) throws Exception {
                        for (String word : line.trim().split("\\s+")) {
                            out.collect(word);
                        }
                    }
                })
                // 3-2. 转换二元组
                .map(new MapFunction<String, Tuple2<String, Integer>>() {
                    @Override
                    public Tuple2<String, Integer> map(String word) throws Exception {
                        return new Tuple2<>(word, 1);
                    }
                })
                // 3-3. 分组和组内求和
                .keyBy(0).sum(1);

        // 4.数据接收器-sink
        resultDataStream.print();

        // 5.触发执行-execute
        env.execute("StreamWordCount");
    }

}