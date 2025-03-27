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
    <title>매칭 가위바위보</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@500&display=swap');
        
        #winBanner {
    	position: fixed;
    	top: 0;
    	left: 0;
    	width: 100vw;
    	height: 100vh;
    	object-fit: cover;      /* 이미지 비율 유지하며 꽉 채우기 */
    	opacity: 0;
    	transition: opacity 1.5s ease-in-out;
    	z-index: 9999;
    	pointer-events: none;   /* 다른 요소 클릭 방지 안되도록 */
		}
		
		#loseBanner {
    	position: fixed;
    	top: 0;
    	left: 0;
    	width: 100vw;
    	height: 100vh;
    	object-fit: cover;      /* 이미지 비율 유지하며 꽉 채우기 */
    	opacity: 0;
    	transition: opacity 1.5s ease-in-out;
    	z-index: 9999;
    	pointer-events: none;   /* 다른 요소 클릭 방지 안되도록 */
		}
        
        
        
        #screen-flash {
    	position: fixed;
    	top: 0;
    	left: 0;
    	width: 100%;
    	height: 100%;
    	background-color: red;
    	opacity: 0;
    	pointer-events: none;
    	z-index: 9999;
    	transition: opacity 0.05s ease;
		}
		
		
        
        body {
    	font-family: 'Noto Serif KR', serif;
    	text-align: center;
    	background-color: #f3e8db; /* 이 줄은 삭제하거나 덮어쓰기 */
    	background-image: url('/images/fight_bg_deco.png'); /* ✅ 배경 이미지 설정 */
    	background-size: contain; /* ✅ 화면 전체를 덮도록 */
    	background-position: center -50px; /* ✅ 중앙 정렬 */
    	background-repeat: no-repeat; /* ✅ 반복 방지 */
    	padding: 30px;
    	color: #ffffff;
    	position: relative;
    	min-height: 100vh;
			}
			
			.player-op-wrap {
    	display: flex;
    	align-items: center;     /* 세로 가운데 정렬 */
    	gap: 1000px;               /* 이미지 사이 간격 */
    	margin: 20px 0;
    	text-align: left;
    	margin-left: 10px;
		}

		.player-op-wrap img {
    	width: 200px;
    	height: auto;
    	margin-top: 100px
		}
        
        
        h2 { 
        font-size: 28px; color: #4e3d30; background-color: #fef4dc; display: inline-block; padding: 10px 20px; border-radius: 12px; border: 3px double #b99b6b; box-shadow: 0 0 10px rgba(100, 80, 40, 0.15); 
        }
        
        
        button { 
        padding: 12px 25px; font-size: 18px; margin: 10px; border: 2px solid #a88756; border-radius: 10px; background-color: #fff3c4; color: #3b2f2f; cursor: pointer; transition: background-color 0.2s; box-shadow: 2px 2px 6px rgba(0, 0, 0, 0.1); 
        }
        
        
        button:hover:not(:disabled) { 
        background-color: #f2d694; 
        }
        
        
        button:disabled { 
        background-color: #ddd2b2; cursor: not-allowed; 
        }
        
        
        .box {
    	background: transparent; /* ✅ 배경 투명 */
    	border: 2px solid #ccb37d;            /* ✅ 테두리 제거 */
    	padding: 25px;
    	margin: 10px;
    	border-radius: 12px;
    	box-shadow: none;        /* ✅ 그림자도 제거 (원하면 유지 가능) */
    	min-width: 100px;
    	color: #000000;          /* ✅ 텍스트 색상 유지 */
		}
        
        
        .game-section {
    	position: fixed;       /* 고정 위치로 설정 */
    	top: 20px;             /* 화면 위에서 20px 떨어진 위치 */
    	left: 50%;             /* 가로 가운데 정렬을 위해 */
    	transform: translateX(-50%); /* 정확한 가로 중앙 정렬 */
    	display: flex;
    	justify-content: center;
    	align-items: center;
    	gap: 1200px;
    	z-index: 0;         /* 다른 요소 위에 올라오도록 */
		}
        
        
        #status { 
        font-size: 22px; margin-top: 20px; font-weight: bold; color: #4e3d30; 
        }
        
        
        #result {
    	font-size: 22px;
    	margin-top: 20px;
    	font-weight: bold;
    	color: #000000; /* 기존 #4e3d30에서 변경 */
    	background-color: rgba(0, 0, 0, 0.4); /* 배경 추가로 가독성 확보 */
    	padding: 10px;
    	border-radius: 10px;
    	display: block;       /* 이 줄이 없으면 명시적으로 추가해줘 */
    	opacity: 1;           /* 숨겨지지 않도록 */
    	z-index: 999;         /* 위에 덮이는 게 없도록 */
		}
    	
        }
        
        #endEmoji { 
        font-size: 100px; margin-top: 30px; display: none; 
        }
        
        
        
        
        .move-buttons {
    	position: fixed;
    	bottom: 20px;
    	left: 20px;
    	display: flex;
    	gap: 10px;
    	z-index: 999;
		}

		.move-buttons button {
    	background-color: #fff;
    	color: #112d4e;
    	border: 2px solid #3f72af;
		}
        
        
        #roundPrompt, #finalMessage { 
        position: fixed; top: 40%; left: 50%; transform: translate(-50%, -50%); font-size: 48px; font-weight: bold; padding: 30px 50px; border-radius: 20px; z-index: 9999; display: none; animation: fadeInOut 2s ease-in-out; 
        }
        
        
        #roundPrompt { 
        color: #8b5e3c; background-color: rgba(255, 248, 220, 0.95); border: 4px double #a88756; 
        }
        
        
        #finalMessage { 
        font-size: 60px; color: #fff; 
        }
        
        #rematchButton {
  		position: relative;
  		z-index: 9999; /* 덮고 있는 요소들보다 높게 설정 */
		}
		
		#serverMatchButton {
  		position: relative;
  		z-index: 9999; /* 덮고 있는 요소들보다 높게 설정 */
		}
        
        
        @keyframes fadeInOut {
            0% { opacity: 0; transform: translate(-50%, -60%) scale(0.8); }
            15% { opacity: 1; transform: translate(-50%, -50%) scale(1.1); }
            85% { opacity: 1; transform: translate(-50%, -50%) scale(1); }
            100% { opacity: 0; transform: translate(-50%, -40%) scale(0.8); }
        }
        
        /*캐릭터 움직임 담당 코드*/
        .move-win-player {
    	transform: translateX(+470px);
    	transition: transform 0.05s ease-in-out;
		}

		.move-lose-op {
    	transform: translateX(-520px);
    	transition: transform 0.05s ease-in-out;
		}
		
		.move-draw-player{
		transform: translateX(+500px);
    	transition: transform 0.05s ease-in-out;
    	}
		.move-draw-op{
		transform: translateX(-500px);
    	transition: transform 0.05s ease-in-out;
    	}
		
		.move-lose-player{
		transform: translateX(+450px);
    	transition: transform 0.05s ease-in-out;
    	}
		
		.move-win-op{
		transform: translateX(-530px);
    	transition: transform 0.05s ease-in-out;
    	}
    	/*움직임 담당 코드 끝*/
		
		.player-wrapper, .opponent-wrapper {
    	position: relative;
    	display: inline-block;
		}
		.choice-icon {
    	position: absolute;
    	top: 150px;   /* 캐릭터 위로 띄우기 */
    	left: 100px;
    	
    	width: 60px;
    	height: auto;
    	display: none; /* 처음엔 안 보임 */
    	z-index: 10;
		}
		
		#opChoice.choice-icon {
    	left: auto;
    	right: 100px;                  /* 오른쪽 고정 */
		}
    </style>
