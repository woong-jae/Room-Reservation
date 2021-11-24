<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page language="java" import="java.time.*, java.time.format.*" %>
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
		justify-content: space-around;
		width: 300px;
		display: flex;
    	flex-direction: column;
    	height: 85%;
    	border-top: 1px solid;
	}
	#mypage-roomInfo {
		width: auto;
		overflow-y: auto;
	}
	span {
		font-weight: bold;
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
	.no-rating {
		background: gray;
		opacity: 0.3;
	}
	.no-rating:hover {
		cursor: auto;
		background: gray;
	}
</style>
</head>
<body>
<script type="text/javascript">	
	function openModal() {
		var elems = document.getElementsByClassName("modal");
		for (var i=0;i<elems.length;i+=1){
			elems[i].style.display = 'block';
		}
	}
</script>
<%@ include file="./connectDB.jsp" %>
<%!
	String Name = "";
	String StudentId = "";
	String UserId = "";
	String ManagerId = "";
	String Department = "";
	String RatingId = "";
	
	String RoomNum = "";
	String RoomClassification = "";
	String RoomMaxAvailable = "";
	String StartTime = "";
	String EndTime = "";
	String Date = "";
	
	public void printRatingBtn(javax.servlet.jsp.JspWriter out) throws ServletException {
		try {
			if (RatingId == null)
				out.println("<td><button class='no-rating' disabled>평가완료</button></td>");
			else 
				out.println("<td><button class='rating'></td>");
		} catch (Exception e){
			System.err.println("error = " + e.getMessage());
		}
	}
%>
<%
	if(session.getAttribute("userid") != null)
		UserId = session.getAttribute("userid").toString();
	else if(session.getAttribute("managerid") != null) {
		out.println("<script>alert('관리자는 이용하실 수 없습니다.');</script>");
		out.println("<script>location.href='main.jsp';</script>");	
	}
	else {
		out.println("<script>alert('로그인을 하십시오.');</script>");
		out.println("<script>location.href='main.jsp';</script>");
	}
%>
<%
	String sql = "SELECT Name, StudentId, Department, RatingId" 
			+ " FROM (SELECT * FROM KNU_USER LEFT OUTER JOIN RATING ON UserId = RateUid)"
			+ "	WHERE USerId = 'puKcxQ'";
	try{
		rs = stmt.executeQuery(sql);
		rs.next();
		Name =  rs.getString(1);
		StudentId =  rs.getString(2);
		Department =  rs.getString(3);
		RatingId = rs.getString(4);
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
				<div><span>이름&nbsp;&nbsp;&nbsp; :&nbsp;&nbsp;&nbsp;</span><%= Name %></div>
				<div><span>학번&nbsp;&nbsp;&nbsp; :&nbsp;&nbsp;&nbsp;</span><%= StudentId %></div>
				<div><span>아이디 :&nbsp;&nbsp;&nbsp;</span><%= UserId %></div>
				<div><span>학과&nbsp;&nbsp;&nbsp; :&nbsp;&nbsp;&nbsp;</span><%= Department %></div>
				<div><button id="pwd-btn" onclick="openModal();">비밀번호 변경</button></div>
				<jsp:include page="./changePwdModal.jsp" />
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
					<col width="120px">
				</colgroup>
				<thead>
					<tr>
						<th colspan="1">강의실</th>
						<th colspan="1">허용 가능 인원</th>
						<th colspan="1">이용 시작 시간</th>
						<th colspan="1">이용 종료 시간</th>
						<th colspan="1">예약 날짜</th>
						<th colspan="1"></th>
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
						String Rdate = "";
						count += 1;
						out.println("<tr class='reserve-item'>");
						out.println("<td>"+rs.getString(1)+"("+rs.getString(2)+")</td>");
						for(int i=3;i<=6;i++) {
							if(i == 6) {
								Rdate = rs.getString(i).substring(0, 10);
								out.println("<td>"+Rdate+"</td>");
							}
							else out.println("<td>"+rs.getString(i)+"</td>");
						}

						// 예약 날짜가 지난 것만 평가할 수 있게 함
						LocalDateTime now = LocalDateTime.now();
						String date = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
						if (Integer.valueOf(date.substring(0, 4)) - Integer.valueOf(Rdate.substring(0, 4)) > 0)
							printRatingBtn(out);
						else if (Integer.valueOf(date.substring(0, 4)) - Integer.valueOf(Rdate.substring(0, 4)) == 0)
							if (Integer.valueOf(date.substring(5, 7)) - Integer.valueOf(Rdate.substring(5, 7)) > 0)
								printRatingBtn(out);
							else if (Integer.valueOf(date.substring(5, 7)) - Integer.valueOf(Rdate.substring(5, 7)) == 0)
								if (Integer.valueOf(date.substring(8, 10)) - Integer.valueOf(Rdate.substring(8, 10)) > 0)
									printRatingBtn(out);
								else
									out.println("<td></td>");
							else
								out.println("<td></td>");
						else
							out.println("<td></td>");
						
						out.println(" </tr>");
					}
					if (count ==0) {
						out.println("<tr><td colspan='6'>");
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