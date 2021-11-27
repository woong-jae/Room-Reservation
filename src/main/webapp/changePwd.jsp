<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%@ include file="./connectDB.jsp" %>
<%
	if(session.getAttribute("userid") != null) { 
		String sql = "";
		String UserId = session.getAttribute("userid").toString();
		String Password = request.getParameter("Password");
		if (Password != null) {
			try {
				sql = "UPDATE KNU_USER SET Password = '" + Password + "' WHERE UserId = '" + UserId + "'";
				stmt.executeUpdate(sql);
				out.println("<script>alert('비밀번호가 변경되었습니다.');</script>");
				out.println("<script>location.href='myPage.jsp';</script>");
			} catch (SQLException ex2) {
				System.err.println("sql error = " + ex2.getMessage());
			}
		}
	}
%>
</body>
</html>