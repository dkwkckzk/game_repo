<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<head>
    <style>
        /* Google Fonts에서 폰트 가져오기 */
        @import url('https://fonts.googleapis.com/css2?family=East+Sea+Dokdo&display=swap');
		.moon img {
            width: 200px; /* 너비 조정 (원하는 크기로 변경 가능) */
            height: auto; /* 높이 자동 조정 (비율 유지) */
            display: block; /* 필요 시 블록 요소로 설정 */
            margin: 0 auto; /* 가운데 정렬 */
        }
        
        .Sun img {
            width: 200px; /* 너비 조정 (원하는 크기로 변경 가능) */
            height: auto; /* 높이 자동 조정 (비율 유지) */
            display: block; /* 필요 시 블록 요소로 설정 */
            margin: 0 auto; /* 가운데 정렬 */
        }
        
        body {
            background-color: #f9f9f9; /* 배경색 설정 */
            background-image: url('images/bam-l.png'), url('images/bam-r.png'); /* 배경 이미지 설정 */
            background-position: -20px calc(100% + 180px), right calc(100% + 180px);
            background-repeat: no-repeat, no-repeat; /* 반복 방지 */
            background-size: 550px auto, 550px auto; /* 이미지 크기 조정 (너비 150px, 높이 자동) */
            margin: 0;
            padding-top: 0px; /* 텍스트를 위로 당기기 위해 여백 조절 */
        }

        .title {
            font-size: 100px;
            color: #333;
            font-family: 'East Sea Dokdo', cursive; /* 폰트 적용 */
            text-shadow: 4px 4px 1px rgba(0, 0, 0, 0.5); /* X-축, Y-축, 블러 정도, 색상 */
        }

        .main_div {
            text-align: center;
            margin-top: -120px; /* 필요 시 추가로 조절 가능 */
            
        }
        .katana img {
            width: 300px; /* 너비 조정 (원하는 크기로 변경 가능) */
            height: auto; /* 높이 자동 조정 (비율 유지) */
            display: block; /* 필요 시 블록 요소로 설정 */
            margin: -20px auto 0 auto;
        	}
        .login-info {
  		    text-align: center;
    		margin-top: 10px;
    		font-size: 18px;
    		color: #555;
				}	
    </style>






<body>
	

	<div class="Sun">
		 <img src="images/Sun.png" alt="sun image">
	</div>
	
    <div class="main_div">
        <span class="title">가위! 바위! 보!</span><br>
        
        
    </div>
    
    <div class="katana">
		 
		 <div class="login-info">Logged in as: ${sessionScope.id }</div>
	</div>
	
	
</body>