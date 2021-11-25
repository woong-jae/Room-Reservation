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
	display: flex;
	justify-content: center;
	padding: 18px;
	width: 100%;
	border: none;
	outline: none;
	transition: 0.4s;
}

.active, .accordion:hover {
	color: whitesmoke;
	background-color: rgb(193, 55, 54);
}

.panel {
	background-color: white;
	max-height: 0;
	overflow: hidden;
	transition: max-height 0.2s ease-out;
}

.panel-item {
	font-size: 1.2rem;
	display: flex;
	justify-content: space-evenly;
	width: 100%;
	border: none;
	outline: none;
	cursor: pointer;
	background-color: #fff;
}
button.panel-item:hover {
	background-color: bisque;
}

.panel-item:not(:last-child) {
	border-bottom: solid 1px;
}

.panel-item-navail {
	font-size: 1.2rem;
	text-align: center;
}

.button-label {
	width: 200px;
	font-size: 1.3rem;
}

.modal {
  display: none; /* Hidden by default */
  position: fixed; /* Stay in place */
  z-index: 1; /* Sit on top */
  left: 0;
  top: 0;
  width: 100%; /* Full width */
  height: 100%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
  background-color: rgb(0,0,0); /* Fallback color */
  background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}

/* Modal Content/Box */
.modal-content {
  background-color: #fefefe;
  margin: 15% auto; /* 15% from the top and centered */
  padding: 20px;
  border: 1px solid #888;
  width: 700px; /* Could be more or less, depending on screen size */
}
.modal-qst {
	display: flex;
	justify-content: center;
	align-items: center;
}
.modal-qst p {
	margin-right: 10px;
}
.modal-btn {
	margin-left: 8px;
    width: 50px;
    font-size: 1.1em;
}
/* The Close Button */
span.close {
  color: #aaa;
  float: right;
  font-size: 28px;
  font-weight: bold;
}

span.close:hover,
span.close:focus {
  color: black;
  text-decoration: none;
  cursor: pointer;
}
</style>
<script>
	window.onpageshow = function(event) {
    	if ( event.persisted || (window.performance && window.performance.navigation.type == 2)) {
			window.location.reload();
    	}
	}
</script>
</head>
<body>
<%@ include file="./navbar.jsp" %>
<%@ include file="./connectDB.jsp" %>
<%!
	String uid;
%>
<div class="room-container">
	<% 
		if(session.getAttribute("userid") != null)
			uid = session.getAttribute("userid").toString();

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
			out.println("<button class=\"accordion\" id='" + rooms.get(i).roomNo + "'>");
			out.println("<div class=\"button-label\">" + rooms.get(i).roomNo + "호</div>");
			out.println("<div class=\"button-label\">");
			switch (rooms.get(i).classification) {
				case "Large": out.println("대형 강의실");
					break;
				case "Normal": out.println("강의실");
					break;
				case "Lab": out.println("실습실");
					break;
				default: out.println("Unknown");
			}
			out.println("</div>");
			out.println("</button>");
			
			out.println("<div class=\"panel\">");
			if (rooms.get(i).timelines.size() == 0) {
				out.println("<p class='panel-item-navail'>예약 가능한 시간대가 없습니다.</p>");
			}
			else {
				for (int j = 0; j < rooms.get(i).timelines.size(); j++) {
					out.println("<button class=\"panel-item\" value='" + rooms.get(i).roomNo + " " + rooms.get(i).timelines.get(j).timelineId + "'><p>" + rooms.get(i).timelines.get(j).start + " ~ " + rooms.get(i).timelines.get(j).end + "</p><p>예약 현황: " + rooms.get(i).timelines.get(j).currentReserved + "/" + rooms.get(i).maxAvail + "</p></button>");
				}	
			}
			out.println("</div>");	
		}
	%>
</div>

<!-- Modal -->
<div id="myModal" class="modal">
  <div class="modal-content">
    <span class="close">&times;</span>
    <div class="modal-qst">
    	<p>이 시간대에 예약하시겠습니까?</p>
    	<button class="modal-btn" onClick="reserve()">예약</button>
		<button class="modal-btn close">취소</button>
    </div>
  </div>

</div>

<%@ include file="./footer.jsp" %>
<script type="text/javascript">
	var input;
	/* 아코디언 */
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
	
	/* 모달 */
	var modal = document.getElementById("myModal");
	var span = document.getElementsByClassName("close");
	var btn = document.getElementsByClassName("panel-item");
	
	for (i = 0; i < btn.length; i++) {
		btn[i].addEventListener("click", function(elem) {
			if (<%= uid != null ? "'" + uid + "'" : null %>) {
				modal.style.display = "block";
				var content = document.getElementsByClassName("modal-content");
				/* content[0].getElementsByTagName("p")[0].innerText = "이 시간대에 예약하시겠습니까?"; */
				if (elem.target.className) {
					input = elem.target.value;
				} else {
					input = elem.target.parentNode.value;
				}
			} else {
				window.alert("로그인을 하십시오.");
				location.href="login.jsp";
			}
		})
	}
	
	for (i = 0; i < span.length; i++) {
		span[i].onclick = function() {
			modal.style.display = "none";
		}	
	}

	window.onclick = function(event) {
		if (event.target == modal) {
			modal.style.display = "none";
		}
	}
	
	function reserve() {
		var form = document.createElement('form');
		var inputs;
		inputs = document.createElement('input');
		inputs.setAttribute('type', 'text');
		inputs.setAttribute('name', 'input');
		inputs.setAttribute('value', input);
		form.appendChild(inputs);
		
		form.setAttribute('method', 'post');
		form.setAttribute('action', "./reservation.jsp");
		document.body.appendChild(form);
		form.submit();
	}
</script>
</body>
</html>