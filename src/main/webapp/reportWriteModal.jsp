<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page language="java" import="java.time.*, java.time.format.*" %>
<link rel="stylesheet" href="./style/modalStyle.css">

<script type="text/javascript">
	function closeModal(){
		var elems = document.getElementsByClassName("modal");
		for (var i=0;i<elems.length;i+=1){
			elems[i].style.display = 'none';
		}
	}
	function checkForm(){
		var RTitle = document.getElementById('RTitle');
	    if(RTitle.value == '') {
	        window.alert("제목을 입력하세요");
	        return false;
	    }
	    var RContent = document.getElementById('RContent');
	    if(RContent.value == ''){
	    	window.alert('내용을 입력하세요.');
	        return false;
	    }
	    
	    RTitle.value = RTitle.value.replace(/'/g,"''");
	    RContent.value = RContent.value.replace(/'/g,"''");
	}
</script>

<%@ include file="./connectDB.jsp" %>
<%
	if(session.getAttribute("userid") != null) { 
		String sql = "";
		String UserId = session.getAttribute("userid").toString();
		String RTitle = request.getParameter("RTitle");
		String RContent = request.getParameter("RContent");
		int reportId = 0;
	
		if (RTitle != null && RContent != null) {
			try {
				sql = "SELECT MAX(ReportId) FROM REPORT";
				rs = stmt.executeQuery(sql);
				rs.next();
				reportId = rs.getInt(1) + 1;
				rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			// get date
			LocalDateTime now = LocalDateTime.now();
			String date = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
			try {
				sql = "INSERT INTO REPORT VALUES(" + reportId + ", '" + UserId + "', '" 
					+ RTitle + "', '" + RContent + "', TO_DATE('" + date
					+ "', 'YYYY-MM-DD HH24:MI:SS')" + ", null, null, null)";
				stmt.executeUpdate(sql);
				out.println("<script>alert('제출 완료했습니다.');</script>");
				out.println("<script>location.href='report.jsp';</script>");
			} catch (SQLException ex2) {
				System.err.println("sql error = " + ex2.getMessage());
			}
		}
	}
%>

<div class="myModal modal">
  <form class="modal-content" method="post" action="./report.jsp" onsubmit="return checkForm();">
        <p style="text-align: center;"><span style="font-size: 20pt;">
        	<b><span style="font-size: 14pt;margin-left: 50px;">문의하기</span></b></span>
        	<button type="button" class="close-btn" onclick="closeModal('modal');">X</button>
        </p>
        <div style="display:flex;flex-direction:column;align-items: baseline;">
         	<div style="width: 100%;margin-bottom: 20px;display: flex;align-items: flex-end;">
         		<div>제목:</div><input type="text" style="width: 89%;margin-left: auto;" name="RTitle" id="RTitle">
         	</div>
         	<div style="width: 100%;margin-bottom: 5px;text-align: left;">내용:</div>
         	<div style="width: 100%;margin-bottom: 20px;">
         		<textarea style="width: 100%;height: 150px;resize: none;" name="RContent" id="RContent"></textarea>
         	</div>
        </div>
        <button class="submit-btn" type="submit">
            <span class="pop_bt" style="font-size: 13pt;" >
                 제출
            </span>
        </button>
  </form>
</div>

