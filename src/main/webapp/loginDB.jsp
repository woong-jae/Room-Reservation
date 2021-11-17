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
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	String login_type = request.getParameter("login_type");
		
	String sql = "";
	
	//세션 받아옴
	session = request.getSession();

	//user로 로그인했다면
	if(login_type.equals("user")){
		sql = "Select userid from KNU_USER WHERE userid='" + id + "' and password='" + pw + "'";

		try {
			rs = stmt.executeQuery(sql);
			if (rs.next() == false) {//일치하는 유저가 없다면
				out.print("ID or password does not match.");
				//**에러처리
				response.sendRedirect("main.jsp");
				return;
			}
		} catch (SQLException e) {
			out.print("sql error = " + e.getMessage());
			//**에러처리
		}
		
		//user 세션 설정
		session.setAttribute("userid", id);
	}else{
		sql = "Select ManagerId from MANAGER WHERE ManagerId='" + id + "' and MPassword='" + pw + "'";

		try {
			rs = stmt.executeQuery(sql);
			if (rs.next() == false) {//일치하는 매니저가 없다면
				System.out.println("ID or password does not match.");
				//**에러처리
				response.sendRedirect("main.jsp");
				return;
			}
		} catch (SQLException e) {
			System.out.println("sql error = " + e.getMessage());
			//**에러처리
		}
		//manager 세션 설정
		session.setAttribute("managerid", id);
	}
	
	//stmt(rs), conn 종료
	try {
		stmt.close();
		conn.close();
	} catch (SQLException e) {
		e.printStackTrace();
	}
	
	//main.jsp로 이동
	response.sendRedirect("main.jsp");
%>

</body>
</html>