<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    </style>
</head>
<body>
    <h2>가위 바위 보 게임</h2>
    <button onclick="sendMove('가위')">✌️ 가위</button>
    <button onclick="sendMove('바위')">✊ 바위</button>
    <button onclick="sendMove('보')">🖐 보</button>

    <p id="result">결과가 여기에 표시됩니다.</p>

    <script>
        var socket = new SockJS('/game');
        var stompClient = Stomp.over(socket);

        stompClient.connect({}, function() {
            console.log("WebSocket 연결됨");
            stompClient.subscribe('/topic/result', function(response) {
                var result = JSON.parse(response.body);
                document.getElementById("result").innerText = 
                    "내 선택: " + result.playerMove + " | 서버 선택: " + result.serverMove + " | 결과: " + result.result;
            });
        });

        function sendMove(move) {
            if (stompClient.connected) {
                stompClient.send("/app/play", {}, JSON.stringify({ move: move }));
            } else {
                alert("서버에 연결되지 않았습니다. 페이지를 새로고침 해주세요.");
            }
        }
    </script>
</body>
</html>
