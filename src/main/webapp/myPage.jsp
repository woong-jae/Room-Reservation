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
	margin-right: 30px;
}
</style>
</head>
<body>
<%@ include file="./connectDB.jsp" %>
<%!
	String Name = "";
	String StudentId = "";
	String UserId = "";
	String Department = "";
%>
<%
	UserId = session.getAttribute("userid").toString();
	if(session.getAttribute("userid") == null && session.getAttribute("managerid") == null){
		out.println("<script>alert('로그인을 하십시오.');</script>");
		out.println("<script>location.href='main.jsp';</script>");
	}
%>
<%
	String sql = "SELECT Name, StudentId, Department FROM KNU_USER WHERE UserId = '" + UserId + "'";
	try{
		rs = stmt.executeQuery(sql);
		rs.next();
		Name =  rs.getString(1);
		StudentId =  rs.getString(2);
		Department =  rs.getString(3);
		rs.close();
	} catch (SQLException e) {
		System.err.println("sql error = " + e.getMessage());
	}
%>
<%@ include file="./navbar.jsp" %>
<div id="title">마이페이지</div>
<div id="mypage">
	<div id="mypage-wrapper">
		<div id="mypage-userInfo" class="mypage-contents">
			<div><span>이름&nbsp;&nbsp;&nbsp; :</span><%= Name %></div>
			<div><span>학번&nbsp;&nbsp;&nbsp; :</span><%= StudentId %></div>
			<div><span>아이디 :</span><%= UserId %></div>
			<div><span>학과&nbsp;&nbsp;&nbsp; :</span><%= Department %></div>
		</div>
		<div id="mypage-roomInfo" class="mypage-contents">
			<div style="text-align:center;font-weight: bold;">강의실 예약내역</div>
		</div>
	</div>
</div>
<%@ include file="./footer.jsp" %>
</body>
</html>