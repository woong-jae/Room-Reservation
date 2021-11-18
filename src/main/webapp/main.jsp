<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>Insert title here</title>
<link rel="stylesheet" href="./style/globalStyle.css">
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
	#widget-wrapper {
		display: flex;
		justify-content: center;
	}
	#widget {
		display: flex;
		justify-content: space-between;
		margin-top: 40px;
		width: 80%;
	}
	.widget-item {
		width: 42%;
		height: 400px;
    	overflow-y: hidden;
    	display: flex;
    	flex-direction: column;
    	align-items: flex-start;
    	border: 1px solid lightgray;
    	padding: 40px;
	}
	.widget-title {
		display: flex;
		width: 100%;
    	justify-content: space-between;
    	align-items: center;
	}
	.widget-title h2 {
		margin: 0;
	}
	.widget-title button {
		border: none;
    	font-size: 1.5em;
    	cursor: pointer;
	}
	.widget-title button:hover {
		background: lightgray;
	}	
</style>
</head>
<body>
<%@ include file="./navbar.jsp" %>
<div id="main-middle">
	<button id="nav-room">강의실 예약 ➜</button>
	<% if(session.getAttribute("managerid") != null) out.println("매니저님 안녕하세요");%>
</div>
<div id="widget-wrapper">
	<div id="widget">
		<div class="widget-item">
			<div class="widget-title">
				<h2>공지사항</h2>
				<a href="./notice.jsp"><button>+</button></a>
			</div>
			<jsp:include page="./notice/noticeList.jsp" />
		</div>
		<div class="widget-item">
			<div class="widget-title">
				<h2>문의사항</h2>
				<a href="./report.jsp"><button>+</button></a>
			</div>
			<jsp:include page="./report/reportList.jsp" />
		</div>
	</div>
</div>
<%@ include file="./footer.jsp" %>
</body>
</html>