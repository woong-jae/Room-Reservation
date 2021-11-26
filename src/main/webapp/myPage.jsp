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
	
	#reserve-table th button {
		padding: 10px;
		border-bottom: 1px solid lightgray;
		color: #666;
		text-align: center;
	}
	
	.rating {
		background: gray;
		opacity: 0.5;
		color:white;
		cursor:auto;
	}
	.rating:hover {
		background: gray;
	}
</style>
</head>
<body>
<script type="text/javascript">	
	let roomNumber = null;

	function openModal(className) {
		var elems = document.getElementsByClassName(className);
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
				out.println("<td><button class='no-rating'>평가하기</button></td>");
			else 
				out.println("<td><button class='rating' disabled>평가완료</td>");
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
			+ "	WHERE UserId = '" + UserId + "'";
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
				<div><span>이름&nbsp;&nbsp;&nbsp; :&nbsp;&nbsp;&nbsp;</span><%= Name %></div>
				<div><span>학번&nbsp;&nbsp;&nbsp; :&nbsp;&nbsp;&nbsp;</span><%= StudentId %></div>
				<div><span>아이디 :&nbsp;&nbsp;&nbsp;</span><%= UserId %></div>
				<div><span>학과&nbsp;&nbsp;&nbsp; :&nbsp;&nbsp;&nbsp;</span><%= Department %></div>
				<div><button id="pwd-btn" onclick="openModal('modal');">비밀번호 변경</button></div>
				<jsp:include page="./changePwdModal.jsp" />
				<jsp:include page="./ratingWriteModal.jsp" />
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
				sql = "select reserverno, classification, room.maxavailable, timeline.starttime, timeline.endtime, rdate, rateuid, ROW_NUMBER() over(order by rdate desc) num from (select * from reserves left outer join rating on reserveRno = rateRno and reserveuid = rateuid), timeline, room where timelineid = reservetid and timelinerno = reserverno and reserverno = roomnumber and reserveuid = 'bh2980' order by rdate desc, timeline.starttime desc";
				//sql = "select * from (select reserverno, classification, room.maxavailable, timeline.starttime, timeline.endtime, rdate, rateuid, ROW_NUMBER() over(order by rdate desc) num from (select * from reserves left outer join rating on reserveRno = rateRno and reserveuid = rateuid), timeline, room where timelineid = reservetid and timelinerno = reserverno and reserverno = roomnumber and reserveuid = 'bh2980' order by rdate desc, timeline.starttime desc) where num between 1 and 4";
				try{
					rs = stmt.executeQuery(sql);
					//rs.last();
					//int rowCount = rs.getRow()-1;
					//rs.beforeFirst();
					//int Maxpage = (int)(Math.ceil((float)rowCount/4));
					//System.out.println(Maxpage);
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
						RatingId = rs.getString(7);
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
					//out.println("<tr><td colspan='6'>");
					//for(int i=1; i<=Maxpage; i++){
					//	out.println(i);
					//}
					out.println("</td></tr>");
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
<script>
	var cols = document.querySelectorAll(".no-rating");
	[].forEach.call(cols, function(col){
	  col.addEventListener("click" , doRating , false );
	});
	  
	function doRating(e){
		informantion = e.target.parentNode.parentNode;
		
		const roomNo = document.getElementById("roomNo");
		const startTime = document.getElementById("startTime");
		const endTime = document.getElementById("endTime");
		
		roomNo.value = informantion.cells[0].childNodes[0].nodeValue.split('(')[0];
		startTime.value = informantion.cells[2].childNodes[0].nodeValue;
		endTime.value = informantion.cells[3].childNodes[0].nodeValue;
		openModal('ratingmodal');
	}
</script>
</body>
</html>