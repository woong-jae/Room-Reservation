<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>
<%
	//세션 정보 삭제
	if(session.getAttribute("managerid") != null)
		session.removeAttribute("managerid");
	if(session.getAttribute("userid") != null)
		session.removeAttribute("userid");
	//main으로 이동
	response.sendRedirect("main.jsp");
%>
</body>
</html>