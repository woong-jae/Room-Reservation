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
				out.println("<script>alert('ID 또는 비밀번호가 일치하지 않습니다.');</script>");
				out.println("<script>location.href='./login.jsp';</script>");
				try {
					rs.close();
					stmt.close();
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
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
				out.println("<script>alert('ID 또는 비밀번호가 일치하지 않습니다.');</script>");
				out.println("<script>location.href='./login.jsp';</script>");
				try {
					rs.close();
					stmt.close();
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				return;
			}
		} catch (SQLException e) {
			System.out.println("sql error = " + e.getMessage());
			//**에러처리
		}
		//manager 세션 설정
		session.setAttribute("managerid", id);
	}
	
	try {
		rs.close();
		stmt.close();
		conn.close();
	} catch (SQLException e) {
		e.printStackTrace();
	}
	response.sendRedirect("./");
%>

</body>
</html>