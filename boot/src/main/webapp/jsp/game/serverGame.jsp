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
		/* 화면 전체 덮는 빨간 플래시 */
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
    	background-color: #ffffff; /* 이 줄은 삭제하거나 덮어쓰기 */
    	background-image: url('/images/fight_bg_deco.png'); /* ✅ 배경 이미지 설정 */
    	background-size: cover; /* ✅ 화면 전체를 덮도록 */
    	background-position: center; /* ✅ 중앙 정렬 */
    	background-repeat: no-repeat; /* ✅ 반복 방지 */
    	padding: 30px;
    	color: #ffffff;
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
        
        
        .img-button {
  		background: none;
  		border: none;
  		padding: 0;
  		margin: 0;
  		cursor: pointer;
		}
        .status-box {
            margin-top: 20px;
            font-size: 22px;
            color: #4e3d30;
            /*border-top: 2px dashed #a08058;*/
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
        .page-bottom {
    	display: flex;
    	justify-content: flex-start;
    	align-items: flex-end;
    	margin-top: 50px; /* 페이지 아래로 밀어주기 */
    	height: 150px;     /* 원하는 높이만큼 */
		}

		.move-buttons {
    	display: flex;
    	flex-direction: row;
    	align-items: flex-start;
    	gap: 10px;
		}
		
		.move-icon {
  		width: 100px;
  		height: auto;
  		pointer-events: none; /* 클릭은 버튼이 처리, 이미지는 무시 */
  		transition: transform 0.2s ease;
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
		}

		.player-image img {
    	width: 200px;   /* 사이즈 줄이기 */
    	height: auto;
    	margin-left: 10px; /* 약간의 여백 */
		}
		
		
		#playerImage {
 		 width: 200px;
  		height: auto;
		}
		
		.move-right-75 {
    	transform: translateX(+50vw);
    	transition: transform 0.05s ease-in-out;
		}

		.move-left-50 {
    	transform: translateX(-42vw);
    	transition: transform 0.05s ease-in-out;
		}
    </style>
</head>
<body>
    <h2>📜 <%= playerId %> 님의 서버 대결 모드 📜</h2>
    <div class="status-box">
        <h3>현재 상태: <span id="status">대기 중</span></h3>
    </div>
     

    <div class="button-bar">
        <button id="goToMatch" onclick="goToMatch()"> 랜덤 매칭하기</button>
        <button id="startServerMatch" onclick="startServerMatch()"> 서버 대결 시작</button>
        <button id="quitServerMatch" onclick="quitServerMatch()" style="display:none;"> 서버 대결 종료</button>
    </div>
    
    
    
    <div class="player-op-wrap">
  		<img id="playerImage" src="/images/player.png" alt="플레이어" />
  		<img id="opImage" src="/images/op.png" alt="상대" />
	</div>
	
	
  		
  		
		
    

    

    <div class="page-bottom">
    
    	<div class = "img-button">
    	
        <button id="btnScissors" onclick="sendMove('가위')" disabled> 
        	<img src="/images/sci_icon.png" alt="가위" class="move-icon">
        </button>
        <button id="btnRock" onclick="sendMove('바위')" disabled> 
        	<img src="/images/fist_icon.png" alt="바위" class="move-icon">
        </button>
        <button id="btnPaper" onclick="sendMove('보')" disabled>
        	<img src="/images/paper_icon.png" alt="보" class="move-icon">
        
        </button>
    	</div>
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
                
                
                
                
                document.getElementById("playerImage").src = "/images/player_ready.png";
                document.getElementById("opImage").src = "/images/op_ready.png";

                // 1초 후 결과 이미지 출력
                setTimeout(function () {
                	
                	flashScreenRed(); // ← 1초 후 화면 깜빡임 실행
					
                	const playerImage = document.getElementById("playerImage");
                    const opImage = document.getElementById("opImage");
                	
                    //var playerImage = document.getElementById("playerImage");
                    //변수 두번 선언하면 glitch

                    if (gameResult.result === "무승부") {
                        playerImage.src = "/images/player_drawsword.png";
                        playerImage.style.width = "320px"; 
                        playerImage.style.height = "auto";

                    } else if (gameResult.result === "승리") {
                        playerImage.src = "/images/player_drawsword.png";
                        playerImage.style.width = "320px"; 
                        playerImage.style.height = "auto";
                        playerImage.classList.add("move-right-75");
                    } else if (gameResult.result === "패배") {
                        playerImage.src = "/images/player_die.png";
                    }
                    
                    
                    
                    if (gameResult.result === "무승부") {
                        opImage.src = "/images/op_drawsword.png";
                        opImage.style.width = "280px";
                        opImage.style.height = "auto";
                    } else if (gameResult.result === "패배") {
                        opImage.src = "/images/op_drawsword.png";
                        opImage.style.width = "280px"; 
                        opImage.style.height = "auto";
                    } else if (gameResult.result === "승리") {
                        opImage.src = "/images/op_die.png";
                        opImage.classList.add("move-left-50");
                        opImage.style.width = "250px";
                        opImage.style.height = "auto";
                    }

                    // 상대 이미지도 결과에 맞게 바꾸고 싶다면 여기에 추가 가능
                }, 1000); // 1000ms = 1초
                
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
        	// 이미지 원위치 초기화
            const playerImage = document.getElementById("playerImage");
            playerImage.style.width = "200px"; 
            playerImage.style.height = "auto";
            const opImage = document.getElementById("opImage");
            opImage.style.width = "200px";
            opImage.style.height = "auto";

            // 클래스 제거 (움직인 상태 리셋)
            playerImage.classList.remove("move-right-75");
            opImage.classList.remove("move-left-50");

            // 준비 이미지로 변경
            playerImage.src = "/images/player_ready.png";
            opImage.src = "/images/op_ready.png";
            
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
        
        
        
        function flashScreenRed() {
            const flash = document.getElementById("screen-flash");
            flash.style.opacity = "0.8"; // 빨간색 보이기

            setTimeout(() => {
                flash.style.opacity = "0"; // 다시 숨김
            }, 50); // 0.05초
        }
        
        
        
    </script>
</body>
<div id="screen-flash"></div>
</html>
