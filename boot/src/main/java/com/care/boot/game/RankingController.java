//package com.care.boot.game;
//
//import com.care.boot.gamedto.PlayerStatsDTO;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.List;
//
//@RestController
//@RequestMapping("/api")  // API 요청 전용
//public class RankingController {
//    private final GameService gameService;
//
//    public RankingController(GameService gameService) {
//        this.gameService = gameService;
//    }
//
//    /**
//     * 🏅 랭킹 데이터 API (JSON 응답)
//     */
//    @GetMapping("/ranking")
//    public List<PlayerStatsDTO> getRanking() {
//        return gameService.getRanking();
//    }
//}
