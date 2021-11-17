<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="./style/globalStyle.css">
<style type="text/css">
#title {
	display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.5em;
    font-weight: 500;
	height: 130px;
	background: #f0f0f0;
}
#notice-wrapper {
	display: flex;
	flex-direction: column;
    align-items: center;
    margin-top: 30px;
}
table {
	border-bottom: 1px solid lightgray;
	border-top: 1px solid;
	border-collapse: collapse;
    border-spacing: 0;
}
th, td {
	padding: 15px;
	border-bottom: 1px solid lightgray;
	color: #666;
}
.notice-title {
	cursor: pointer;
	text-decoration: none;
	color: #666;
}
.notice-title:hover {
	color: black;
}
#search {
	margin: 20px;
	display: flex;
	width: 300px;
    justify-content: space-around;
}
#search input {
	width: 200px;
    height: 30px;
    padding: 7px;
    border-radius: 4px;
}
#search button {
	width: 50px;
	height: 48px;
	padding: 7px;
	background: #464646;
	color: white;
	cursor: pointer;
	border-radious: 4px;
	border-radius: 4px;
    border: none;
}
#search button:hover {
	background: #353535;
}
</style>
</head>
<body>
<%@ include file="./connectDB.jsp" %>
<%@ include file="./navbar.jsp" %>
<div id="title">공지사항</div>
<div id="notice-wrapper">
	<form method="post" action="./notice.jsp" id="search">
		<input name="keyword" type="text" placeholder="검색어를 입력해주세요">
		<button type="submit">검색</button>
	</form>
	<table>
		<colgroup>
			<col width="70px">
			<col width="600px">
			<col width="160px">
			<col width="160px">
		</colgroup>
		<thead>
			<tr>
				<th colspan="1">번호</th>
				<th colspan="1">제목</th>
				<th colspan="1">등록일</th>
				<th colspan="1">작성자</th>
			</tr>
		</thead>
		<tbody>
		<%
			request.setCharacterEncoding("UTF-8");
			String sql = "";
			String keyword = request.getParameter("keyword");
			if (keyword == null || keyword == "")
				sql = "SELECT NoticeId, NTitle, WrittenTime, NoticeMid FROM NOTICE ORDER BY WrittenTime DESC";
			else {
				sql = "SELECT NoticeId, NTitle, WrittenTime, NoticeMid FROM NOTICE " 
					+ "WHERE NContent LIKE '%" + keyword + "%' OR NTitle LIKE '%" + keyword + "%' ORDER BY WrittenTime DESC";
			}
			try{
				rs = stmt.executeQuery(sql);
				int count = 0;
				while(rs.next()){
					count += 1;
					out.println("<tr class='notice-item'>");
					for(int i=1;i<=4;i++) {
						if (i == 2) 
							out.println("<td><a class='notice-title' href='./noticeContent.jsp?NoticeId="
								+ rs.getInt(1) + "'>"+rs.getString(2)+"</a></td>");
						else out.println("<td>"+rs.getString(i)+"</td>");
					}
					out.println(" </tr>");
				}
				if (count ==0) {
					out.println("<tr><td colspan='4'>");
					out.println("<div style='text-align: center;'>등록된 내용이 없습니다.</div>");
					out.println("</td></tr>");
				}
				rs.close();
			} catch (SQLException e) {
				System.err.println("sql error = " + e.getMessage());
			}
		%>
		</tbody>
	</table>
</div>
</body>
</html>