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
	margin-right: 220px;
	margin-left: 80px;
    font-size: 2em;
    color: #b41a1f;
    font-weight: 800;
    width: auto;
}
#nav-logo span {
	color: black;
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

.hidden{
	opacity:0%;
	cursor:default;
}
</style>

<%
	String id = "";
	if(session.getAttribute("userid") == null){
		if(session.getAttribute("managerid") == null){
			id = null;
		}else{
			id = session.getAttribute("managerid").toString();
		}
	}else{
		id = session.getAttribute("userid").toString();
	}
%>

<nav>
	<a href="./main.jsp" class="nav-item" id="nav-logo">KNU&nbsp;<span>ROOM</span></a>
	<div id="nav-wrapper">
		<%
		if(session.getAttribute("userid") == null && session.getAttribute("managerid") == null){
		%>
		<a class="nav-item hidden"></a>
		<%
		}
		%>
		<a href="./notice.jsp" class="nav-item">공지사항</a>
		<a href="./report.jsp" class="nav-item">문의사항</a>
		<a href="./rooms.jsp" class="nav-item">예약하기</a>
		<%
		if(session.getAttribute("userid") == null && session.getAttribute("managerid") == null){
		%>
		<a href="./login.jsp" class="nav-item" id="nav-login">로그인</a>
		<%
		}else{
		%>
		<a href="./myPage.jsp" class="nav-item"><%= id %> 님</a>
		<a href="./logout.jsp" class="nav-item" id="nav-login">로그아웃</a>
		<%} %>
	</div>
</nav>