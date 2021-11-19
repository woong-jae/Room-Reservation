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
#report {
	width: 900px;
	border-top: 1px solid;
    border-bottom: 1px solid;
}
#report-detail {
	display: flex;
	justify-content: flex-start;
	background: #f0f0f0;
	padding: 15px;
}
#report-detail span {
	font-weight: bold;
	margin: 0 15px;
}
#report-content {
	padding: 20px;
	height: 290px;
	word-break: break-all;
}
</style>
</head>
<body>
<%!
	String ReportId = "";
	String ReportUid = "";
	String RTitle = "";
	String RContent = "";
	String RTime = "";
%>
<%@ include file="./connectDB.jsp" %>
<%@ include file="./navbar.jsp" %>
<div id="title">문의사항</div>
<%
	ReportId = request.getParameter("ReportId");
	String sql = "SELECT * FROM REPORT WHERE ReportId = " + ReportId;
	try{
		rs = stmt.executeQuery(sql);
		rs.next();
		ReportUid = rs.getString(1);
		RTitle = rs.getString(3);
		RContent = rs.getString(4);
		RTime = rs.getString(5);
		rs.close();
	} catch (SQLException e) {
		System.err.println("sql error = " + e.getMessage());
	}
%>

<div id="wrapper">
	<div id="report">
		<h3 style="padding-left: 15px;"><%= RTitle %></h3>
		<div id="report-detail">
			<div><span>작성자</span><%= ReportUid %></div>
			<div style="margin-left: 50px;"><span>등록일</span><%= RTime %></div>
		</div>
		<div id="report-content"><%= RContent %></div>
	</div>
</div>
</body>
</html>