</head>
<body>
    <h2>📜 <span id="playerInfo"></span> 님의 랜덤 매칭 모드 (점수: <span id="playerScore">0</span>) 📜</h2>
    <div>
        
        <button id="rematchButton" onclick="startMatching()" style="display:none;">🔁 다시 매칭하기</button>
        <button id="serverMatchButton" onclick="goToServerMatch()" style="display:none;"> 서버 대결하기</button>
        <!--  <button id="rankingButton" onclick="goToRanking()"> 랭킹 보기</button>-->
    </div>
    <div class="player-op-wrap">
  		<div class="player-wrapper">
    		<img id="playerImage" src="/images/player.png" alt="플레이어" />
    		<img id="playerChoice" src="" alt="내 선택" class="choice-icon" />
  	</div>

  		<div class="opponent-wrapper">
    		<img id="opImage" src="/images/op.png" alt="상대" />
    		<img id="opChoice" src="" alt="상대 선택" class="choice-icon" />
  		</div>
	</div>
    
    
    
    <div class="game-section">
        <div class="box">
            <h3> 내 정보</h3>
            <p><strong>이름:</strong> <span id="playerName"></span></p>
            <p><strong>점수:</strong> <span id="playerScoreInBox">0</span></p>
            <p><strong>승리 횟수:</strong> <span id="score">0</span> / 3</p>
        </div>
        
        <div class="box">
            <h3> 상대 정보</h3>
            <p><strong>이름:</strong> <span id="opponent">없음</span></p>
            <p><strong>점수:</strong> <span id="opponentScore">0</span></p>
            <p><strong>상대 승리 횟수:</strong> <span id="opponentWinCount">0</span></p>
        </div>
        
    </div>
    <!--<button onclick="showWinBanner()">일검봉후 보기</button>  나중에 지운다! -->
    <!--<button onclick="showLoseBanner()">성인취의 보기</button>  나중에 지운다! -->
    <button id="matchButton" onclick="startMatching()"> 랜덤 매칭 시작</button>
    <p id="status">현재 상황: 대기 중</p>
    <div class="move-buttons">
        <button id="btnScissors" onclick="sendMove('가위')" disabled>✌️ 가위</button>
        <button id="btnRock" onclick="sendMove('바위')" disabled>✊ 바위</button>
        <button id="btnPaper" onclick="sendMove('보')" disabled>✋ 보</button>
    </div>
    
    
    <p id="result">결과가 여기에 표시됩니다.</p>
    <div id="endEmoji"></div>
    <div id="roundPrompt"></div>
    <div id="finalMessage"></div>
    
    
    
    
    
    
    
    
    
    
    
    <script>
    
    	function updateConsole(){
    		console.log("받은 결과 객체:", gameResult.player1Move); // 확인용 로그
        	
    	}
        const playerId = "<%= playerId %>";
        document.getElementById("playerInfo").innerText = playerId;
        document.getElementById("playerName").innerText = playerId;
        let stompClient;
        let socket;
        let opponent = null;
        let winCount = 0;
        let loseCount = 0;
        let opponentWinCount = 0;
        let isGameOver = false;
		let validRound = 0; //내가 추가한 변수
        
        
        
        function connectWebSocket() {
            socket = new SockJS('/game');
            stompClient = Stomp.over(socket);
            stompClient.connect({}, () => {
                stompClient.subscribe('/topic/match/' + playerId, (message) => {
                    opponent = message.body;
                    if (opponent.startsWith('❌')) {
                        document.getElementById("status").innerText = opponent;
                    } else {
                        document.getElementById("status").innerText = "✅ 매칭 성공! 상대: " + opponent;
                        document.getElementById("opponent").innerText = opponent;
                        document.getElementById("matchButton").style.display = "none";
                        document.getElementById("rematchButton").style.display = "none";
                        document.getElementById("serverMatchButton").style.display = "none";
                        enableGameButtons(true);
                        isGameOver = false;
                        fetchPlayerScore();
                        fetchOpponentScore();
                        showPrompt("안내면 진거 가위 바위 보!");
                    }
                });

                stompClient.subscribe('/topic/result/' + playerId, (message) => {
                    const gameResult = JSON.parse(message.body);
                    handleGameResult(gameResult);
                });
            });
        }

        function handleGameResult(gameResult) {
        	console.log("결과 텍스트 업데이트:", gameResult);
        	
        	setTimeout(function () {
            	flashScreenRed(); // ← 1초 후 화면 깜빡임 실행
            	showChoiceIcons(gameResult.player1Move, gameResult.player2Move);
            	const playerImage = document.getElementById("playerImage");
                const opImage = document.getElementById("opImage");
            	
            	
            	if (gameResult.result === "무승부") {
            		playerImage.src = "/images/player_draw.gif";
            		playerImage.style.width = "320px"; 
                    playerImage.style.height = "auto";
                    playerImage.classList.add("move-draw-player");
            		opImage.src = "/images/op_draw.gif";
            		opImage.style.width = "280px";
                    opImage.style.height = "auto";
                    opImage.classList.add("move-draw-op");
                    document.getElementById("status").innerText = "🤝 무승부! 다시 선택!";
                    enableGameButtons(true);
             
                    
                }
                

            	else if (gameResult.result === "승리") {
                	playerImage.src = "/images/player_drawsword.png";
                	playerImage.style.width = "320px"; 
                    playerImage.style.height = "auto";
                    playerImage.classList.add("move-win-player");
                	opImage.src = "/images/op_die.png";
                	opImage.style.width = "250px";
                    opImage.style.height = "auto";
                    opImage.classList.add("move-lose-op");
                	
                	
                	
                	
                }
                
                
                
                else if (gameResult.result === "패배") {
                	playerImage.src = "/images/player_die.png";
                	playerImage.classList.add("move-lose-player");
                	opImage.src = "/images/op_drawsword.png";
                	opImage.style.width = "280px"; 
                    opImage.style.height = "auto";
                    opImage.classList.add("move-win-op");
                    
                    
                    
                    
                }
            	
            	

            	
            }, 1000);
        	
            
        	

        	
        	document.getElementById("result").innerText =
                '내 선택:'+ gameResult.player1Move + '| 상대 선택:' + gameResult.player2Move + '| 결과:'+ gameResult.result;
				
            
             // 게임 결과가 나오면 상대의 이미지도 바꾸기
            if (gameResult !== null && gameResult !== undefined) {
            	opImage.style.width = "220px"; 
                opImage.style.height = "auto";
            	document.getElementById("opImage").src = "/images/op_ready.png";
                
            }   
            // end of 상대 code! 
                
                
            if (gameResult.result === "무승부") {
                document.getElementById("status").innerText = "🤝 무승부! 다시 선택!";
                enableGameButtons(true);
                return;
           }
            

            else if (gameResult.result === "승리") 
            	{
            	winCount++;
            	}
            
            
            
            else if (gameResult.result === "패배") {
                loseCount++;
                opponentWinCount++;
            }
            
            
            
            

            document.getElementById("score").innerText = winCount;
            document.getElementById("opponentWinCount").innerText = opponentWinCount;
            
            
            

            showPrompt(gameResult.result + "!", () => {
                if (winCount === 3 || loseCount === 3) {
                	
                    setTimeout(endGame, 200);
                } else {
                    showPrompt("안내면 진거 가위 바위 보!", () => enableGameButtons(true));
                }
            });

            fetchPlayerScore();
            fetchOpponentScore();
        }

        function startMatching() {
            if (!stompClient || !stompClient.connected) {
                connectWebSocket();
                setTimeout(() => stompClient.send("/app/match", {}, JSON.stringify({ playerId })), 500);
            } else {
                if (isGameOver) resetGame();
                stompClient.send("/app/match", {}, JSON.stringify({ playerId }));
            }
        }

        function sendMove(move) {
        	playerImage.style.width = "200px"; 
            playerImage.style.height = "auto";
            opImage.style.width = "180px";
            opImage.style.height = "auto";
            
            playerImage.classList.remove("move-win-player");
            opImage.classList.remove("move-lose-op");
            playerImage.classList.remove("move-draw-player");
            opImage.classList.remove("move-draw-op");
            playerImage.classList.remove("move-lose-player");
            opImage.classList.remove("move-win-op");
        	//버튼 클릭시 준비자세 시작.
        	playerImage.src = "/images/player_ready.png";
        	//상대는 idle
        	opImage.src = "/images/op.png";
        	
        	if (isGameOver) return;
            stompClient.send("/app/play", {}, JSON.stringify({ playerId, move }));
            document.getElementById("status").innerText = "결과 대기 중...";
            enableGameButtons(false);
        }

        function enableGameButtons(enable) {
            ["btnScissors", "btnRock", "btnPaper"].forEach(id => {
                document.getElementById(id).disabled = !enable;
            });
        }

        function showPrompt(text, callback) {
            const prompt = document.getElementById("roundPrompt");
            prompt.innerText = text;
            prompt.style.display = "block";
            setTimeout(() => {
                prompt.style.display = "none";
                if (callback) callback();
            }, 1800);
        }

        function showFinalMessage(text, isWin) {
            const finalMsg = document.getElementById("finalMessage");
            finalMsg.innerText = text;
            finalMsg.style.backgroundColor = isWin ? "rgba(40, 120, 70, 0.95)" : "rgba(120, 40, 40, 0.95)";
            finalMsg.style.display = "block";
        }

        function endGame() {
            isGameOver = true;
            enableGameButtons(false);
            document.getElementById("rematchButton").style.display = "inline";
            document.getElementById("serverMatchButton").style.display = "inline";
            document.getElementById("endEmoji").innerText = winCount === 3 ? "😄" : "😢";
            document.getElementById("endEmoji").style.display = "block";
            
            //showFinalMessage(winCount === 3 ? " 승자!!! " : " 패자!!! ", winCount === 3);
            if (winCount === 3) {
            	showWinBanner()
                
                }
            else if (loseCount === 3){
            	showLoseBanner()
            	}
        }

        function resetGame() {
            winCount = 0;
            loseCount = 0;
            opponentWinCount = 0;
            isGameOver = false;
            opponent = null;
            validRound = 0;
            document.getElementById("score").innerText = "0";
            document.getElementById("opponentWinCount").innerText = "0";
            document.getElementById("opponent").innerText = "없음";
            document.getElementById("result").innerText = "결과가 여기에 표시됩니다.";
            document.getElementById("endEmoji").style.display = "none";
            document.getElementById("rematchButton").style.display = "none";
            document.getElementById("serverMatchButton").style.display = "none";
            document.getElementById("finalMessage").style.display = "none";
        }

        function fetchPlayerScore() {
            fetch('/api/player-score?playerId=' + playerId)
                .then(response => response.json())
                .then(data => {
                    const displayName = data.isKing ? "👑 " + playerId : playerId;
                    document.getElementById("playerInfo").innerText = displayName;
                    document.getElementById("playerName").innerText = displayName;
                    document.getElementById("playerScore").innerText = data.score;
                    document.getElementById("playerScoreInBox").innerText = data.score;
                })
                .catch(error => console.error('점수 로드 실패:', error));
        }

        function fetchOpponentScore() {
            if (!opponent || opponent === '없음') return;
            fetch('/api/player-score?playerId=' + opponent)
                .then(response => response.json())
                .then(data => {
                    const opponentName = data.isKing ? "👑 " + opponent : opponent;
                    document.getElementById("opponent").innerText = opponentName;
                    document.getElementById("opponentScore").innerText = data.score;
                })
                .catch(error => console.error('상대 점수 로드 실패:', error));
        }

        function goToServerMatch() {
            location.href = "/game";
        }

        function goToRanking() {
            location.href = "/game/ranking";
        }

        window.onload = () => {
            connectWebSocket();
            fetchPlayerScore();
        };
        
        
        function flashScreenRed() {
            const flash = document.getElementById("screen-flash");
            flash.style.opacity = "0.8"; // 빨간색 보이기

            setTimeout(() => {
                flash.style.opacity = "0"; // 다시 숨김
            }, 50); // 0.05초
        }
        //플레이어 머리위에 가위바위 보 결과에 따라 이미지 출력하는 코드
        function showChoiceIcons(playerMove, opponentMove) {
            const playerChoice = document.getElementById("playerChoice");
            const opChoice = document.getElementById("opChoice");

            const moveToIcon = {
                "가위": "/images/sci_icon.png",
                "바위": "/images/fist_icon.png",
                "보": "/images/paper_icon.png"
            };

            // 선택지 이미지 세팅
            playerChoice.src = moveToIcon[playerMove];
            opChoice.src = moveToIcon[opponentMove];

            // 보이게 하기
            playerChoice.style.display = "block";
            opChoice.style.display = "block";

            // 몇 초 후에 사라지게 하고 싶으면 아래 코드 추가
            setTimeout(() => {
                playerChoice.style.display = "none";
                opChoice.style.display = "none";
            }, 2000);
        }
        
        function showWinBanner() {
            const winBanner = document.getElementById("winBanner");
            winBanner.style.opacity = "0.9";
            
            setTimeout(function() {
                winBanner.style.opacity = "0";
            }, 3000);
        }
        
        
        function showLoseBanner() {
            const loseBanner = document.getElementById("loseBanner");
            loseBanner.style.opacity = "0.9";
            
            setTimeout(function() {
                loseBanner.style.opacity = "0";
            }, 3000);
        }
    </script>
<img id="winBanner" src="/images/일검봉후.png" alt="승리 배너" />
<img id="loseBanner" src="/images/성인취의.png" alt="승리 배너" />
</body>
<div id="screen-flash"></div>
</html>
