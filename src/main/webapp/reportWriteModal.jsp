<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page language="java" import="java.time.*, java.time.format.*" %>
<link rel="stylesheet" href="./style/modalStyle.css">

<script type="text/javascript">

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

<div id="myModal" class="modal">
  <form id="modal-content" method="post" action="./report.jsp" onsubmit="return checkForm();">
        <p style="text-align: center;"><span style="font-size: 20pt;">
        	<b><span style="font-size: 14pt;margin-left: 50px;">문의하기</span></b></span>
        	<button type="button" id="close-btn" onclick="closeModal();">X</button>
        </p>
        <div style="display:flex;flex-direction:column;align-items: baseline;">
         	<div style="width: 100%;margin-bottom: 20px;display: flex;align-items: center;">
         		제목: <input type="text" style="width: 89%;margin-left: 6px;" name="RTitle" id="RTitle">
         	</div>
         	내용:
         	<div style="width: 100%;margin-bottom: 20px;">
         		<textarea style="width: 100%;height: 150px;resize: none;" name="RContent" id="RContent"></textarea>
         	</div>
        </div>
        <button id="submit-btn" type="submit">
            <span class="pop_bt" style="font-size: 13pt;" >
                 제출
            </span>
        </button>
  </form>
</div>

