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
	String delCheckPwd = request.getParameter("deleteCheckPwd");

	String sql = "SELECT password from knu_user where userid = '" + user_id + "'";

	try {
		rs = stmt.executeQuery(sql);
		while (rs.next()) {
			String ori_pw = rs.getString(1);
			
			if(!ori_pw.equals(delCheckPwd)){
				out.println("<script>alert('비밀번호가 일치하지 않습니다.');</script>");
				out.println("<script>location.href='./myPage.jsp';</script>");
				try {
					stmt.close();
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				return;
			}
			
			out.println("<script>if(!confirm('정말로 탈퇴하시겠습니까?')){location.href='./myPage.jsp';}</script>");
		}
	} catch (SQLException e) {
		System.out.println("sql error = " + e.getMessage());
		System.exit(1);
	}
	
	if(session.getAttribute("managerid") != null)
		session.removeAttribute("managerid");
	if(session.getAttribute("userid") != null)
		session.removeAttribute("userid");

	sql = "delete from knu_user where userid = '" + user_id + "'";
	
	try {
		int res = stmt.executeUpdate(sql);
	} catch (SQLException e) {
		System.out.println("sql error = " + e.getMessage());
	}
	
	try {
		stmt.close();
		conn.close();
	} catch (SQLException e) {
		e.printStackTrace();
	}
	
	out.println("<script>alert('탈퇴하셨습니다.');</script>");
	out.println("<script>location.href='./';</script>");
%>

</body>
</html>