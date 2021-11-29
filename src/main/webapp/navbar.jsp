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
.right-border{
	height:15px;
	border-right : 1px solid #666;
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

.menu{
	display:grid;
	grid-template-rows:1fr 1px 1fr;
	text-align:center;
	width:100px; 
	height:100px; 
	color:black;
	background-color:white; 
	position:absolute; 
	border: 1px solid lightgray;
	z-index: 0; 
	top:80px;
	border-radius:5px;
	margin-left:50px;
}

.menu div{
	display:flex;
	justify-content: center;
	align-items: center;
}

.menu-item{
	cursor: pointer;
	text-decoration: none;
    color: black;
}

.menu div:hover{
	background: #fafafa;
}

.hidden{
	display:none
}

</style>
<script>
	function showhide(){
		const menu = document.getElementById("menu");
		
		menu.classList.toggle('hidden');
	}
</script>

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
	<a href="./" class="nav-item" id="nav-logo">KNU&nbsp;<span>ROOM</span></a>
	<div id="nav-wrapper">
		<a href="./notice.jsp" class="nav-item">공지사항</a>
		<div class="right-border"></div>
		<a href="./report.jsp" class="nav-item">문의사항</a>
		<div class="right-border"></div>
		<a href="./rooms.jsp" class="nav-item">강의실</a>
		<%
		if(session.getAttribute("userid") == null && session.getAttribute("managerid") == null){
		%>
		<a href="./login.jsp" class="nav-item" id="nav-login">로그인</a>
		<%
		}else{
		%>
		<div>
			<div class="nav-item" id="nav-login" style="z-index: 2;" onclick="showhide()"><%= id %> ▼</div>
			<div id="menu" class="menu hidden">
				<%
				if(session.getAttribute("managerid") == null){
				%>
				<div><a class="menu-item" href="./myPage.jsp">내 정보</a></div>
				<%
				}else{
				%>
				<div><a class="menu-item" href="./myPage.jsp">관리</a></div>
				<%} %>
				<div style="width:35px; margin-left:32.5px; border-bottom:1px solid #d0d0d0"></div>
				<div><a class="menu-item" href="./logout.jsp">로그아웃</a></div>
			</div>
		</div>
		<%} %>
	</div>
</nav>