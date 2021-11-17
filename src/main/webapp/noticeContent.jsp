<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
#wrapper {
	display:flex;
    justify-content: center;
    margin-top: 20px;
}
#notice {
	width: 900px;
	border-top: 1px solid;
    border-bottom: 1px solid;
}
#notice-detail {
	display: flex;
	justify-content: flex-start;
	background: #f0f0f0;
	padding: 15px;
}
#notice-detail span {
	font-weight: bold;
	margin: 0 15px;
}
#notice-content {
	padding: 20px;
	height: 290px;
}
</style>
</head>
<body>
<%!
	String NoticeId = "";
	String NoticeMid = "";
	String NTitle = "";
	String NContent = "";
	String WrittenTime = "";
%>
<%@ include file="./connectDB.jsp" %>
<%@ include file="./navbar.jsp" %>
<div id="title">공지사항</div>
<%
	NoticeId = request.getParameter("NoticeId");
	String sql = "SELECT * FROM NOTICE WHERE NoticeId = " + NoticeId;
	try{
		rs = stmt.executeQuery(sql);
		rs.next();
		NoticeMid = rs.getString(1);
		NTitle = rs.getString(3);
		NContent = rs.getString(4);
		WrittenTime = rs.getString(5);
		rs.close();
	} catch (SQLException e) {
		System.err.println("sql error = " + e.getMessage());
	}
%>

<div id="wrapper">
	<div id="notice">
		<h3 style="padding-left: 15px;"><%= NTitle %></h3>
		<div id="notice-detail">
			<div><span>작성자</span><%= NoticeMid %></div>
			<div style="margin-left: 50px;"><span>등록일</span><%= WrittenTime %></div>
		</div>
		<div id="notice-content"><%= NContent %></div>
	</div>
</div>
</body>
</html>