package com.care.boot.gamedto;

public class GameResult {
    private String playerId;   // 플레이어 ID
    private String playerMove; // 플레이어 선택
    private String opponentId; // 상대방 ID
    private String opponentMove; // 상대방 선택
    private String result;     // 결과 (승/패/무승부)

    // 기본 생성자 (JSON 변환 시 필요)
    public GameResult() {}

    // 전체 필드를 포함하는 생성자
    public GameResult(String playerId, String playerMove, String opponentId, String opponentMove, String result) {
        this.playerId = playerId;
        this.playerMove = playerMove;
        this.opponentId = opponentId;
        this.opponentMove = opponentMove;
        this.result = result;
    }

    // Getter & Setter
    public String getPlayerId() {
        return playerId;
    }

    public void setPlayerId(String playerId) {
        this.playerId = playerId;
    }

    public String getPlayerMove() {
        return playerMove;
    }

    public void setPlayerMove(String playerMove) {
        this.playerMove = playerMove;
    }

    public String getOpponentId() {
        return opponentId;
    }

    public void setOpponentId(String opponentId) {
        this.opponentId = opponentId;
    }

    public String getOpponentMove() {
        return opponentMove;
    }

    public void setOpponentMove(String opponentMove) {
        this.opponentMove = opponentMove;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    @Override
    public String toString() {
        return "GameResult{" +
                "playerId='" + playerId + '\'' +
                ", playerMove='" + playerMove + '\'' +
                ", opponentId='" + opponentId + '\'' +
                ", opponentMove='" + opponentMove + '\'' +
                ", result='" + result + '\'' +
                '}';
    }
}
