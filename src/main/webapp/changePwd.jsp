<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="./connectDB.jsp" %>
<%
	String sql = "";
	if(session.getAttribute("userid") != null) { 
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
	} else if (session.getAttribute("managerid") != null) {
		String ManagerId  = session.getAttribute("managerid").toString();
		String MPassword  = request.getParameter("Password");
		if (MPassword != null) {
			try {
				sql = "UPDATE MANAGER SET MPassword = '" + MPassword + "' WHERE ManagerId = '" + ManagerId + "'";
				stmt.executeUpdate(sql);
				out.println("<script>alert('비밀번호가 변경되었습니다.');</script>");
				out.println("<script>location.href='managerPage.jsp';</script>");
			} catch (SQLException ex2) {
				System.err.println("sql error = " + ex2.getMessage());
			}
		}
	}
%>