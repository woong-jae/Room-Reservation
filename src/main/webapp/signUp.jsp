<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h1>회원가입</h1>
    <form name="signup" method="post" action="./signUpDB.jsp">
        성함<input name="name" required>
        ID<input name="id" required>
        <%
        	//id 중복체크 버튼 및 구현
        %>
        비밀번호<input name="pw" type="password" required>
        비밀번호 확인<input name="pw_check" type="password" required>
        <%
        	//input password의 tag를 가져와서 일치하는지 확인 후 옆에 글씨 추가
        	//비밀번호 특수기호 체크
        %>
        전공<select name="major" required>
            <option value="컴퓨터공학부" selected>컴퓨터공학부</option>
            <option value="전기공학과">전기공학과</option>
            <option value="전자공학부">전자공학부</option>
        </select>
        학번<input name="sid" required>
        <input type="submit" value="회원가입">
    </form>
</body>
</html>