<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=East+Sea+Dokdo&family=Hi+Melody&display=swap" rel="stylesheet">
<style>
    /* 배경 이미지와 중앙 배치 설정 */
    
     #body {/* 배경 이미지와 중앙 배치 설정 */
    height: 100%; /* 화면 전체를 꽉 채우도록 설정 */
    margin: 0;    /* 기본 마진 제거 */
    padding: 0;   /* 기본 패딩 제거 */
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box; /* 요소 크기 계산 시 padding, border 포함 */
}    
    
    	
   	 	
    	
    		@keyframes moveBackground {
    	0% {
        	background-position: 0 0;
    	}
    	100% {
        	background-position: -500px 500px; /* 왼쪽 아래로 이동 */
    	}
	}
    	
        #container {
        width: 100%;
    	height: 100vh; /* 화면 전체 높이 */
    	background-image: url('images/faces2.png');  /* 임시적으로 disabled*/
    	background-repeat: repeat; /* 이미지를 반복 */
    	background-size: 500px auto; /* 원래 크기로 반복 */
    	background-position: top left; /* 왼쪽 상단부터 반복 */
	
        background-color: #dfded3; 
        height: 100%; /* 화면 전체 높이 */
        display: flex;
        justify-content: center; /* 가로 중앙 정렬 */
        align-items: center; /* 세로 중앙 정렬 */
        
        
        animation: moveBackground 30s linear infinite;
		}
		    


        .signup-box {
        
        
        
        background-color: rgba(255, 255, 255, 0.6); /* 반투명 */
    	border-radius: 20px;
    	box-shadow: 0 0 15px rgba(0,0,0,0.2);
    	padding: 30px;
        
        
        
        text-align: center;
        width: 600px;
        height: 500px;
        font-family: "East Sea Dokdo", sans-serif; /* 필기체 느낌의 폰트 */
        display: flex; /* Flexbox로 자식 요소 정렬 */
        flex-direction: column; /* 세로 방향으로 배치 */
        align-items: center; /* 자식 요소 중앙 정렬 */
    }

    /* 타이틀 스타일 */
    h1 {
    	width: 400px; /* 이미지 너비에 맞춤 */
    	height: 150px;
    	color: #ffffff;
    	font-size: 50px;
    	margin-bottom: 10px;
    	font-weight: bold;
    	text-shadow: 5px 1px 2px rgba(0, 0, 0, 0.3);
    	
    	display: flex;
    	align-items: center;
    	justify-content: center;

    	background-image: url('images/line_l.png'); /* ✅ 이미지 경로 */
    	background-size: 400px auto; /* or contain */
    	background-repeat: no-repeat;
    	background-position: center;

    /* 배경이 보이게 하기 위한 설정 */
    	padding: 40px 20px;
    	display: inline-block;
    }
    
    .input-line {
    position: relative;
    width: 90%;
    margin: 10px auto;
	}

    /* 입력 필드 스타일 */
    input[type="text"], input[type="password"] {
    width: 100%;
    padding: 10px;
    border: none; /* 테두리 제거 */
    border-radius: 0;
    font-size: 30px;
    box-sizing: border-box;
    background-color: rgba(255, 255, 255, 0);
    font-family: "East Sea Dokdo", sans-serif;
    border-bottom: none;
    outline: none;
    box-shadow: none;
    }
    
    input[type="text"]:focus,
	input[type="password"]:focus {
    outline: none;
    box-shadow: none;
		}
	
	
	.input-line .line-img {
  	  position: absolute;
  	  left: 0;
   	  bottom: 5px; /* 입력란 아래에 살짝 붙게 */
      width: 100%;
      pointer-events: none; /* 클릭 안 되게 */
		}

   .button-group {
    display: flex;
    justify-content: center; /* 가운데 정렬 */
    gap: 20px; /* 버튼 사이 여백 */
	}

    /* 버튼 스타일 */
    input[type="button"] {
    width: 187.5px;    
    height: 50px;     
    background-color: transparent; /* 배경색 제거 */
    background-image: url('images/button.png'); /* ✅ 이미지 적용 */
    background-size: 100% 100%;
    background-repeat: no-repeat;
    background-position: center center;
    

    color: white;
    padding: 12px;
    border: none;
    
    cursor: pointer;
    font-size: 30px;
    width: 70%;
    margin: 10px 5px;
    /* margin 을 바꾸니까 버튼이 세로로 배치됨! */
    
    font-family: "East Sea Dokdo", sans-serif;
    display: inline-block;
    text-align: center;
    transition: filter 0.3s ease; /* 부드럽게 */
	}
    
 

    input[type="button"]:hover {
    filter: brightness(0.7); /* 이미지와 텍스트 모두 어둡게 */
	}


     
    

    /* 메시지 스타일 */
    .message {
        color: #ffffff;
        font-size: 14px;
    }
</style>



<script src="dbQuiz.js"></script>
<div id="container">
    <div class="signup-box">
	<div align="center">
	<h1>회원 등록</h1>
	<table >
	<tr><td>
		<font color="red" >${msg }</font>
	</td></tr>
	<tr><td>
	<form action="registProc" method="post" id="f">
		<div class="input-line">
			<input type="text" name="userName" id="userName" placeholder="이름" ><br>
			<img src="images/input_line.png" class="line-img" alt="밑줄 이미지"> 
		</div>
		
		<div class="input-line">
			<input type="text" name="id" placeholder="아이디" id="id"> <br>
			<img src="images/input_line.png" class="line-img" alt="밑줄 이미지"> 
		</div>
		
		
		<div class="input-line">
			<input type="password" name="pw" placeholder="비밀번호" id="pw"><br>
			<img src="images/input_line.png" class="line-img" alt="밑줄 이미지">
		</div>
		
		<div class="input-line">
			<input type="password" name="confirm" placeholder="비밀번호 확인 " id="confirm"
			onchange="pwCheck()">
			<img src="images/input_line.png" class="line-img" alt="밑줄 이미지">
		</div>
		
		
		<label id="label" ></label><br>
		
		
		
		<div class ="button-group">
			<input type="button" value="회원가입" onclick="allCheck()">
			<input type="button" value="취소" onclick="location.href='index'"><br>
		</div>	
	</form>
	</td></tr></table>
</div>
</div>
</div>





