<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="./connectDB.jsp" %>
<%!
	String RoomNumber = "";
%>
<%
	if (request.getParameter("RoomNumber") != null) {
		RoomNumber = request.getParameter("RoomNumber");
	}
	String sql = "";
	
	// room insert	
	String RNumber = request.getParameter("RNumber");
	String Classification = request.getParameter("Classification");
	String MaxAvailable = request.getParameter("MaxAvailable");
	if (request.getParameter("room-insert") != null) {
		if (RNumber != null && Classification != null && MaxAvailable != null) {
			try{
				sql = "SELECT RoomNumber FROM ROOM";
				rs = stmt.executeQuery(sql);
				boolean check = false;
				while(rs.next()) {
					if(RNumber.equals(rs.getString(1))) {
						check = true;
						out.println("<script>window.alert('이미 존재하는 강의실입니다.')</script>");
						out.println("<script>location.href='managerPage.jsp';</script>");
						break;
					}
				}
				if(!check) {
					try {
						sql = "INSERT INTO ROOM VALUES("+RNumber+", '"+Classification+"', "+ MaxAvailable+")";
						stmt.executeUpdate(sql);
						out.println("<script>window.alert('강의실을 추가했습니다.')</script>");
						out.println("<script>location.href='managerPage.jsp';</script>");
					} catch (SQLException ex2) {
						System.err.println("sql error = " + ex2.getMessage());
					}
				}
			} catch (SQLException e) {
				System.err.println("sql error = " + e.getMessage());
			}
			
		}
	}
	
	// room delete
	if (request.getParameter("room-delete") != null) {
		try {
			sql = "DELETE FROM ROOM WHERE RoomNumber = " + RoomNumber;
			stmt.executeUpdate(sql);
			out.println("<script>location.href='managerPage.jsp';</script>");
		} catch (SQLException ex2) {
			System.err.println("sql error = " + ex2.getMessage());
		}
	}
	
	//timeline insert
	String Timeline = request.getParameter("Timeline");
	if (request.getParameter("timeline-insert") != null) {
		if (Timeline != null) {
			String StartTime = Timeline.substring(0, 4);
			String EndTime = Timeline.substring(7, 11);
			try{
				sql = "SELECT STARTTIME FROM TIMELINE WHERE TimelineRno = "+RoomNumber;
				rs = stmt.executeQuery(sql);
				boolean check = false;
				while(rs.next()) {
					if(StartTime.equals(rs.getString(1))) {
						check = true;
						out.println("<script>window.alert('해당 강의실에 이미 존재하는 시간대입니다.')</script>");
						out.println("<script>location.href='managerPage.jsp?RoomNumber';</script>");
						break;
					}
				}
				if(!check) {
					try {
						sql = "SELECT MAX(TimelineId) FROM TIMELINE";
						rs = stmt.executeQuery(sql);
						rs.next();
						sql = "INSERT INTO TIMELINE VALUES("+RoomNumber+", "+rs.getInt(1)+1+", "+StartTime+", "+ EndTime+")";
						stmt.executeUpdate(sql);
						out.println("<script>window.alert('해당 강의실에 시간대를 추가했습니다.')</script>");
						out.println("<script>location.href='managerPage.jsp';</script>");
					} catch (SQLException ex2) {
						System.err.println("sql error = " + ex2.getMessage());
					}
				}
			} catch (SQLException e) {
				System.err.println("sql error = " + e.getMessage());
			}
			
		}
	}
	
	//timeline delete
		String deleteTimeline = request.getParameter("Timeline");
		if (request.getParameter("timeline-delete") != null) {
			if (Timeline != null) {
				String StartTime = deleteTimeline.substring(0, 4);
				String EndTime = deleteTimeline.substring(7, 11);
				try{
					sql = "SELECT STARTTIME FROM TIMELINE WHERE TimelineRno = "+RoomNumber;
					rs = stmt.executeQuery(sql);
					boolean check = false;
					while(rs.next()) {
						if(StartTime.equals(rs.getString(1))) {
							check = true;
							break;
						}
					}
					if(check) {
						try {
							sql = "DELETE FROM TIMELINE WHERE StartTime = " + StartTime;
							stmt.executeUpdate(sql);
							out.println("<script>window.alert('해당 강의실의 시간대를 삭제했습니다.')</script>");
							out.println("<script>location.href='managerPage.jsp';</script>");
						} catch (SQLException ex2) {
							System.err.println("sql error = " + ex2.getMessage());
						}
					} else {
						out.println("<script>window.alert('선택한 시간대가 해당 강의실에 없습니다.')</script>");
						out.println("<script>location.href='managerPage.jsp';</script>");
					}
				} catch (SQLException e) {
					System.err.println("sql error = " + e.getMessage());
				}
				
			}
		}
%>

