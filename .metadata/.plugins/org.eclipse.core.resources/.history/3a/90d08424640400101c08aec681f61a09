package com.care.boot.game;

import com.care.boot.gamedto.GameDTO;
import com.care.boot.gamedto.PlayerStatsDTO;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
public class GameService {

    private final GameMapper gameMapper;

    public GameService(GameMapper gameMapper) {
        this.gameMapper = gameMapper;
    }

    // 🔹 게임 결과 저장 (DB에 기록)
    public void saveGameResult(GameDTO gameDTO) {
        if (Objects.isNull(gameDTO.getPlayDate())) { // ✅ 더 직관적인 null 체크
            gameDTO.setPlayDate(LocalDateTime.now());
        }

        gameMapper.insertGameResult(gameDTO);
        updatePlayerStats(gameDTO.getPlayer1Id(), gameDTO.getResult());
        updatePlayerStats(gameDTO.getPlayer2Id(), getOppositeResult(gameDTO.getResult()));
    }

    // 🔹 특정 플레이어 전적 조회
    public PlayerStatsDTO getPlayerStats(String playerId) {
        return gameMapper.getPlayerStats(playerId);
    }

    // 🔹 전체 랭킹 조회
    public List<PlayerStatsDTO> getRanking() {
        return gameMapper.getRanking();
    }

    // 🔹 특정 플레이어의 게임 기록 조회
    public List<GameDTO> getGameHistory(String playerId) {
        return gameMapper.getGameHistory(playerId);
    }

    // 🔹 특정 게임 기록 삭제
    public boolean deleteGameRecord(int gameId) {
        return gameMapper.deleteGameRecord(gameId) > 0;
    }

    // 🔹 플레이어 전적 업데이트 (승/패/무승부 반영)
    private void updatePlayerStats(String playerId, String result) {
        if (!"server".equals(playerId)) { // ✅ 서버 기록 제외
            Optional.ofNullable(gameMapper.getPlayerStats(playerId)) 
                    .orElseGet(() -> {
                        gameMapper.createPlayerStats(playerId);
                        return gameMapper.getPlayerStats(playerId); // ✅ 생성 후 다시 조회
                    });

            gameMapper.updatePlayerStats(playerId, result);
        }
    }

    // 🔹 상대방의 반대 결과 반환
    private String getOppositeResult(String result) {
        return switch (result) {
            case "승리" -> "패배";
            case "패배" -> "승리";
            default -> "무승부";
        };
    }
}
