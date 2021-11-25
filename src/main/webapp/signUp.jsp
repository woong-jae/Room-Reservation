<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="./style/globalStyle.css">
    <style>
    	.btn{
	    	background:#b41a1f;
	    	font-size:1em;
	    	
	    	color:white;
	    	border-radius:5px;
	    	border:none;
    	}
    	
    	.btn:hover{
    		background:#951418;
    		cursor:pointer;
    	}
    	
    	.id_check_btn{
	    	background:#808080;
	    	font-size:1em;
	    	color:white;
	    	border-radius:5px;
	    	border:none;
    	}
    	
    	.id_check_btn:hover{
    		background:#606060;
    		cursor:pointer;
    	}
    	
    	.signup-outer-area{
    		height:100%;
    	}
    	
    	.title{
    		width:100%;
    		font-size:5em;
    		text-align:center;
    	}
    	
    	div form{
    		display:flex;
    		flex-direction: column;
    		width:30%;
    		height:80%;
    		margin:0 auto;
    	}
    	
    	input{
    		height:30px;
    		border-width:1px;
    		border-radius:5px;
    		padding-left:10px;
    	}
    	
    	input[type="number"]::-webkit-outer-spin-button,
		input[type="number"]::-webkit-inner-spin-button {
		    -webkit-appearance: none;
		    margin: 0;
		}
		
    	select{
    		height:37px;
    		border-radius:5px;
    		padding-left:10px;
    	}
    	
    	select:hover{
    		background:#f0f0f0;
    		cursor:pointer;
    	}
    	
    	p{
    		margin:10px;
    		font-style:bold;
    	}
    </style>
    <script>
		let id_check = "false";
    	
    	function idCheck(){
    		const id = document.getElementById("id").value;
    		
    		const idPattern = /[^a-zA-Z0-9]/;//영어숫자
    		
    		if(idPattern.test(id)){
    			alert("아이디는 영숫자 이외에 들어갈 수 없습니다.");
    			return;
    		}
    		
    		if(id.length < 5 || id.length > 13){
    			alert("아이디는 5~13글자입니다.");
    			return;
    		}
    		
    		var xmlHttp = new XMLHttpRequest();
    			
    		xmlHttp.onreadystatechange = function() {
			    if(this.status == 200 && this.readyState == this.DONE) {
			        id_check = xmlHttp.getResponseHeader("id_check");
			        if(id_check === "true")
			        	alert("사용 가능한 ID입니다.");
			        else
			        	alert("중복된 ID입니다.")
			    }
			};

			xmlHttp.open("GET", "./idCheck.jsp?id="+id, true);
			xmlHttp.send();
    	}
    	
    	function signUpCheck(){
    		//회원가입 입력값 유효성 체크
    		//정규표현식 이용
    		const namePattern = /[^ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z]/;//한글영어
    		const pwPattern = /[^a-zA-Z0-9!@#$%^&*]/;//영어숫자특수기호
    		const sidPattern = /[^0-9]///학번
    		
    		const input = document.querySelectorAll("input");
    		
    		const name = input[0].value;
    		
    		if(namePattern.test(name)){
    			alert("이름은 영문/한글 이외에 들어갈 수 없습니다.");
    			return false;
    		}
    		
    		if(name.length > 7){
    			alert("7글자까지 작성 가능합니다");
    			return false;
    		}
    		
    		const pw = input[2].value;
    		
    		if(pwPattern.test(pw)){
    			alert("비밀번호는 영숫자 및 !@#%$^&*만 사용 가능합니다.");
    			return false;
    		}
    		
    		if(pw.length < 5 || pw.length > 13){
    			alert("비밀번호는 5~13자로 설정해야합니다.");
    			return false;
    		}
    		
    		const pw_check = input[3].value;
    		
    		if(pw !== pw_check){
    			alert("비밀번호 값이 다릅니다.");
    			return false;
    		}
    		
    		const sid = input[4].value;
    		
    		if(sid.length != 10){
    			alert("학번을 올바로 입력하세요.");
    			return false;
    		}
    		
    		if(id_check === "false"){
    			alert("ID 중복 체크를 해주세요.");
    			return false;
    		}
    		return true;
    	}
    	
    	function makefalse(){
    		id_check = "false";
    	}
    </script>
</head>
<body>
<%@ include file="./navbar.jsp" %>
<div class="signup-outer-area">
	<div>
		<h1 class="title">회원가입</h1>
    <form name="signup" method="post" action="./signUpDB.jsp" onsubmit="return signUpCheck()">
    	<p>이름</p>
        <input name="name" required>
        <p>ID</p>
        <input name="id" id="id" onchange="makefalse()" required>
        <button class="id_check_btn" style="margin-top:10px;" type="button" onclick="idCheck()">ID 중복체크</button>
        <p>비밀번호</p>
        <input name="pw" type="password" required>
        <p>비밀번호 확인</p>
        <input name="pw_check" type="password" required>
        <p>전공</p>
        <select name="major" required>
            <option value="컴퓨터공학부" selected>컴퓨터공학부</option>
            <option value="전기공학과">전기공학과</option>
            <option value="전자공학부">전자공학부</option>
        </select>
        <p>학번</p>
        <input name="sid" type="number" required>
        <input class="btn" style="margin-top:30px;"type="submit" value="회원가입">
    </form>
	</div>
</div>
<%@ include file="./footer.jsp" %>
</body>
</html>