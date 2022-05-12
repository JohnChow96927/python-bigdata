package com.johnchow.flink.source;

import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

import java.util.Arrays;

public class StreamSourceCollectionDemo {

    public static void main(String[] args) throws Exception {
        // 1. 执行环境-env
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        env.setParallelism(1);

        // 2. 数据源-source
        // 方式一: 可变参数
        DataStreamSource<String> dataStream01 = env.fromElements("spark", "flink", "mapreduce");
        dataStream01.print();

        // 方式二: 集合对象
        DataStreamSource<String> dataStream02 = env.fromCollection(Arrays.asList("spark", "flink", "mapreduce"));
        dataStream02.printToErr();

        // 3. 数据转换-transformation

        // 4. 数据终端-sink

        // 5. 触发执行-execute
        env.execute("StreamSourceCollectionDemo");
    }

}
