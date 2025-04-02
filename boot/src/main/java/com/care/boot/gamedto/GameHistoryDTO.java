package com.care.boot.gamedto;

public class GameHistoryDTO {
    private String gameId;        // 서버에서 UUID 생성 (선택적 getter/setter)
    private String player1Id;
    private String player2Id;
    private String player1Move;
    private String player2Move;
    private String result;
    private String playDate;      // ISO-8601 문자열 (서버 생성)

    // Getter/Setter
    public String getGameId() {
        return gameId;
    }
    public void setGameId(String gameId) {
        this.gameId = gameId;
    }

    public String getPlayer1Id() {
        return player1Id;
    }
    public void setPlayer1Id(String player1Id) {
        this.player1Id = player1Id;
    }

    public String getPlayer2Id() {
        return player2Id;
    }
    public void setPlayer2Id(String player2Id) {
        this.player2Id = player2Id;
    }

    public String getPlayer1Move() {
        return player1Move;
    }
    public void setPlayer1Move(String player1Move) {
        this.player1Move = player1Move;
    }

    public String getPlayer2Move() {
        return player2Move;
    }
    public void setPlayer2Move(String player2Move) {
        this.player2Move = player2Move;
    }

    public String getResult() {
        return result;
    }
    public void setResult(String result) {
        this.result = result;
    }

    public String getPlayDate() {
        return playDate;
    }
    public void setPlayDate(String playDate) {
        this.playDate = playDate;
    }
}
