<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ include file="./connectDB.jsp" %>
<%
	String id = request.getParameter("id");

	String sql = "Select userid from KNU_USER WHERE userid='" + id + "'";
	
	try {
		rs = stmt.executeQuery(sql);
		if (rs.next() == false) {
			response.setHeader("id_check", "true");
		}
		else{
			response.setHeader("id_check", "false");
			
		}
	} catch (SQLException e) {
		System.out.println("sql error = " + e.getMessage());
	}
%>

</body>
</html>