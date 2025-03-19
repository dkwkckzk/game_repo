package com.care.boot.gamedto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;
import java.time.LocalDateTime;

public class GameDTO {
    @JsonProperty("gameId")
    private int gameId;

    @JsonProperty("player1Id")
    private String player1Id;

    @JsonProperty("player2Id")
    private String player2Id;

    @JsonProperty("player1Move")
    private String player1Move;

    @JsonProperty("player2Move")
    private String player2Move;

    @JsonProperty("result")
    private String result;

    @JsonProperty("playDate")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")  // ✅ JSON 변환 시 포맷 적용
    @JsonSerialize(using = LocalDateTimeSerializer.class)  // ✅ Jackson이 LocalDateTime 변환하도록 설정
    private LocalDateTime playDate;

    // ✅ 기본 생성자 (JSON 변환 시 필요)
    public GameDTO() {}

    // ✅ 전체 필드를 포함하는 생성자
    public GameDTO(int gameId, String player1Id, String player2Id, String player1Move, String player2Move, String result, LocalDateTime playDate) {
        this.gameId = gameId;
        this.player1Id = player1Id;
        this.player2Id = player2Id;
        this.player1Move = player1Move;
        this.player2Move = player2Move;
        this.result = result;
        this.playDate = playDate;
    }

    // ✅ JSON 직렬화를 위한 Getter 추가
    public int getGameId() { return gameId; }
    public String getPlayer1Id() { return player1Id; }
    public String getPlayer2Id() { return player2Id; }
    public String getPlayer1Move() { return player1Move; }
    public String getPlayer2Move() { return player2Move; }
    public String getResult() { return result; }
    public LocalDateTime getPlayDate() { return playDate; }

    // ✅ JSON 직렬화를 위한 Setter 추가
    public void setGameId(int gameId) { this.gameId = gameId; }
    public void setPlayer1Id(String player1Id) { this.player1Id = player1Id; }
    public void setPlayer2Id(String player2Id) { this.player2Id = player2Id; }
    public void setPlayer1Move(String player1Move) { this.player1Move = player1Move; }
    public void setPlayer2Move(String player2Move) { this.player2Move = player2Move; }
    public void setResult(String result) { this.result = result; }
    public void setPlayDate(LocalDateTime playDate) { this.playDate = playDate; }

    @Override
    public String toString() {
        return "GameDTO{" +
                "gameId=" + gameId +
                ", player1Id='" + player1Id + '\'' +
                ", player2Id='" + player2Id + '\'' +
                ", player1Move='" + player1Move + '\'' +
                ", player2Move='" + player2Move + '\'' +
                ", result='" + result + '\'' +
                ", playDate=" + playDate +
                '}';
    }
}
