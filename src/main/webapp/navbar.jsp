<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    
<style type="text/css">
nav {
	display: flex;
	justify-content: space-around;
	border-bottom: 1px solid lightgray;
}
#nav-wrapper {
	display: flex;
	align-items: center;
}
.nav-item {
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100px;
	width: 180px;
	font-weight: 500;
	font-size: 16px;
	cursor: pointer;
	text-decoration: none;
    color: black;
}
.nav-item:hover {
	background: #fafafa;
}
#nav-logo {
	margin-right: 220px
}
#nav-logo:hover {
	background: none !important;
}
#nav-login {
	border-radius: 50px;
    height: 40px;
    width: 100px;
    border: 1px solid lightgray;
    margin-left: 50px;
    margin-right: 80px;
}
</style>

<nav>
	<a href="./main.jsp" class="nav-item" id="nav-logo">로고</a>
	<div id="nav-wrapper">
		<a href="./notice.jsp" class="nav-item">공지사항</a>
		<a href="./report.jsp" class="nav-item">문의사항</a>
		<a href="./myPage.jsp" class="nav-item">마이페이지</a>
		<%
		if(session.getAttribute("userid") == null && session.getAttribute("managerid") == null){
			//나중에 user navbar랑 manager navbar 분리해도 괜찮을 듯
		%>
		<a href="./login.jsp" class="nav-item" id="nav-login">로그인</a>
		<%
		}else{
		%>
		<a href="./logout.jsp" class="nav-item" id="nav-login">로그아웃</a>
		<%} %>
	</div>
</nav>