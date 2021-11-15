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
    margin-left: 100px;
}
</style>

<nav>
	<div class="nav-item" id="nav-logo"><a href="./main.jsp">로고</a></div>
	<div id="nav-wrapper">
		<div class="nav-item">공지사항</div>
		<div class="nav-item">문의사항</div>
		<div class="nav-item">마이페이지</div>
		<div class="nav-item" id="nav-login">로그인</div>
	</div>
</nav>