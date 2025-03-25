<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
    
    
    
    a {
        text-decoration: none;
        color: black;
        position: relative;
        font-size: 20px;
        font-weight: bold;
        padding: 5px 10px;
    }

    ul {
        padding: 20px;
        list-style: none;
    }

    ul li {
        display: block;
        padding: 10px;
        text-align: center;
        position: relative;
    }

    .main_div {
        height: 150px;
        padding-top: 80px;
    }
    .button-container-2 {
  	position: relative;
  	width: 100px;
  	height: 50px;
  	margin-left: auto;
  	margin-right: auto;
  	margin-top: 7vh;
  	overflow: hidden;
  	border: 1px solid #000;
  	font-family: 'Lato', sans-serif;
  	font-weight: 300;
  	transition: 0.5s;
  	letter-spacing: 1px;
  	border-radius: 8px;
	}	

	.button-container-2 button {
 	 width: 101%;
  	height: 100%;
  	font-family: 'Lato', sans-serif;
  	font-weight: bold;
  	font-size: 11px;
  	letter-spacing: 1px;
  	background: #000;
  	-webkit-mask: url("https://raw.githubusercontent.com/robin-dela/css-mask-animation/master/img/urban-sprite.png");
  	mask: url("https://raw.githubusercontent.com/robin-dela/css-mask-animation/master/img/urban-sprite.png");
  	-webkit-mask-size: 3000% 100%;
  	mask-size: 3000% 100%;
  	border: none;
  	color: #fff;
  	cursor: pointer;
  	-webkit-animation: ani2 0.7s steps(29) forwards;
  	animation: ani2 0.7s steps(29) forwards;
	}

	.button-container-2 button:hover {
 	 -webkit-animation: ani 0.7s steps(29) forwards;
  	animation: ani 0.7s steps(29) forwards;
	}
	.mas {
  	position: absolute;
  	color: #000;
 	text-align: center;
  	width: 101%;
  	font-family: 'Lato', sans-serif;
  	font-weight: bold;
  	font-size: 11px;
  	margin-top: 17px;
  	overflow: hidden;
	}

	@-webkit-keyframes ani {
  	from {
    	-webkit-mask-position: 0 0;
    	mask-position: 0 0;
  	}
  	to {
    	-webkit-mask-position: 100% 0;
    	mask-position: 100% 0;
  	}
	}

	@keyframes ani {
  	from {
    	-webkit-mask-position: 0 0;
    	mask-position: 0 0;
  	}
  	to {
    	-webkit-mask-position: 100% 0;
    	mask-position: 100% 0;
  	}
	}

	@-webkit-keyframes ani2 {
  	from {
    	-webkit-mask-position: 100% 0;
    	mask-position: 100% 0;
  	}
  	to {
    	-webkit-mask-position: 0 0;
    	mask-position: 0 0;
  	}
	}

	@keyframes ani2 {
  	from {
    	-webkit-mask-position: 100% 0;
    	mask-position: 100% 0;
  	}
  	to {
    	-webkit-mask-position: 0 0;
    	mask-position: 0 0;
  	}
	}
	

</style>    






<c:url var="context" value="/"/>
<div class="button-container-2">
    
    <span class="mas">Welcome!</span>
  <button type="button" name="Hover" onclick="location.href='regist'">회원가입</button>
</div>


<div class="button-container-2">
    <span class="mas">Let's go!</span>
    
  <button type="button" name="Hover" onclick="location.href='login'"]>로그인</button>
</div>






