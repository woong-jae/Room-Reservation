<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>
<%@ include file="./connectDB.jsp" %>
<%
	request.setCharacterEncoding("utf-8");//한글 깨짐 방지

	String name = request.getParameter("name");
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	String major = request.getParameter("major");
	String sid = request.getParameter("sid");
	
	String sql = "INSERT INTO KNU_USER VALUES ('" + name + "', '" + id + "', '" + pw + "', '" + major + "', " + sid + ")";
	
	out.println(sql);
	
	try {
		stmt.executeUpdate(sql);
	} catch (SQLException e) {
		System.out.println("sql error = " + e.getMessage());
		//**에러처리
	}
	
	//stmt(rs), conn 종료
	try {
		stmt.close();
		conn.close();
	} catch (SQLException e) {
		e.printStackTrace();
		//**에러처리
	}
	
	//main.jsp로 이동
	response.sendRedirect("main.jsp");
%>
</body>
</html>