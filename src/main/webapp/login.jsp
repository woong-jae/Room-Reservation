<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="./style/globalStyle.css">
    <style>
    	.login-outer-area{
    		height:80%;
    		display:flex;;
    		justify-content: center;
    		padding:auto;
    	}
    	
    	.login-area{
    		width:40%;
    		height:90%;
    		display:flex;
    		justify-content: center;
    		flex-direction: column;
    	}
    	
    	.title{
    		width:100%;
    		font-size:5em;
    		text-align:center;
    	}
    	
    	.input-area{
    		padding : 0 auto;
    		display:grid;
    		grid-template-columns: 1fr 1fr 1fr 1fr;
    		grid-template-rows: 1fr 1fr 1fr;
    		column-gap : 10px;
    		row-gap : 10px;
    		width:80%;
    		height:30%;
    		margin:auto;
    	}
    	
    	.login_id{
    		grid-column: 1/4;
    		grid-row: 1/2;
    		border-radius:5px;
    		font-size:1.2em;
    		padding-left:10px;
    	}
    	
 		.login_pw{
    		grid-column: 1/4;
    		grid-row: 2/3;
    		border-radius:5px;
    		font-size:1.2em;
    		padding-left:10px;
    	}
    	
    	.submit_btn{
    		grid-column : 4/5;
    		grid-row : 1/3;
    		background:#b41a1f;
    		color:white;
    		font-size:1.3em;
    		border-radius:5px;
    		border:none;
    	}
    	
    	.submit_btn:hover{
    		background:#951418;
    		cursor:pointer;
    	}
    	
    	a{
    		text-decoration : none;
    	}
    	
    	.toggle-bg{
    		background:#951418;
    		width:60px;
    		height:34px;
    		border-radius:20px;
    		display:flex;
    		cursor:pointer;
    	}
    	
    	.toggle-circle{
    		background:white;
    		width:26px;
    		height:26px;
    		border-radius:35px;
    		margin:4px;
    	}
    	
    	.toggle-circle-click{
    		background:white;
    		width:26px;
    		height:26px;
    		border-radius:35px;
    		margin:4px;
    		margin-left:30px;
    	}
    	
    	.toggle-bg input{
    		display:none
    	}
    	
    	.signup-link{
    		text-align:center;
    	}
    </style>
</head>
<%
	if(session.getAttribute("userid") != null || session.getAttribute("managerid") != null){
		//로그인 된 상태로 강제로 접속하는 경우 main으로 redirect
		response.sendRedirect("main.jsp");
	}
%>
<body>
<%@ include file="./navbar.jsp" %>
	<div class="login-outer-area">
		<div class="login-area">
			<h1 class="title" id="title">Login</h1>
			<form class="input-area" name="login" method="post" action="./loginDB.jsp">
				<input class="login_id" name="id" placeholder="아이디" required>
			    <input class="login_pw" name="pw"  placeholder="비밀번호" type="password" required>
			    <input class="submit_btn" type="submit" value="로그인">
			    <div class="toggle-bg" id="toggle" onclick="changeLoginMode()">
				    <div class="toggle-circle" id="toggle_circle">
				    <input id="user" type="radio" name="login_type" value="user" required checked>
					<input id="manager" type="radio" name="login_type" value="manager" required>
				    </div>
			    </div>
		    </form>
		    <p class="signup-link">계정이 없으신가요? <a style="margin:0 auto;" href="./signUp.jsp">회원가입</a></p>
		</div>
	</div>
<%@ include file="./footer.jsp" %>
<script>
	function changeLoginMode(){
		const toggle = document.getElementById("toggle_circle");
		const title = document.getElementById("title");
		const userRadio = document.getElementById("user");
		const managerRadio = document.getElementById("manager");
		if(toggle.classList.value === "toggle-circle"){
			title.innerText = "Manager";
			userRadio.checked = false;
			managerRadio.checked = true;
		}else{
			title.innerText = "Login";
			userRadio.checked = true;
			managerRadio.checked = false;
		}
		toggle.classList.toggle('toggle-circle');
		toggle.classList.toggle('toggle-circle-click');
	}
</script>
</body>
</html>