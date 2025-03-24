package com.care.boot.gamedto;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * ✅ 게임 요청 객체 (랜덤 매칭 & 서버 대결 모두 지원)
 */
public class GameRequest {
    @JsonProperty("playerId")
    private String playerId;

    @JsonProperty("move")
    private String move;

    @JsonProperty("mode")
    private String mode = "random";  // ✅ 기본값을 "random"으로 설정

    @JsonProperty("opponent")
    private String opponent;

    public GameRequest() {}

    /**
     * ✅ 플레이어 ID만 입력하는 생성자 추가 (재매칭용)
     */
    public GameRequest(String playerId) {
        this.playerId = playerId;
        this.mode = "random";  // 기본 모드는 랜덤 매칭
        this.move = null;      // 가위바위보 선택 없음
        this.opponent = null;  // 상대 미정
    }

    public GameRequest(String playerId, String move, String mode, String opponent) {
        this.playerId = playerId;
        this.move = move;
        this.mode = (mode == null || mode.isEmpty()) ? "random" : mode; // ✅ 기본값 처리
        this.opponent = opponent;
    }

    public String getPlayerId() { return playerId; }
    public void setPlayerId(String playerId) { this.playerId = playerId; }

    public String getMove() { return move; }
    public void setMove(String move) { this.move = move; }

    public String getMode() { return mode; }
    public void setMode(String mode) { this.mode = (mode == null || mode.isEmpty()) ? "random" : mode; }

    public String getOpponent() { return opponent; }
    public void setOpponent(String opponent) { this.opponent = opponent; }

    @Override
    public String toString() {
        return "GameRequest{" +
                "playerId='" + playerId + '\'' +
                ", move='" + move + '\'' +
                ", mode='" + mode + '\'' +
                ", opponent='" + opponent + '\'' +
                '}';
    }
}
