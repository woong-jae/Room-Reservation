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
  background-color: white;
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.2s ease-out;
}

.button-label {
	padding: 0 10px;
	font-size: 1.3rem;
}

.button-label:not(:last-child) {
	border-right: solid 1px;
}
</style>
</head>
<body>
<%@ include file="./navbar.jsp" %>
<%@ include file="./connectDB.jsp" %>
<div class="room-container">
	<% 
		class Room {
			public int roomNo;
        	public String classification;
        	public int maxAvail;
        	
        	public Room(int roomNo, String classification, int maxAvail) {
        		this.roomNo = roomNo;
        		this.classification = classification;
        		this.maxAvail = maxAvail;
        	}
		}
		
		Date today = new Date();
		ArrayList<Room> rooms = new ArrayList<Room>();
		
		// Room 정보 가져오기
		String query = "SELECT * FROM ROOM";
		try{
			rs = stmt.executeQuery(query);
			while(rs.next()){
				rooms.add(new Room(rs.getInt(1), rs.getString(2), rs.getInt(3)));
			}
		} catch (SQLException e) {
			System.err.println("sql error = " + e.getMessage());
		}
		
		// Room마다 타임라인 정보 들고오기
		for(int i = 0; i < rooms.size(); i++) {
			out.println("<button class=\"accordion\">");
			out.println("<div class=\"button-label\">" + rooms.get(i).roomNo + "</div>");
			out.println("<div class=\"button-label\">" + rooms.get(i).classification + "</div>");
			out.println("</button>");
			
			query = "SELECT * FROM TIMELINE WHERE TimelineRno=" + rooms.get(i).roomNo;
			try{
				rs = stmt.executeQuery(query);
				int count = 0;
				out.println("<div class=\"panel\">");
				while(rs.next()){
					count++;
					out.println("<p>" + rs.getInt(3) + " ~ " + rs.getInt(4) + "</p>");
				}
				if (count == 0) {
					out.println("<p>예약 가능한 시간대가 없습니다</p>");
				}
				out.println("</div>");
			} catch (SQLException e) {
				System.err.println("sql error = " + e.getMessage());
			}
		}
		
		stmt.close();
		rs.close();
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