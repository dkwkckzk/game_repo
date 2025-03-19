package com.care.boot.gamedto;

public class GameRequest {
    private String playerId;
    private String move;
    private String mode = "server";  // ✅ 기본값 설정

    public String getPlayerId() {
        return playerId;
    }

    public void setPlayerId(String playerId) {
        this.playerId = playerId;
    }

    public String getMove() {
        return move;
    }

    public void setMove(String move) {
        this.move = move;
    }

    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = (mode == null || mode.isEmpty()) ? "server" : mode; // ✅ 기본값 설정
    }


    @Override
    public String toString() {
        return "GameRequest{" +
                "playerId='" + playerId + '\'' +
                ", move='" + move + '\'' +
                ", mode='" + mode + '\'' +
                '}';
    }
}
