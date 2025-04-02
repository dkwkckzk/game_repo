package com.care.boot.game;

import com.care.boot.gamedto.GameDTO;
import com.care.boot.gamedto.PlayerStatsDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")  // API 요청 전용
public class GameController {
    private final GameService gameService;

    public GameController(GameService gameService) {
        this.gameService = gameService;
    }

    /**
     * ✅ 개별 플레이어 점수 조회 API
     */
    @GetMapping("/player-score")
    public PlayerStatsDTO getPlayerScore(@RequestParam String playerId) {
        PlayerStatsDTO stats = gameService.getPlayerStats(playerId);
        if (stats != null && stats.getScore() >= 1000) {
            stats.setKing(true);  // 👑 점수가 1000 이상이면 왕관 표시
        }
        return stats;
    }

    /**
     * 🏅 전체 랭킹 조회 API (JSON 응답)
     */
    @GetMapping("/ranking")
    public List<PlayerStatsDTO> getRanking() {
        List<PlayerStatsDTO> ranking = gameService.getRanking();
        for (PlayerStatsDTO stats : ranking) {
            if (stats.getScore() >= 1000) {
                stats.setKing(true);  // 👑 점수 기준으로 각 플레이어에 왕관 설정
            }
        }
        return ranking;
    }

    /**
     * 📝 경기 결과 저장 API (DynamoDB + 전적 업데이트)
     */
    @PostMapping("/save-result")
    public ResponseEntity<String> saveGameResult(@RequestBody SaveGameRequest request) {
        gameService.saveGameResult(request.getPlayerGame(), request.getOpponentGame(), request.isMatchWin());
        return ResponseEntity.ok("게임 결과 저장 완료");
    }
}

class SaveGameRequest {
    private GameDTO playerGame;
    private GameDTO opponentGame;
    private boolean matchWin;

    public GameDTO getPlayerGame() {
        return playerGame;
    }

    public void setPlayerGame(GameDTO playerGame) {
        this.playerGame = playerGame;
    }

    public GameDTO getOpponentGame() {
        return opponentGame;
    }

    public void setOpponentGame(GameDTO opponentGame) {
        this.opponentGame = opponentGame;
    }

    public boolean isMatchWin() {
        return matchWin;
    }

    public void setMatchWin(boolean matchWin) {
        this.matchWin = matchWin;
    }
}
