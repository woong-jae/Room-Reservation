<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="./connectDB.jsp" %>
<style>
	#reserve-cancel {
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
</style>
<script>
	function openReserveCancelModal(ReserveRno, StartTime){
		document.getElementById("reserve-cancel").style.display = 'block';
		document.getElementById("ReserveRno").value = ReserveRno;
		document.getElementById("StartTime").value = StartTime;
	}
	function closeReserveCancelModal(){
		document.getElementById("reserve-cancel").style.display = 'none';
	}
</script>

<%
	String sql = "";
	String ReserveRno = request.getParameter("ReserveRno");
	String StartTime = request.getParameter("StartTime");
	String ReserveTid = "";
	if (ReserveRno != null && StartTime != null) {
		try{
			sql = "SELECT TimelineId FROM TIMELINE"
					+ " WHERE TimelineRno = "+ReserveRno+" AND StartTime = "+StartTime;
			rs = stmt.executeQuery(sql);
			rs.next();
			ReserveTid = rs.getString(1);
			rs.close();
			try {
				sql = "DELETE FROM RESERVES"
					+ " WHERE ReserveRno = "+ReserveRno+" AND ReserveTid = "+ReserveTid;
				stmt.executeUpdate(sql);
			} catch (SQLException ex2) {
				System.err.println("sql error = " + ex2.getMessage());
			}
		} catch (SQLException e) {
			System.err.println("sql error = " + e.getMessage());
		}
	}
%>


<div id="reserve-cancel">
  <form class="modal-content" method="get" action="">
        <p style="text-align: center;"><span style="font-size: 20pt;">
        	<b><span style="font-size: 14pt;">해당 예약을 정말로 취소하시겠습니까?</span></b></span>
        	<button type="button" class="close-btn" onclick="closeReserveCancelModal();">X</button>
        </p>
        <div style="text-align: center;margin-bottom: 20px;">
         	취소한 예약은 복구할 수 없습니다.
        </div>
        <input id="ReserveRno" name="ReserveRno" type="hidden">
        <input id="StartTime" name="StartTime" type="hidden">
        <button class="submit-btn" type="submit">
            <span class="pop_bt" style="font-size: 13pt;" >
                 예약 취소
            </span>
        </button>
  </form>
</div>



