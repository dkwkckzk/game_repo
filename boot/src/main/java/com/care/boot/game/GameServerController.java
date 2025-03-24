package com.care.boot.game;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import com.care.boot.gamedto.GameDTO;
import com.care.boot.gamedto.GameRequest;
import java.time.LocalDateTime;
import java.util.concurrent.ConcurrentHashMap;

@Controller
public class GameServerController {
    private final SimpMessagingTemplate messagingTemplate;
    private final ConcurrentHashMap<String, Boolean> serverGameState = new ConcurrentHashMap<>();

    public GameServerController(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    /**
     * ✅ 서버와 가위바위보 플레이 (결과만 반환, DB 저장 없음)
     */
    @MessageMapping("/server/play")
    public void playServerGame(GameRequest request) {
        String playerId = request.getPlayerId();
        String move = request.getMove();

        if (!serverGameState.getOrDefault(playerId, false)) {
            System.out.println("⚠ " + playerId + "는 현재 서버와 대결 중이 아닙니다.");
            return;
        }

        String serverMove = getRandomMove();
        String result = determineWinner(move, serverMove);

        // ✅ 서버 게임은 결과만 클라이언트에게 전송 (DB 저장 X)
        GameDTO gameDTO = new GameDTO(0, playerId, "server", move, serverMove, result, LocalDateTime.now());
        messagingTemplate.convertAndSend("/topic/server/result/" + playerId, gameDTO);
    }

    /**
     * ✅ 서버와의 게임 시작 (상태 변경)
     */
    @MessageMapping("/server/start")
    public void startServerGame(GameRequest request) {
        String playerId = request.getPlayerId();
        serverGameState.put(playerId, true);
        messagingTemplate.convertAndSend("/topic/server/match/" + playerId, "✅ 서버 대결 시작");
        System.out.println("🚀 서버 대결 시작: " + playerId);
    }

    /**
     * ✅ 서버와의 게임 종료 (상태 초기화)
     */
    @MessageMapping("/server/quit")
    public void quitServerGame(GameRequest request) {
        String playerId = request.getPlayerId();

        if (!serverGameState.containsKey(playerId)) {
            return; // 이미 종료된 상태면 실행하지 않음
        }

        serverGameState.remove(playerId);
        messagingTemplate.convertAndSend("/topic/server/end/" + playerId, "❌ 서버 대결 종료됨");

        System.out.println("🚪 서버 대결 종료: " + playerId);
    }

    /**
     * ✅ 랜덤 가위바위보 선택 (서버 AI)
     */
    private String getRandomMove() {
        String[] moves = {"가위", "바위", "보"};
        return moves[(int) (Math.random() * 3)];
    }

    /**
     * ✅ 승자 판별 로직
     */
    private String determineWinner(String move1, String move2) {
        if (move1.equals(move2)) return "무승부";
        if ((move1.equals("가위") && move2.equals("보")) ||
            (move1.equals("바위") && move2.equals("가위")) ||
            (move1.equals("보") && move2.equals("바위"))) {
            return "승리";
        }
        return "패배";
    }
}
