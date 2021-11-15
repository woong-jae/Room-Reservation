<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="./style/globalStyle.css">
<style type="text/css">
#title {
	display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.5em;
    font-weight: 500;
	height: 130px;
	background: #f0f0f0;
}
#mypage {
	display: flex;	
	justify-content: center;
}
#mypage-wrapper {
	display: flex;	
	justify-content: space-around;
	width: 1100px;
}
.mypage-contents {
	display: flex;	
	flex-direction: column;
	margin-top: 70px;
    padding: 20px;
    height: 300px;
    border: 1px solid lightgray;
}
#mypage-userInfo {
	justify-content: space-around;
	width: 300px;
}
#mypage-roomInfo {
	width: 500px;
}
span {
	font-weight: bold;
}
</style>
</head>
<body>
<%@ include file="./navbar.jsp" %>
<div id="title">마이페이지</div>
<div id="mypage">
	<div id="mypage-wrapper">
		<div id="mypage-userInfo" class="mypage-contents">
			<div><span>이름:</span></div>
			<div><span>학번:</span></div>
			<div><span>아이디:</span></div>
			<div><span>비밀번호:</span></div>
			<div><span>학과:</span></div>
		</div>
		<div id="mypage-roomInfo" class="mypage-contents">
			<div style="text-align:center;font-weight: bold;">강의실 예약내역</div>
		</div>
	</div>
</div>
</body>
</html>