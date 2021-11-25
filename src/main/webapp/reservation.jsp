<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page language="java" import="java.text.*, java.sql.*, java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ include file="./connectDB.jsp" %>
<%	
	String uid;
	String[] rq = request.getParameter("input").split(" ");
	
	if(session.getAttribute("userid") != null) {
		uid = session.getAttribute("userid").toString();
		Date today = new Date();
		SimpleDateFormat toDate = new SimpleDateFormat("yyyy-MM-dd");
		String sql = "INSERT INTO RESERVES VALUES ('" 
			+ uid + "', " 
			+ rq[0] + ", " 
			+ rq[1] + ", TO_DATE('" + toDate.format(today) + "', 'yyyy-mm-dd'))";
		try {
			stmt.executeUpdate(sql);
			out.println("<script>alert('예약되었습니다!');</script>");
			out.println("<script>location.href='myPage.jsp';</script>");
		} catch (SQLException e) {
			System.err.println("sql error = " + e.getMessage());
			out.println("<script>alert('예약에 실패했습니다...');</script>");
			out.println("<script>location.href='rooms.jsp';</script>");
		}
	}
	else {
		out.println("<script>alert('로그인을 하십시오.');</script>");
		out.println("<script>location.href='main.jsp';</script>");
	}
%>
</body>
</html>