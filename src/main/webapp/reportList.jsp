<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="./connectDB.jsp" %>
<%!  String ReportMid = ""; %>
<%
	//page 설정
	String pageParameter = request.getParameter("page");
	if(pageParameter == null) pageParameter = "1";
	
	//전체 행 개수 및 Page 개수 조회용 sql
	String sql = "";
	String keyword = request.getParameter("keyword");
	if (keyword == null || keyword == "")
		sql = "SELECT ReportMid, ReportId, RTitle, RTime, ReportUid FROM REPORT ORDER BY RTime DESC";
	else {
		sql = "SELECT ReportMid, ReportId, RTitle, RTime, ReportUid FROM REPORT " 
				+ "WHERE RContent LIKE '%" + keyword + "%' OR RTitle LIKE '%" + keyword 
				+ "%' OR ReportUid LIKE '%" + keyword + "%' ORDER BY RTime DESC";
	}
	
	int maxPage = 0;
	int unitPage = 10;
	
	try{
		rs = stmt.executeQuery(sql);
		rs.last();
		int rowCount = rs.getRow();
		rs.beforeFirst();
		maxPage = (int)(Math.ceil((float)rowCount/unitPage));
	}catch (SQLException e) {
		System.err.println("sql error = " + e.getMessage());
	}
	
	int pageIndex = (Integer.parseInt(pageParameter) - 1) * unitPage + 1;
	
	//테이블에 표시될 열의 index
	String startIndex = Integer.toString(pageIndex);
	String endIndex = Integer.toString(pageIndex + unitPage -1);
	
	//하단 page indicator index
	int indicatorStart = ((Integer.parseInt(pageParameter) - 1) / unitPage) * unitPage + 1;
	int indicatorEnd = (indicatorStart + unitPage -1 > maxPage) ? maxPage : indicatorStart + unitPage -1;
%>
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
	.indicator{
		width:100%;
		height:50px;
		display:flex; 
		flex-direction: row;
		justify-content:center;
	}
	
	.page-index{
		margin-top:20px;
		padding:5px 15px;
		width:fit-content;
		height:fit-content;
		border : 1px solid darkgray;
		cursor:pointer;
	}
	
	.page-index:hover{
		background:lightgray;
	}
</style>
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
			if (keyword == null || keyword == "")
				sql = "select * from("
						+ "select ReportMid, ReportId, RTitle, RTime, ReportUid, ROW_NUMBER() over(order by RTime desc) num "
						+ "from (SELECT ReportMid, ReportId, RTitle, RTime, ReportUid FROM REPORT ORDER BY RTime DESC)) "
						+ "where num between " + startIndex + " and " + endIndex + "";
			else {
				sql = "select * from("
						+ "select ReportMid, ReportId, RTitle, RTime, ReportUid, ROW_NUMBER() over(order by RTime desc) num "
						+ "from (SELECT ReportMid, ReportId, RTitle, RTime, ReportUid FROM REPORT " 
								+ "WHERE RContent LIKE '%" + keyword + "%' OR RTitle LIKE '%" + keyword 
								+ "%' OR ReportUid LIKE '%" + keyword + "%' ORDER BY RTime DESC)) "
						+ "where num between " + startIndex + " and " + endIndex + "";
			}
			try{
				rs = stmt.executeQuery(sql);
				int count = 0;
				while(rs.next()){
					ReportMid = rs.getString(1);
					count += 1;
					out.println("<tr class='report-item'>");
					for(int i=2;i<=5;i++) {
						if (i == 3) {
							String Rtitle = rs.getString(3);
							if (ReportMid != null) Rtitle +=  "  <span style='font-weight: bold;color: #07ba07;'>✓</span>";
							out.println("<td><a class='report-title' href='./reportContent.jsp?ReportId="
								+ rs.getInt(2) + "'>"+Rtitle+"</a></td>");
						}
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
	<%
		out.println("<div class='indicator'><div class='page-index'>Prev</div>");
		for(int i=indicatorStart; i<=indicatorEnd; i++){
			out.println("<div class='page-index'>" + i + "</div>");
		}
		out.println("<div class='page-index'>Next</div></div>");
	%>
</div>
<script>
	//paging 코드
	const unitPage = 10;
	
	//click event Listener 부착
	var cols = document.querySelectorAll(".page-index");
	[].forEach.call(cols, function(col){
	  col.addEventListener("click" , paging , false );
	});
	
	const currentPage = <%= pageParameter %>;
	const maxPage = <%= maxPage %>;
	const keyword = '<%= keyword %>';
	
	//데이터가 없을 경우 prev, next 버튼에 Listener 제거
	if(maxPage === 0){
		cols[0].removeEventListener("click" , paging , false );
		cols[1].removeEventListener("click" , paging , false );
	}
	
	//데이터가 있을 경우 선택된 칸 색 변경
	if(maxPage !== 0){
		if(currentPage%unitPage > 0){
			cols[currentPage%unitPage].style.background="#464646";
			cols[currentPage%unitPage].style.color="white";
		}else{
			cols[currentPage%unitPage+unitPage].style.background="#464646";
			cols[currentPage%unitPage+unitPage].style.color="white";
		}
	}
	
	//첫 페이지의 경우 prev 버튼 Listener 제거
	if(currentPage === 1){
		cols[0].removeEventListener("click" , paging , false );
	}
	
	//마지막 페이지의 경우 next 버튼 Listener 제거
	if(currentPage > 0 && currentPage === maxPage){
		cols[cols.length-1].removeEventListener("click" , paging , false );
	}
	
	function paging(event){
		let index = event.target.childNodes[0].nodeValue;
		const currentPage = <%= pageParameter %>
		
		if(index === "Prev"){
			index = parseInt(currentPage) - 1;
		}
		else if(index === "Next"){
			index = parseInt(currentPage) + 1;
		}
		if(keyword == 'null'){
			location.href="./report.jsp?page=" + index;
		}else{
			location.href="./report.jsp?keyword=" + keyword + "&page=" + index;
		}
	}
</script>
</body>
</html>