<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>🏅 랭킹</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; background-color: #f8f9fa; }
    </style>
</head>
<body>

    <h2>🏆 플레이어 랭킹 (단순 출력 테스트)</h2>

    <div id="rankingOutput" style="white-space: pre-line; font-size: 18px; font-weight: bold;">
        <!-- 여기서 직접 데이터 출력 -->
    </div>

    <script>
    function fetchRanking() {
        fetch('/api/ranking')
            .then(response => response.json())
            .then(data => {
                console.log("📊 랭킹 데이터 확인:", data);

                let outputDiv = document.getElementById("rankingOutput");
                outputDiv.innerHTML = ""; // 기존 내용 초기화

                if (!data || data.length === 0) {
                    outputDiv.innerText = "데이터 없음";
                    return;
                }

                let outputText = "🔥 랭킹 데이터 출력 🔥\n";

                data.forEach((player, index) => {
                    let playerId = player.playerId || "(데이터 없음)";
                    let score = player.score || 0;
                    let wins = player.wins || 0;
                    let losses = player.losses || 0;

                    outputText += `${index + 1}위: ${playerId} | 점수: ${score} | 승리: ${wins} | 패배: ${losses}\n`;
                });

                outputDiv.innerText = outputText;
                console.log("✅ 화면에 데이터 출력 완료!");
            })
            .catch(error => console.error("🚨 랭킹 조회 실패:", error));
    }

    window.onload = fetchRanking;
    </script>

</body>
</html>
