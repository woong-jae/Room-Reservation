<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="height: 100%;">
<head>
<title>Insert title here</title>
<style type="text/css">
#main-middle {
	height: 70%;
	display: flex;
   	justify-content: flex-end;
   	align-items: center;
   	background: lightgray;
}
#nav-room {
	width: 200px;
    height: 80px;
    color: #fff;
    background: #b41a1f;
    border: none;
    border-radius: 5px;
    font-size: 1.3em;
    font-weight: 700;
    cursor: pointer;
    margin-right: 200px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
}
#nav-room:hover {
	background: #951418;
}
</style>
</head>
<body style="margin: 0;height: 100%;">
<%@ include file="./navbar.jsp" %>
<div id="main-middle">
	<button id="nav-room">강의실 예약 ➜</button>
</div>
<footer></footer>
</body>
</html>