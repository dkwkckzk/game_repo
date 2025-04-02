package com.care.boot.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.regions.Region;

import com.care.boot.game.GameDynamoService;

@Configuration
public class DynamoDbConfig {

    // ✅ DynamoDB 클라이언트 Bean 등록
    @Bean
    public DynamoDbClient dynamoDbClient() {
        return DynamoDbClient.builder()
            .region(Region.AP_NORTHEAST_2) // 서울 리전
            .build();
    }

    // ✅ GameDynamoService도 직접 등록
    @Bean
    public GameDynamoService gameDynamoService(DynamoDbClient client) {
        return new GameDynamoService(client);
    }
}
