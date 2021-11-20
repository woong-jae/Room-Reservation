<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<style type="text/css">
	#report-wrapper {
		display: flex;
		flex-direction: column;
	    align-items: center;
	    margin-top: 30px;
	    min-height: 340px;
	}
	#report-table {
		border-bottom: 1px solid lightgray;
		border-top: 1px solid;
		border-collapse: collapse;
	    border-spacing: 0;
	}
	#report-table th, #report-table td {
		padding: 10px;
		border-bottom: 1px solid lightgray;
		color: #666;
	}
	.report-title {
		cursor: pointer;
		text-decoration: none;
		color: #666;
	}
	.report-title:hover {
		color: black;
	}
</style>

<%@ include file="./connectDB.jsp" %>
<div id="report-wrapper">
	<table id="report-table">
		<colgroup>
			<col width="70px">
			<col width="600px">
			<col width="160px">
			<col width="160px">
		</colgroup>
		<thead>
			<tr>
				<th colspan="1">번호</th>
				<th colspan="1">제목</th>
				<th colspan="1">등록일</th>
				<th colspan="1">작성자</th>
			</tr>
		</thead>
		<tbody>
		<%
			request.setCharacterEncoding("UTF-8");
			String sql = "";
			String keyword = request.getParameter("keyword");
			if (keyword == null || keyword == "")
				sql = "SELECT ReportId, RTitle, RTime, ReportUid FROM REPORT ORDER BY RTime DESC";
			else {
				sql = "SELECT ReportId, RTitle, RTime, ReportUid FROM REPORT " 
					+ "WHERE RContent LIKE '%" + keyword + "%' OR RTitle LIKE '%" + keyword 
					+ "%' OR ReportUid LIKE '%" + keyword + "%' ORDER BY RTime DESC";
			}
			try{
				rs = stmt.executeQuery(sql);
				int count = 0;
				while(rs.next()){
					count += 1;
					out.println("<tr class='report-item'>");
					for(int i=1;i<=4;i++) {
						if (i == 2) 
							out.println("<td><a class='report-title' href='./reportContent.jsp?ReportId="
								+ rs.getInt(1) + "'>"+rs.getString(2)+"</a></td>");
						else out.println("<td>"+rs.getString(i)+"</td>");
					}
					out.println(" </tr>");
				}
				if (count ==0) {
					out.println("<tr><td colspan='4'>");
					out.println("<div style='text-align: center;'>등록된 내용이 없습니다.</div>");
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
</body>
</html>