<!-- insert room modal -->
<div id="room-insert" class="manage-modal room-insert-model">
  <form class="modal-content" id="room-insert-form" method="post" style="width:15%;" onsubmit="return manageCheckForm();">
        <p style="text-align: center;"><span style="font-size: 20pt;">
        	<b><span style="font-size: 14pt;">강의실 추가</span></b></span>
        	<button type="button" class="close-btn" onclick="closeModal('room-insert-model');">X</button>
        </p>
        <div style="text-align: center;margin-bottom: 20px;">
         	<div style="width: 100%;margin: 20px 0;display: flex;">
         		<div>강의실 번호:</div><input type='number' min='100' 
         			style="width: 47%;margin-left: auto;" name="RNumber" id="RNumber">
         	</div>
         	<div style="width: 100%;margin: 20px 0;display: flex;">
         		<div>강의실 분류:</div>
         		<select style="width: 50%;margin-left: auto;" name="Classification" id="Classification">
         			<option value="Large" selected>Large</option>
					<option value="Normal">Normal</option>
					<option value="Lab">Lab</option>
         		</select>
         	</div>
         	<div style="width: 100%;margin: 20px 0;display: flex;">
         		<div>허용  인원:</div><input type='number' min='0'
         			style="width: 47%;margin-left: auto;" name="MaxAvailable" id="MaxAvailable">
         	</div>
        </div>
        <button class="submit-btn" type="submit">
            <span class="pop_bt" style="font-size: 13pt;" >
                 추가
            </span>
        </button>
  </form>
</div>

<!-- delete room modal -->
<div id="room-delete" class="manage-modal room-delete-model">
  <form class="modal-content" id="room-delete-form" method="post">
        <p style="text-align: center;"><span style="font-size: 20pt;">
        	<b><span style="font-size: 14pt;">해당 강의실을 정말로 삭제하시겠습니까?</span></b></span>
        	<button type="button" class="close-btn" onclick="closeModal('room-delete-model');">X</button>
        </p>
        <div style="text-align: center;margin-bottom: 20px;">
         	삭제한 데이터는 복구할 수 없습니다.
        </div>
        <button class="submit-btn" type="submit">
            <span class="pop_bt" style="font-size: 13pt;" >
                 삭제
            </span>
        </button>
  </form>
</div>

<!-- insert timeline modal -->
<div id="timeline-insert" class="manage-modal timeline-insert-modal">
  <form class="modal-content" id="timeline-insert-form" method="post" style="width:15%;">
        <p style="text-align: center;"><span style="font-size: 20pt;">
        	<b><span style="font-size: 14pt;">시간대 추가</span></b></span>
        	<button type="button" class="close-btn" onclick="closeModal('timeline-insert-modal');">X</button>
        </p>
        <div style="text-align: center;margin-bottom: 20px;">
        	<div style="width: 100%;margin: 20px 0;display: flex;">
         		<select style="width: 100%;margin-left: auto;" name="Timeline" id="Timeline">
         			<option value="1700 - 1800" selected>1700 - 1800</option>
					<option value="1900 - 2000">1900 - 2000</option>
					<option value="2000 - 2100">2000 - 2100</option>
					<option value="2100 - 2200">2100 - 2200</option>
					<option value="2200 - 2300">2200 - 2300</option>
         		</select>
         	</div>
        </div>
        <button class="submit-btn" type="submit">
            <span class="pop_bt" style="font-size: 13pt;" >
                 추가
            </span>
        </button>
  </form>
</div>

<!-- delete timeline modal -->
<div id="timeline-delete" class="manage-modal delete-timeline-modal">
  <form class="modal-content" id="timeline-delete-form" method="post" style="width:15%;">
        <p style="text-align: center;"><span style="font-size: 20pt;">
        	<b><span style="font-size: 14pt;">시간대 삭제</span></b></span>
        	<button type="button" class="close-btn" onclick="closeModal('delete-timeline-modal');">X</button>
        </p>
        <div style="text-align: center;margin-bottom: 20px;">
        	<div style="width: 100%;margin: 20px 0;display: flex;">
         		<select style="width: 100%;margin-left: auto;" name="Timeline" id="Timeline">
         			<option value="1700 - 1800" selected>1700 - 1800</option>
					<option value="1900 - 2000">1900 - 2000</option>
					<option value="2000 - 2100">2000 - 2100</option>
					<option value="2100 - 2200">2100 - 2200</option>
					<option value="2200 - 2300">2200 - 2300</option>
         		</select>
         	</div>
        </div>
        <button class="submit-btn" type="submit">
            <span class="pop_bt" style="font-size: 13pt;" >
                 삭제
            </span>
        </button>
  </form>
</div>


<script type="text/javascript">	
	function openManageModal(id) {
		var RoomNumber = history.state;
		console.log(RoomNumber);
		if(id === 'room-delete' || id === 'timeline-insert' || id === 'timeline-delete') {
			if(RoomNumber == null) window.alert('강의실을 선택해주세요.');
			else {
				document.getElementById(id+"-form").setAttribute('action', 
						"managerPage.jsp?RoomNumber="+RoomNumber+"&"+id+"=yes")
				document.getElementById(id).style.display = 'block';
			}
		} else if(id === 'room-insert') {
			document.getElementById('room-insert-form').setAttribute('action', 
					"managerPage.jsp?RoomNumber="+RoomNumber+"&"+id+"=yes")
			document.getElementById(id).style.display = 'block';
		}
		
	}

	function manageCheckForm(){
		var RNumber = document.getElementById('RNumber');
	    if(RNumber.value == '') {
	        window.alert("강의실 번호를 입력하세요");
	        return false;
	    }
	    var Classification = document.getElementById('Classification');
	    if(Classification.value == '') {
	        window.alert("강의실 분류를 입력하세요");
	        return false;
	    }
	    var MaxAvailable = document.getElementById('MaxAvailable');
	    if(MaxAvailable.value == '') {
	        window.alert("허용 인원을 입력하세요");
	        return false;
	    }
	}
</script>	