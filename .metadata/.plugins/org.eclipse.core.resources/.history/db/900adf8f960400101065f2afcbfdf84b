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
            font-family: Arial, sans-serif;
            text-align: center;
            margin: 50px;
        }
        button {
            font-size: 20px;
            padding: 10px 20px;
            margin: 10px;
            cursor: pointer;
        }
        #result {
            font-size: 24px;
            margin-top: 20px;
        }
        select {
            font-size: 18px;
            margin: 10px;
        }
        #status {
            font-size: 18px;
            font-weight: bold;
            color: blue;
            margin-top: 15px;
        }
        #onlinePlayers {
            font-size: 18px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <h2><%= playerId %> 님의 가위바위보 게임</h2>

    <label for="modeSelect">게임 모드 선택:</label>
    <select id="modeSelect">
        <option value="server">서버와 대결</option>
        <option value="random">랜덤 플레이어와 대결</option>
    </select>

    <h3>온라인 플레이어</h3>
    <ul id="onlinePlayers"></ul>

    <h3>현재 상태: <span id="status">대기 중</span></h3>
    <h3>현재 상대: <span id="opponent">없음</span></h3>

    <button onclick="sendMove('가위')">✌️ 가위</button>
    <button onclick="sendMove('바위')">✊ 바위</button>
    <button onclick="sendMove('보')">🖐 보</button>

    <p id="result">결과가 여기에 표시됩니다.</p>

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
                        var li = document.createElement("li");
                        li.textContent = player;
                        li.onclick = function() { setOpponent(player); };
                        playerList.appendChild(li);
                    }
                });
            });

            // ✅ 매칭 결과 구독
            stompClient.subscribe('/topic/match/' + playerId, function(response) {
                opponent = response.body;
                console.log("🎯 매칭 완료! 상대: " + opponent);
                
                if (opponent.includes("대기 중")) {
                    document.getElementById("status").innerText = "매칭 대기 중...";
                    document.getElementById("opponent").innerText = "없음";
                } else {
                    document.getElementById("status").innerText = "게임 시작! 상대: " + opponent;
                    document.getElementById("opponent").innerText = opponent;
                }
            });

            // ✅ 결과 구독
            stompClient.subscribe('/topic/result/' + playerId, function(response) {
                var gameResult = JSON.parse(response.body);
                document.getElementById("result").innerText = 
                    "내 선택: " + gameResult.player1Move + 
                    " | 상대 선택: " + gameResult.player2Move + 
                    " | 결과: " + gameResult.result;

                // ✅ 게임 종료 후 상태 초기화
                document.getElementById("status").innerText = "게임 종료! 다시 선택하세요.";
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
                document.getElementById("status").innerText = "게임 진행 중...";

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
            document.getElementById("status").innerText = "상대 선택 완료: " + selectedOpponent;
        }
    </script>
</body>
</html>
