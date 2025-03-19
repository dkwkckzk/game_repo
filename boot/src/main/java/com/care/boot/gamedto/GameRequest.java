package com.care.boot.gamedto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class GameRequest {
    @JsonProperty("playerId")
    private String playerId;

    @JsonProperty("move")
    private String move;

    @JsonProperty("mode")
    private String mode = "server";  // ✅ 기본값 설정

    @JsonProperty("opponent")  // ✅ 추가: 상대 플레이어 ID (랜덤 매칭 or 직접 선택)
    private String opponent;

    public GameRequest() {}

    public GameRequest(String playerId, String move, String mode, String opponent) {
        this.playerId = playerId;
        this.move = move;
        this.mode = (mode == null || mode.isEmpty()) ? "server" : mode;
        this.opponent = opponent;
    }

    public String getPlayerId() { return playerId; }
    public void setPlayerId(String playerId) { this.playerId = playerId; }

    public String getMove() { return move; }
    public void setMove(String move) { this.move = move; }

    public String getMode() { return mode; }
    public void setMode(String mode) { this.mode = (mode == null || mode.isEmpty()) ? "server" : mode; }

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
