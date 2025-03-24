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
        body { font-family: Arial, sans-serif; text-align: center; background-color: #f8f9fa; }
        button { padding: 10px 20px; font-size: 18px; margin: 5px; cursor: pointer; }
        button:disabled { background-color: #ccc; cursor: not-allowed; }
        #result, #status, #opponent { font-size: 20px; margin-top: 15px; }
    </style>
</head>
<body>
    <h2><%= playerId %> 님의 가위바위보 게임</h2>

    <label for="modeSelect">게임 모드 선택:</label>
    <select id="modeSelect" onchange="toggleMatchButton()">
        <option value="server">서버와 대결</option>
        <option value="random">랜덤 플레이어와 대결</option>
    </select>

    <button id="matchButton" onclick="startMatching()" disabled>🔄 랜덤 매칭하기</button>
    <button id="startServerMatch" onclick="startServerMatch()">🚀 서버 대결 시작</button>
    <button id="quitServerMatch" onclick="quitServerMatch()" style="display:none;">🚪 서버 대결 종료</button>

    <h3>현재 상태: <span id="status">대기 중</span></h3>
    <h3>현재 상대: <span id="opponent">없음</span></h3>

    <button id="btnScissors" onclick="sendMove('가위')" disabled>✌️ 가위</button>
    <button id="btnRock" onclick="sendMove('바위')" disabled>✊ 바위</button>
    <button id="btnPaper" onclick="sendMove('보')" disabled>🖐 보</button>

    <p id="result">결과가 여기에 표시됩니다.</p>
    <p>내 승리 수: <span id="playerWins">0</span></p>
    <p>상대 승리 수: <span id="opponentWins">0</span></p>

    <script>
	    var playerId = "<%= playerId %>";
	    var opponent = null;
	    var isServerMode = false;
	    var playerWins = 0;
	    var opponentWins = 0;
	    var socket = new SockJS('/game');
	    var stompClient = Stomp.over(socket);
	
	    stompClient.connect({}, function() {
	        console.log("✅ WebSocket 연결 완료");
	
	        stompClient.subscribe('/topic/match/' + playerId, function(response) {
	            opponent = response.body;
	            if (opponent.startsWith('❌')) {
	                document.getElementById("status").innerText = opponent;
	            } else {
	                document.getElementById("status").innerText = "게임 시작! 상대: " + opponent;
	                document.getElementById("opponent").innerText = opponent;
	                if (!isServerMode) {
	                    playerWins = 0;
	                    opponentWins = 0;
	                }
	                updateWinCount();
	                enableGameButtons(true);
	            }
	        });
	
	        stompClient.subscribe('/topic/result/' + playerId, function(response) {
	            var gameResult = JSON.parse(response.body);
	            document.getElementById("result").innerText =
	                "내 선택: " + gameResult.player1Move + 
	                " | 상대 선택: " + gameResult.player2Move + 
	                " | 결과: " + gameResult.result;
	
	            if (!isServerMode) { // ✅ 서버 대결이 아닐 때만 승리 횟수 카운트
	                if (gameResult.result === "승리") playerWins++;
	                else if (gameResult.result === "패배") opponentWins++;
	            }
	
	            updateWinCount();
	
	            if (!isServerMode && (playerWins === 4 || opponentWins === 4)) {
	                document.getElementById("status").innerText = "🎉 4선승제 완료! 게임 종료!";
	                enableGameButtons(false);
	                setTimeout(() => { startMatching(); }, 3000);
	            } else {
	                document.getElementById("status").innerText = "다음 판을 진행하세요!";
	                enableGameButtons(true); // ✅ 서버 대결에서는 계속 플레이 가능
	            }
	        });
	
	        stompClient.subscribe('/topic/match/end/' + playerId, function() {
	            quitServerMatch();  
	        });
	    });
	
	    function toggleMatchButton() {
	        var mode = document.getElementById("modeSelect").value;
	        opponent = null;
	        document.getElementById("opponent").innerText = "없음";
	        isServerMode = false;
	
	        if (mode === "random") {
	            document.getElementById("matchButton").disabled = false;
	            document.getElementById("startServerMatch").style.display = 'none';
	            document.getElementById("quitServerMatch").style.display = 'none';
	            enableGameButtons(false);
	        } else {
	            document.getElementById("matchButton").disabled = true;
	            document.getElementById("startServerMatch").style.display = 'inline';
	            document.getElementById("quitServerMatch").style.display = 'none';
	            enableGameButtons(false);
	        }
	    }
	
	    function startMatching() {
	        document.getElementById("status").innerText = "매칭 중...";
	        stompClient.send("/app/match", {}, JSON.stringify({ playerId: playerId }));
	    }
	
	    function startServerMatch() {
	        opponent = "server";
	        isServerMode = true;
	        document.getElementById("opponent").innerText = "서버";
	        document.getElementById("status").innerText = "서버와 대결 중!";
	        document.getElementById("startServerMatch").style.display = 'none';
	        document.getElementById("quitServerMatch").style.display = 'inline';
	        enableGameButtons(true);
	        stompClient.send("/app/startServerMatch", {}, JSON.stringify({ playerId: playerId }));
	    }
	
	    function quitServerMatch() {
	        opponent = null;
	        isServerMode = false;
	        document.getElementById("status").innerText = "서버와의 대결을 종료했습니다.";
	        document.getElementById("opponent").innerText = "없음";
	        document.getElementById("startServerMatch").style.display = 'inline';
	        document.getElementById("quitServerMatch").style.display = 'none';
	        enableGameButtons(false);
	        stompClient.send("/app/quitServerMatch", {}, JSON.stringify({ playerId: playerId }));
	    }
	
	    function sendMove(move) {
	        if (!opponent) {
	            document.getElementById("status").innerText = "상대 없음. 먼저 대결을 시작하세요!";
	            return;
	        }
	
	        var mode = document.getElementById("modeSelect").value;
	        stompClient.send("/app/play", {}, JSON.stringify({ 
	            playerId: playerId,
	            move: move,
	            mode: mode
	        }));
	
	        document.getElementById("status").innerText = "결과 대기 중...";
	    }
	
	    function enableGameButtons(enable) {
	        ["btnScissors", "btnRock", "btnPaper"].forEach(id => {
	            document.getElementById(id).disabled = !enable;
	        });
	    }
	
	    function updateWinCount() {
	        document.getElementById("playerWins").innerText = playerWins;
	        document.getElementById("opponentWins").innerText = opponentWins;
	    }
	</script>

</body>
</html>
