<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page language="java" import="java.text.*, java.sql.*, java.util.Date, java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="./style/globalStyle.css">
<style>
.room-container {
	max-width: 1000px;
	margin: 0 auto;
}

.accordion {
	background-color: #eee;
	color: #444;
	cursor: pointer;
	width: 100%;
	display: flex;
	justify-content: center;
	padding: 18px;
	border: none;
	outline: none;
	transition: 0.4s;
}

.active, .accordion:hover {
	background-color: #ccc;
}

.panel {
	padding: 0 18px;
	font-size: 1.2rem;
	background-color: white;
	max-height: 0;
	overflow: hidden;
	transition: max-height 0.2s ease-out;
}

.panel-item {
	display: flex;
	justify-content: space-evenly;
}

.button-label {
	width: 200px;
	font-size: 1.3rem;
}

/* .button-label:not(:last-child) {
	border-right: solid 1px;
} */
</style>
</head>
<body>
<%@ include file="./navbar.jsp" %>
<%@ include file="./connectDB.jsp" %>
<div class="room-container">
	<% 
		class Timeline {
			public int timelineId;
			public int start;
			public int end;
			public int currentReserved;
			
			public Timeline(int id, int start, int end) {
				this.timelineId = id;
				this.start = start;
				this.end = end;
				this.currentReserved = 0;
			}
		}
	
		class Room {
			public int roomNo;
        	public String classification;
        	public int maxAvail;
        	public ArrayList<Timeline> timelines;
        	
        	public Room(int roomNo, String classification, int maxAvail) {
        		this.roomNo = roomNo;
        		this.classification = classification;
        		this.maxAvail = maxAvail;
        		this.timelines = new ArrayList<Timeline>();
        	}
		}
		
		ArrayList<Room> rooms = new ArrayList<Room>();
		
		// Room 정보 가져오기
		String query = "SELECT * FROM ROOM";
		try {
			rs = stmt.executeQuery(query);
			while(rs.next()){
				rooms.add(new Room(rs.getInt(1), rs.getString(2), rs.getInt(3)));
			}
		} catch (SQLException e) {
			System.err.println("sql error = " + e.getMessage());
		}
		
		// Room마다 타임라인 정보 들고오기
		for (int i = 0; i < rooms.size(); i++) {
			query = "SELECT * FROM TIMELINE WHERE TimelineRno=" + rooms.get(i).roomNo + "ORDER BY StartTime";
			try {
				rs = stmt.executeQuery(query);
				while(rs.next()){
					rooms.get(i).timelines.add(new Timeline(rs.getInt(2), rs.getInt(3), rs.getInt(4)));
				}
			} catch (SQLException e) {
				System.err.println("sql error = " + e.getMessage());
			}
			
		}
		
		// Timeline마다 몇 명이 예약했는지 들고오기 
		Date today = new Date();
		SimpleDateFormat toDate = new SimpleDateFormat("yyyy-MM-dd");
		for (int i = 0; i < rooms.size(); i++) {
			for (int j = 0; j < rooms.get(i).timelines.size(); j++) {
				query = "SELECT COUNT(*) FROM RESERVES WHERE ReserveTid = " + rooms.get(i).timelines.get(j).timelineId + " AND Rdate = TO_DATE('" + toDate.format(today) + "', 'yyyy-mm-dd')";
				try {
					rs = stmt.executeQuery(query);
					while(rs.next()){
						rooms.get(i).timelines.get(j).currentReserved = rs.getInt(1);
					}
				} catch (SQLException e) {
					System.err.println("sql error = " + e.getMessage());
				}
			}
		}
		
		stmt.close();
		rs.close();
		
		// Display
		for (int i = 0; i < rooms.size(); i++) {
			out.println("<button class=\"accordion\">");
			out.println("<div class=\"button-label\">" + rooms.get(i).roomNo + "호</div>");
			out.println("<div class=\"button-label\">" + rooms.get(i).classification + "</div>");
			out.println("</button>");
			
			out.println("<div class=\"panel\">");
			if (rooms.get(i).timelines.size() == 0) {
				out.println("<div class=\"panel-item\"><p>예약 가능한 시간대가 없습니다</p></div>");
			}
			else {
				for (int j = 0; j < rooms.get(i).timelines.size(); j++) {
					out.println("<div class=\"panel-item\"><p>" + rooms.get(i).timelines.get(j).start + " ~ " + rooms.get(i).timelines.get(j).end + "</p><p>예약 현황: " + rooms.get(i).timelines.get(j).currentReserved + "/" + rooms.get(i).maxAvail + "</p></div>");
				}	
			}
			out.println("</div>");	
		}
	%>
</div>
<%@ include file="./footer.jsp" %>
<script type="text/javascript">
	var acc = document.getElementsByClassName("accordion");
	var i;
	
	for (i = 0; i < acc.length; i++) {
	  acc[i].addEventListener("click", function() {
	    this.classList.toggle("active");
	    var panel = this.nextElementSibling;
	    if (panel.style.maxHeight) {
	      panel.style.maxHeight = null;
	    } else {
	      panel.style.maxHeight = panel.scrollHeight + "px";
	    }
	  });
	}
</script>
</body>
</html>