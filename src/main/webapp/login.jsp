<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
<%
	if(session.getAttribute("userid") != null || session.getAttribute("managerid") != null){
		//로그인 된 상태로 강제로 접속하는 경우 main으로 redirect
		response.sendRedirect("main.jsp");
	}
%>
    <form name="login" method="post" action="./loginDB.jsp">
        <h1>Login</h1>
        ID<input name="id" required>
        비밀번호<input name="pw" type="password" required>
        <input type="radio" name="login_type" value="user" required>유저
        <input type="radio" name="login_type" value="manager" required>매니저
        <input type="submit" value="로그인">
    </form>
    <a href="./signUp.jsp">회원가입</a>
</body>
</html>