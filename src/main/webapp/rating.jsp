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
	String RoomNumber = request.getParameter("roomNo");
	String rate = request.getParameter("starRate");
	String comment = request.getParameter("comment");
	
	String sql = "SELECT ratingid from rating";

	int rateid = 0;

	try {
		rs = stmt.executeQuery(sql);
		while (rs.next()) {
			rateid = rs.getInt(1) + 1;
		}
	} catch (SQLException e) {
		System.out.println("sql error = " + e.getMessage());
		System.exit(1);
	}

	sql = "INSERT INTO RATING VALUES (" + rateid + ", '" + user_id + "', " + RoomNumber + ", " + rate + ", '" + comment + "')";
	
	System.out.println(sql);
	
	try {
		int res = stmt.executeUpdate(sql);
	} catch (SQLException e) {
		System.out.println("sql error = " + e.getMessage());
	}

	System.out.println(sql);
	response.sendRedirect("main.jsp");
%>

</body>
</html>