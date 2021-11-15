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
    justify-content: center;
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
}
</style>
</head>
<body>
<%@ include file="./navbar.jsp" %>
<div id="title">공지사항</div>
<div id="notice-wrapper">
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
			<tr>
				<td colspan="4">
					<div style="text-align: center;">등록된 내용이 없습니다.</div>
				</td>
			</tr>
		</tbody>
	</table>
</div>
</body>
</html>