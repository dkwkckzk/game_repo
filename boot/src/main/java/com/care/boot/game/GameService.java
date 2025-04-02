package com.care.boot.game;

import com.care.boot.gamedto.GameDTO;
import com.care.boot.gamedto.GameHistoryDTO;
import com.care.boot.gamedto.PlayerStatsDTO;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.AttributeValue;
import software.amazon.awssdk.services.dynamodb.model.GetItemRequest;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class GameService {

    private final GameMapper gameMapper; // MyBatis 매퍼 (game_history 관련만 사용)
    private final GameDynamoService gameDynamoService; // game_history 저장용 DynamoDB 서비스
    private final DynamoDbClient dynamoDbClient; // DynamoDB 직접 접근용 클라이언트

    public GameService(GameMapper gameMapper, GameDynamoService gameDynamoService, DynamoDbClient dynamoDbClient) {
        this.gameMapper = gameMapper;
        this.gameDynamoService = gameDynamoService;
        this.dynamoDbClient = dynamoDbClient;
    }

    /**
     * ✅ 게임 결과를 저장한다 (DynamoDB의 game_history 테이블에 기록)
     */
    public void saveGameResult(GameDTO playerGame, GameDTO opponentGame, boolean isMatchWin) {
        if (Objects.isNull(playerGame.getPlayDate())) {
            playerGame.setPlayDate(LocalDateTime.now());
        }
        if (Objects.isNull(opponentGame.getPlayDate())) {
            opponentGame.setPlayDate(LocalDateTime.now());
        }

        GameHistoryDTO playerHistory = convertToHistoryDTO(playerGame);
        GameHistoryDTO opponentHistory = convertToHistoryDTO(opponentGame);

        gameDynamoService.saveGameResult(playerHistory);
        gameDynamoService.saveGameResult(opponentHistory);
        // player_stats 점수 계산은 Lambda 트리거에서 처리하므로 여기서는 안 함
    }

    /**
     * 🧱 GameDTO → GameHistoryDTO로 변환하는 유틸리티 함수
     */
    private GameHistoryDTO convertToHistoryDTO(GameDTO dto) {
        GameHistoryDTO history = new GameHistoryDTO();
        history.setPlayer1Id(dto.getPlayer1Id());
        history.setPlayer2Id(dto.getPlayer2Id());
        history.setPlayer1Move(dto.getPlayer1Move());
        history.setPlayer2Move(dto.getPlayer2Move());
        history.setResult(dto.getResult());
        return history;
    }

    /**
     * ✅ DynamoDB의 player_stats 테이블에서 해당 플레이어의 전적 정보를 조회한다
     */
    public PlayerStatsDTO getPlayerStats(String playerId) {
        Map<String, AttributeValue> key = Map.of(
                "playerId", AttributeValue.builder().s(playerId).build()
        );

        GetItemRequest request = GetItemRequest.builder()
                .tableName("player_stats")
                .key(key)
                .build();

        try {
            Map<String, AttributeValue> item = dynamoDbClient.getItem(request).item();
            if (item == null || item.isEmpty()) return null;

            PlayerStatsDTO dto = new PlayerStatsDTO();
            dto.setPlayerId(playerId);
            dto.setScore(Integer.parseInt(item.getOrDefault("score", AttributeValue.fromN("0")).n()));
            dto.setTotalGames(Integer.parseInt(item.getOrDefault("total_games", AttributeValue.fromN("0")).n()));
            dto.setWins(Integer.parseInt(item.getOrDefault("wins", AttributeValue.fromN("0")).n()));
            dto.setLosses(Integer.parseInt(item.getOrDefault("losses", AttributeValue.fromN("0")).n()));
            dto.setDraws(Integer.parseInt(item.getOrDefault("draws", AttributeValue.fromN("0")).n()));

            int totalGames = dto.getTotalGames();
            int wins = dto.getWins();
            dto.setWinRate((totalGames > 0) ? (wins * 100.0 / totalGames) : 0);
            dto.setKing(dto.getScore() >= 1000);

            return dto;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * ❌ 랭킹 조회는 현재 구현되지 않음 (getRanking() 메서드가 없어 오류 발생 중)
     * 👉 아래는 임시로 빈 리스트 반환하는 대체 메서드
     */
    public List<PlayerStatsDTO> getRanking() {
        return new ArrayList<>();
    }

    /**
     * ✅ 해당 플레이어의 전체 게임 기록을 조회 (MySQL 기반 - 아직 유지 중)
     */
    public List<GameDTO> getGameHistory(String playerId) {
        return gameMapper.getGameHistory(playerId);
    }

    /**
     * ✅ 게임 기록 삭제 (MySQL 기반 - 아직 유지 중)
     */
    public boolean deleteGameRecord(int gameId) {
        return gameMapper.deleteGameRecord(gameId) > 0;
    }
}
