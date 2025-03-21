<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.care.boot.member.MemberDTO" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("login");
        return;
    }
    String playerId = loginUser.getId();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>가위바위보 게임</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            text-align: center;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
        }
        h2 {
            color: #343a40;
        }
        .container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            max-width: 600px;
            margin: auto;
        }
        button {
            font-size: 20px;
            padding: 10px 20px;
            margin: 10px;
            cursor: pointer;
            border: none;
            border-radius: 5px;
            transition: 0.2s;
        }
        button:hover {
            transform: scale(1.1);
        }
        .rock { background-color: #007bff; color: white; }
        .scissors { background-color: #28a745; color: white; }
        .paper { background-color: #ffc107; color: black; }
        #result {
            font-size: 24px;
            font-weight: bold;
            color: #dc3545;
            margin-top: 20px;
        }
        select {
            font-size: 18px;
            padding: 5px;
            margin: 10px;
        }
        #status {
            font-size: 18px;
            font-weight: bold;
            padding: 10px;
            border-radius: 5px;
            display: inline-block;
            color: white;
            background: #007bff;
        }
        #opponent {
            font-size: 18px;
            font-weight: bold;
            color: #343a40;
        }
        .player-list {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }
        .player-card {
            background: #e9ecef;
            padding: 10px;
            border-radius: 5px;
            margin: 5px;
            cursor: pointer;
            transition: 0.2s;
        }
        .player-card:hover {
            background: #ced4da;
            transform: scale(1.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>🚀 가위바위보 게임</h2>
        <p><strong><%= playerId %></strong> 님, 승리를 위해 도전하세요!</p>

        <label for="modeSelect">🎮 게임 모드 선택:</label>
        <select id="modeSelect">
            <option value="server">🤖 서버와 대결</option>
            <option value="random">👥 랜덤 플레이어와 대결</option>
        </select>

        <h3>📡 온라인 플레이어</h3>
        <div id="onlinePlayers" class="player-list"></div>

        <h3>🔵 현재 상태: <span id="status">대기 중</span></h3>
        <h3>🆚 상대 플레이어: <span id="opponent">없음</span></h3>

        <button class="scissors" onclick="sendMove('가위')">✌️ 가위</button>
        <button class="rock" onclick="sendMove('바위')">✊ 바위</button>
        <button class="paper" onclick="sendMove('보')">🖐 보</button>

        <p id="result">📢 결과가 여기에 표시됩니다.</p>
    </div>

    <script>
        var playerId = "<%= playerId %>";
        var opponent = null;
        var socket = new SockJS('/game');
        var stompClient = Stomp.over(socket);

        stompClient.connect({}, function() {
            console.log("✅ WebSocket 연결 성공!");

            // ✅ 온라인 플레이어 목록 구독
            stompClient.subscribe('/topic/onlinePlayers', function(response) {
                var players = JSON.parse(response.body);
                var playerList = document.getElementById("onlinePlayers");
                playerList.innerHTML = "";
                players.forEach(function(player) {
                    if (player !== playerId) {
                        var div = document.createElement("div");
                        div.className = "player-card";
                        div.textContent = player;
                        div.onclick = function() { setOpponent(player); };
                        playerList.appendChild(div);
                    }
                });
            });

            // ✅ 매칭 결과 구독
            stompClient.subscribe('/topic/match/' + playerId, function(response) {
                opponent = response.body;
                console.log("🎯 매칭 완료! 상대: " + opponent);
                
                if (opponent.includes("대기 중")) {
                    document.getElementById("status").innerText = "🟡 매칭 대기 중...";
                    document.getElementById("opponent").innerText = "없음";
                } else {
                    document.getElementById("status").innerText = "🟢 게임 시작! 상대: " + opponent;
                    document.getElementById("opponent").innerText = opponent;
                }
            });

            // ✅ 결과 구독
            stompClient.subscribe('/topic/result/' + playerId, function(response) {
                var gameResult = JSON.parse(response.body);
                document.getElementById("result").innerText = 
                    "✅ 내 선택: " + gameResult.player1Move + 
                    " | 🎭 상대 선택: " + gameResult.player2Move + 
                    " | 🏆 결과: " + gameResult.result;

                // ✅ 게임 종료 후 상태 초기화
                document.getElementById("status").innerText = "🔴 게임 종료! 다시 선택하세요.";
                opponent = null; // 상대 초기화
                document.getElementById("opponent").innerText = "없음";
            });

        }, function(error) {
            console.error("❌ WebSocket 연결 실패:", error);
        });

        function sendMove(move) {
            var selectedMode = document.getElementById("modeSelect").value;

            if (stompClient && stompClient.connected) {  
                console.log("📨 선택 전송: " + move);
                document.getElementById("status").innerText = "🔵 게임 진행 중...";

                stompClient.send("/app/play", {}, JSON.stringify({ 
                    playerId: playerId, 
                    move: move,
                    mode: selectedMode,
                    opponent: opponent 
                }));
            } else {
                alert("⚠ WebSocket 연결이 끊어졌습니다. 페이지를 새로고침하세요.");
            }
        }

        function setOpponent(selectedOpponent) {
            opponent = selectedOpponent;
            document.getElementById("opponent").innerText = selectedOpponent;
            document.getElementById("status").innerText = "🟢 상대 선택 완료: " + selectedOpponent;
        }
    </script>
</body>
</html>
