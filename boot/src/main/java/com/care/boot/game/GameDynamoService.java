package com.care.boot.game;

import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.AttributeValue;
import software.amazon.awssdk.services.dynamodb.model.PutItemRequest;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import com.care.boot.gamedto.GameHistoryDTO;

public class GameDynamoService {

    private final DynamoDbClient client;
    private final String tableName = "GameHistory";

    public GameDynamoService(DynamoDbClient client) {
        this.client = client;
    }

    public void saveGameResult(GameHistoryDTO dto) {
        Map<String, AttributeValue> item = new HashMap<>();
        item.put("gameId", AttributeValue.fromS(UUID.randomUUID().toString()));
        item.put("player1Id", AttributeValue.fromS(dto.getPlayer1Id()));
        item.put("player2Id", AttributeValue.fromS(dto.getPlayer2Id()));
        item.put("player1Move", AttributeValue.fromS(dto.getPlayer1Move()));
        item.put("player2Move", AttributeValue.fromS(dto.getPlayer2Move()));
        item.put("result", AttributeValue.fromS(dto.getResult()));
        item.put("playDate", AttributeValue.fromS(Instant.now().toString())); // ISO-8601

        PutItemRequest request = PutItemRequest.builder()
                .tableName(tableName)
                .item(item)
                .build();

        client.putItem(request);
    }
}
