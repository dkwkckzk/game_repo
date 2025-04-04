package com.care.boot.gamedto;

public class PlayerStatsDTO {
    private String playerId;
    private int totalGames;
    private int wins;
    private int losses;
    private int draws;
    private double winRate;
    private int score;
    private boolean isKing;

    public PlayerStatsDTO() {}

    public PlayerStatsDTO(String playerId, int totalGames, int wins, int losses, int draws, double winRate, int score) {
        this.playerId = playerId;
        this.totalGames = totalGames;
        this.wins = wins;
        this.losses = losses;
        this.draws = draws;
        this.winRate = winRate;
        this.setScore(score); // ✅ 점수 설정 시 isKing도 자동 처리
    }

    public String getPlayerId() {
        return playerId;
    }

    public void setPlayerId(String playerId) {
        this.playerId = playerId;
    }

    public int getTotalGames() {
        return totalGames;
    }

    public void setTotalGames(int totalGames) {
        this.totalGames = totalGames;
    }

    public int getWins() {
        return wins;
    }

    public void setWins(int wins) {
        this.wins = wins;
    }

    public int getLosses() {
        return losses;
    }

    public void setLosses(int losses) {
        this.losses = losses;
    }

    public int getDraws() {
        return draws;
    }

    public void setDraws(int draws) {
        this.draws = draws;
    }

    public double getWinRate() {
        return winRate;
    }

    public void setWinRate(double winRate) {
        this.winRate = winRate;
    }

    public int getScore() {
        return score;
    }

    // ✅ 점수 설정 시 자동으로 isKing 값도 업데이트
    public void setScore(int score) {
        this.score = score;
        this.isKing = score >= 1000;
    }

    public boolean isKing() {
        return isKing;
    }

    public void setKing(boolean king) {
        isKing = king;
    }

    @Override
    public String toString() {
        return "PlayerStatsDTO{" +
                "playerId='" + playerId + '\'' +
                ", totalGames=" + totalGames +
                ", wins=" + wins +
                ", losses=" + losses +
                ", draws=" + draws +
                ", winRate=" + winRate +
                ", score=" + score +
                ", isKing=" + isKing +
                '}';
    }
}
