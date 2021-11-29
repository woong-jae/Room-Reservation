<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page language="java" import="java.text.*, java.sql.*, java.util.Date, java.time.LocalTime, java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ include file="./connectDB.jsp" %>
<%	
	String uid, sql;
	String[] rq = request.getParameter("input").split(" ");
	Date today = new Date();
	SimpleDateFormat toDate = new SimpleDateFormat("yyyy-MM-dd");
	LocalTime curTime = LocalTime.now();
	DateTimeFormatter timeFormat = DateTimeFormatter.ofPattern("HHmm");
	int currentReserved, maxAvail = 0;
	
	// 로그인 했는지 확인
	if(session.getAttribute("userid") != null) {
		uid = session.getAttribute("userid").toString();
		
		// 1. 방의 최대 인원 가져오기 
		sql = "SELECT MaxAvailable FROM ROOM WHERE RoomNumber = " + rq[0];
		try {
			rs = stmt.executeQuery(sql);
			if (rs.next()) {
				maxAvail = rs.getInt(1);
			}
			sql = "SELECT StartTime FROM TIMELINE WHERE TimelineId = " + rq[1];
			rs = stmt.executeQuery(sql);
			if (rs.next()) {
				int starttime = rs.getInt(1);
				if (Integer.parseInt(curTime.format(timeFormat)) >= starttime) {
					out.println("<script>alert('예약할 수 있는 기간이 지났습니다...');</script>");
					out.println("<script>location.href='rooms.jsp';</script>");
				}
			}
		} catch (SQLException e) {
			System.err.println("sql error = " + e.getMessage());
			out.println("<script>alert('예약에 실패했습니다... (SQL Error)');</script>");
			out.println("<script>location.href='rooms.jsp';</script>");
		}
		
		// Serializble Transaction Isolation
		sql = "LOCK TABLE RESERVES IN EXCLUSIVE MODE";
		try {
			conn.setAutoCommit(false);
			stmt.executeQuery(sql);
		} catch (SQLException e) {
			out.println("<script>alert('예약에 실패했습니다... (Lock Error))');</script>");
			out.println("<script>location.href='rooms.jsp';</script>");
		}
		
		// 2. 현재 예약인원 가져오기
		try {
			sql = "SELECT COUNT(*) FROM RESERVES WHERE ReserveTid = " + rq[1] + " AND Rdate = TO_DATE('" + toDate.format(today) + "', 'yyyy-mm-dd')";
			rs = stmt.executeQuery(sql);
			if (rs.next()) {
				currentReserved = rs.getInt(1);
				// 3. 현재 예약인원이 방의 허용가능한 최대 인원보다 작으면 예약
				if (currentReserved < maxAvail) {
					sql = "INSERT INTO RESERVES VALUES ('" 
							+ uid + "', " 
							+ rq[0] + ", " 
							+ rq[1] + ", TO_DATE('" + toDate.format(today) + "', 'yyyy-mm-dd'))";
					stmt.executeUpdate(sql);
					conn.commit();
				} else {
					conn.rollback();
					out.println("<script>alert('해당 시간대에 예약이 가득찼습니다!');</script>");
					out.println("<script>location.href='rooms.jsp';</script>");
				}
			} else {
				conn.rollback();
				out.println("<script>alert('예약에 실패했습니다... (SQL Error)');</script>");
				out.println("<script>location.href='rooms.jsp';</script>");
			}
		} catch (SQLException e) {
			conn.rollback();
			out.println("<script>alert('이미 예약하셨습니다...');</script>");
			out.println("<script>location.href='rooms.jsp';</script>");
		}
		
		
		try {
			conn.close();
			stmt.close();
			rs.close();
		} catch (SQLException e) {
			System.err.println("sql error = " + e.getMessage());
		}
		
		// 성공
		out.println("<script>alert('예약되었습니다!');</script>");
		out.println("<script>location.href='myPage.jsp';</script>");
	}
	else {
		out.println("<script>alert('로그인을 하십시오.');</script>");
		out.println("<script>location.href='./';</script>");
	}
%>
</body>
</html>