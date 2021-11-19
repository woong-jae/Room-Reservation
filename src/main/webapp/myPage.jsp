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
	#mypage {
		display: flex;	
		justify-content: center;
	}
	#mypage-wrapper {
		display: flex;	
		justify-content: space-around;
		width: 80%;
	}
	.mypage-contents {
		margin: 70px 0 30px 0;
	    padding: 20px;
	    height: 300px;
	    border: 1px solid lightgray;
	}
	#mypage-userInfo {
		justify-content: space-evenly;
		width: 300px;
		display: flex;
    	flex-direction: column;
    	height: 100%;
    	border-top: 1px solid;
	}
	#mypage-roomInfo {
		width: 750px;
		overflow-y: auto;
	}
	span {
		font-weight: bold;
		margin-right: 30px;
	}
	#reserve-table {
		border-bottom: 1px solid lightgray;
		border-top: 1px solid;
		border-collapse: collapse;
	    border-spacing: 0;
	}
	#reserve-table th, #reserve-table td {
		padding: 10px;
		border-bottom: 1px solid lightgray;
		color: #666;
		text-align: center;
	}
</style>
</head>
<body>
<%@ include file="./connectDB.jsp" %>
<%!
	String Name = "";
	String StudentId = "";
	String UserId = "";
	String Department = "";
	
	String RoomNum = "";
	String RoomClassification = "";
	String RoomMaxAvailable = "";
	String StartTime = "";
	String EndTime = "";
	String Date = "";
%>
<%
	if(session.getAttribute("userid") == null && session.getAttribute("managerid") == null){
		out.println("<script>alert('로그인을 하십시오.');</script>");
		out.println("<script>location.href='main.jsp';</script>");
	}
	else UserId = session.getAttribute("userid").toString();
%>
<%
	String sql = "SELECT Name, StudentId, Department FROM KNU_USER WHERE UserId = '" + UserId + "'";
	try{
		rs = stmt.executeQuery(sql);
		rs.next();
		Name =  rs.getString(1);
		StudentId =  rs.getString(2);
		Department =  rs.getString(3);
		rs.close();
	} catch (SQLException e) {
		System.err.println("sql error = " + e.getMessage());
	}
%>
<%@ include file="./navbar.jsp" %>
<div id="title">마이페이지</div>
<div id="mypage">
	<div id="mypage-wrapper">
		<div class="mypage-contents">
			<h3 style="text-align:center;margin-top: 0;">내 정보</h3>
			<div id="mypage-userInfo">
				<div><span>이름&nbsp;&nbsp;&nbsp; :</span><%= Name %></div>
				<div><span>학번&nbsp;&nbsp;&nbsp; :</span><%= StudentId %></div>
				<div><span>아이디 :</span><%= UserId %></div>
				<div><span>학과&nbsp;&nbsp;&nbsp; :</span><%= Department %></div>
			</div>
		</div>
		<div id="mypage-roomInfo" class="mypage-contents">
			<h3 style="text-align:center;margin-top: 0;">강의실 예약내역</h3>
			<table id="reserve-table">
				<colgroup>
					<col width="200px">
					<col width="200px">
					<col width="200px">
					<col width="200px">
					<col width="200px">
				</colgroup>
				<thead>
					<tr>
						<th colspan="1">강의실</th>
						<th colspan="1">허용 가능 인원</th>
						<th colspan="1">이용 시작 시간</th>
						<th colspan="1">이용 종료 시간</th>
						<th colspan="1">예약 날짜</th>
					</tr>
				</thead>
				<tbody>
			<%
				sql = "SELECT ReserveRno, Classification, MaxAvailable, StartTime, EndTime, Rdate "
					+ "FROM RESERVES, TIMELINE, ROOM "
					+ "WHERE ReserveUid = '" + UserId + "' AND ReserveTid = TimeLineId AND ReserveRno = RoomNumber "
					+ "ORDER BY Rdate";
				try{
					rs = stmt.executeQuery(sql);
					int count = 0;
					while(rs.next()){
						count += 1;
						out.println("<tr class='reserve-item'>");
						out.println("<td>"+rs.getString(1)+"("+rs.getString(2)+")</td>");
						for(int i=3;i<=6;i++) {
							out.println("<td>"+rs.getString(i)+"</td>");
						}
						out.println(" </tr>");
					}
					if (count ==0) {
						out.println("<tr><td colspan='5'>");
						out.println("<div style='text-align: center;'>예약 내역이 없습니다.</div>");
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
	</div>
</div>
<%@ include file="./footer.jsp" %>
</body>
</html>