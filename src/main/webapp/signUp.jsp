<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <link rel="icon" href="./image/favicon.png">
    <link rel="stylesheet" href="./style/globalStyle.css">
    <style>
    	#title {
			display: flex;
		    align-items: center;
		    justify-content: center;
		    font-size: 1.5em;
		    font-weight: 500;
			height: 130px;
			background: #f0f0f0;
		}
    	
    	.signup-outer-area{
    		height:80%;
    	}
    	
    	div form{
    		display:flex;
    		flex-direction: column;
    		width:30%;
    		height:100%;
    		margin:50px auto 0px;
    	}
    	
    	input{
    		height:30px;
    		border-width:1px;
    		border-radius:5px;
    		padding-left:10px;
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
    		try{
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
    		}catch(error){
    			console.log(error);
    			return false;
    		}
    	}
    	
    	function makefalse(){
    		id_check = "false";
    	}
    </script>
</head>
<body>
<%@ include file="./navbar.jsp" %>
<div id="title">회원가입</div>
<div class="signup-outer-area">
    <form name="signup" method="post" action="./signUpDB.jsp" onsubmit="return signUpCheck()">
    	<p>이름</p>
        <input name="name" id="name" required>
        <p>ID</p>
        <input name="id" id="id" maxlength="15" onchange="makefalse()" required>
        <button class="id_check_btn" style="margin-top:10px;" type="button" onclick="idCheck()">ID 중복체크</button>
        <p>비밀번호</p>
        <input name="pw" type="password" maxlength="15" required>
        <p>비밀번호 확인</p>
        <input name="pw_check" type="password" maxlength="15" required>
        <p>전공</p>
        <select name="major" required>
            <option value="컴퓨터공학부" selected>컴퓨터공학부</option>
            <option value="전기공학과">전기공학과</option>
            <option value="전자공학부">전자공학부</option>
        </select>
        <p>학번</p>
        <input id="sid" name="sid" type="number" required>
        <input class="btn" style="margin-top:30px;"type="submit" value="회원가입">
    </form>
</div>
<%@ include file="./footer.jsp" %>
<script>
//이름 Byte 관리 코드
document.getElementById('name').addEventListener('keyup', checkNameByte);
const number = document.getElementById('sid');
number.addEventListener('keyup', checkSIDByte);

number.onkeydown = function(e) {
    if(!((e.keyCode > 95 && e.keyCode < 106)
      || (e.keyCode > 47 && e.keyCode < 58) 
      || e.keyCode == 8)) {
        return false;
    }
}

let name = "";
const MAX_NAME_LIMIT = 15;

function checkNameByte(event){
	let count = 0;
	
	for(index = 0; index < event.target.value.length; index++){
		if(event.target.value.charCodeAt(index) <= 128) count++;
		else count += 2;
	}
	
	if(count <= MAX_NAME_LIMIT){
		name = event.target.value;
	}else{
		alert("이름은 " + MAX_NAME_LIMIT + " Bytes만큼만 입력할 수 있습니다.\n(한글 : 2 Bytes, 영문 : 1 Bytes))");
		event.target.value = name;
	}
}

let sid = "";
const MAX_SID_LIMIT = 10;

function checkSIDByte(event){
	let count = 0;
	
	for(index = 0; index < event.target.value.length; index++){
		if(event.target.value.charCodeAt(index) <= 128) count++;
		else count += 2;
	}
	
	if(count <= MAX_SID_LIMIT){
		sid = event.target.value;
	}else{
		event.target.value = sid;
	}
}
</script>
</body>
</html>