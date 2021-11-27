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
	//파라미터 가져옴
	String user_id = session.getAttribute("userid").toString();
	String name = request.getParameter("name");
	String sid = request.getParameter("sid");
	String major = request.getParameter("major");
	
	String sql = "UPDATE KNU_USER SET name = '" + name + "', studentid = " + sid + ", department = '" + major + "' Where userid = '" + user_id + "'";
	
	try {
		int res = stmt.executeUpdate(sql);
	} catch (SQLException e) {
		System.out.println("sql error = " + e.getMessage());
	}
	
	out.println("<script>alert('변경되었습니다.');</script>");
	out.println("<script>location.href='./myPage.jsp';</script>");
%>

</body>
</html>