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
    <title>서버와 가위바위보</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@500&display=swap');

        body {
            font-family: 'Noto Serif KR', serif;
            text-align: center;
            background: url('https://www.transparenttextures.com/patterns/asfalt-light.png'), linear-gradient(to bottom, #faf3e0, #e2d4ba);
            background-blend-mode: overlay;
            padding: 30px;
            color: #3b2f2f;
            position: relative;
            min-height: 100vh;
        }
        h2 {
            font-size: 30px;
            color: #523b1c;
            margin-bottom: 10px;
            border: 3px double #a08058;
            padding: 10px;
            background-color: #fef8e5;
            display: inline-block;
            border-radius: 12px;
            box-shadow: 0 0 10px rgba(100, 70, 40, 0.2);
        }
        .button-bar {
            margin-bottom: 30px;
            margin-top: 10px;
        }
        button {
            padding: 12px 24px;
            font-size: 18px;
            margin: 5px 10px;
            border: 2px solid #a88756;
            border-radius: 10px;
            background-color: #fff3c4;
            color: #3b2f2f;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 2px 2px 6px rgba(0, 0, 0, 0.1);
        }
        button:hover {
            background-color: #f2d694;
        }
        button:disabled {
            background-color: #ddd2b2;
            cursor: not-allowed;
        }
        .status-box {
            margin-top: 20px;
            font-size: 22px;
            color: #4e3d30;
            border-top: 2px dashed #a08058;
            padding-top: 10px;
        }
        .result-box {
            margin-top: 30px;
            padding: 20px;
            background: #fffbe6;
            border: 2px solid #ccb37d;
            border-radius: 12px;
            display: inline-block;
            min-width: 300px;
            box-shadow: 0 0 8px rgba(120, 100, 70, 0.2);
            font-size: 20px;
        }
    </style>
</head>
<body>
    <h2>📜 <%= playerId %> 님의 서버 대결 모드 📜</h2>

    <div class="button-bar">
        <button id="goToMatch" onclick="goToMatch()">🔄 랜덤 매칭하기</button>
        <button id="startServerMatch" onclick="startServerMatch()">🚀 서버 대결 시작</button>
        <button id="quitServerMatch" onclick="quitServerMatch()" style="display:none;">🚪 서버 대결 종료</button>
    </div>

    <div class="status-box">
        <h3>현재 상태: <span id="status">대기 중</span></h3>
    </div>

    <div>
        <button id="btnScissors" onclick="sendMove('가위')" disabled>✌️ 가위</button>
        <button id="btnRock" onclick="sendMove('바위')" disabled>✊ 바위</button>
        <button id="btnPaper" onclick="sendMove('보')" disabled>🖐 보</button>
    </div>

    <div class="result-box" id="result">결과가 여기에 표시됩니다.</div>

    <script>
        var playerId = "<%= playerId %>";
        var socket = new SockJS('/game');
        var stompClient = Stomp.over(socket);
        var isQuitting = false;

        stompClient.connect({}, function() {
            console.log("✅ WebSocket 연결 완료");

            stompClient.subscribe('/topic/server/match/' + playerId, function(response) {
                document.getElementById("status").innerText = response.body;
                document.getElementById("startServerMatch").style.display = 'none';
                document.getElementById("quitServerMatch").style.display = 'inline';
                enableGameButtons(true);
            });

            stompClient.subscribe('/topic/server/result/' + playerId, function(response) {
                var gameResult = JSON.parse(response.body);
                document.getElementById("result").innerText =
                    "내 선택: " + gameResult.player1Move +
                    " | 서버 선택: " + gameResult.player2Move +
                    " | 결과: " + gameResult.result;
            });

            stompClient.subscribe('/topic/server/end/' + playerId, function() {
                if (!isQuitting) {
                    quitServerMatch();
                }
            });
        });

        function startServerMatch() {
            isQuitting = false;
            stompClient.send("/app/server/start", {}, JSON.stringify({ playerId: playerId }));
        }

        function quitServerMatch() {
            if (isQuitting) return;
            isQuitting = true;

            stompClient.send("/app/server/quit", {}, JSON.stringify({ playerId: playerId }));
            document.getElementById("status").innerText = "서버와의 대결을 종료했습니다.";
            document.getElementById("startServerMatch").style.display = 'inline';
            document.getElementById("quitServerMatch").style.display = 'none';
            enableGameButtons(false);
        }

        function sendMove(move) {
            stompClient.send("/app/server/play", {}, JSON.stringify({ playerId: playerId, move: move }));
        }

        function enableGameButtons(enable) {
            ["btnScissors", "btnRock", "btnPaper"].forEach(id => {
                document.getElementById(id).disabled = !enable;
            });
        }

        function goToMatch() {
            location.href = "/game/match";
        }
    </script>
</body>
</html>
