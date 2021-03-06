<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="./connectDB.jsp" %>
<%
	//page 설정
	String pageParameter = request.getParameter("page");
	if(pageParameter == null) pageParameter = "1";
	
	//전체 행 개수 및 Page 개수 조회용 sql
	String sql = "";
	String notiKeyword = request.getParameter("notiKeyword");
	if (notiKeyword == null || notiKeyword == "")
		sql = "SELECT NoticeId, NTitle, WrittenTime, NoticeMid FROM NOTICE ORDER BY WrittenTime DESC";
	else {
		sql = "SELECT NoticeId, NTitle, WrittenTime, NoticeMid FROM NOTICE " 
			+ "WHERE NContent LIKE '%" + notiKeyword + "%' OR NTitle LIKE '%" + notiKeyword + "%' "
			+ "OR NoticeMid LIKE '%" + notiKeyword + "%' ORDER BY WrittenTime DESC";
	}
	
	int notiMaxPage = 0;
	int notiUnitPage = 10;
	
	try{
		rs = stmt.executeQuery(sql);
		rs.last();
		int rowCount = rs.getRow();
		rs.beforeFirst();
		notiMaxPage = (int)(Math.ceil((float)rowCount/notiUnitPage));
	}catch (SQLException e) {
		System.err.println("sql error = " + e.getMessage());
	}
	
	int pageIndex = (Integer.parseInt(pageParameter) - 1) * notiUnitPage + 1;
	
	//테이블에 표시될 열의 index
	String startIndex = Integer.toString(pageIndex);
	String endIndex = Integer.toString(pageIndex + notiUnitPage -1);
	
	//하단 page indicator index
	int indicatorStart = ((Integer.parseInt(pageParameter) - 1) / notiUnitPage) * notiUnitPage + 1;
	int indicatorEnd = (indicatorStart + notiUnitPage -1 > notiMaxPage) ? notiMaxPage : indicatorStart + notiUnitPage -1;
%>
<style type="text/css">
	#notice-wrapper {
		display: flex;
		flex-direction: column;
	    align-items: center;
	    margin-top: 30px;
	}
	#notice-table {
		border-bottom: 1px solid lightgray;
		border-top: 1px solid;
		border-collapse: collapse;
	    border-spacing: 0;
	}
	#notice-table th, #notice-table td {
		padding: 10px;
		border-bottom: 1px solid lightgray;
		color: #666;
		text-align:center;
	}
	.notice-title {
		cursor: pointer;
		text-decoration: none;
		color: #666;
	}
	.notice-title:hover {
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
<div id="notice-wrapper">
	<table id="notice-table">
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
			notiKeyword = request.getParameter("notiKeyword");
			if (notiKeyword == null || notiKeyword == "")
				sql = "select * from("
						+ "select NoticeId, NTitle, WrittenTime, NoticeMid, ROW_NUMBER() over(order by WrittenTime desc) num "
						+ "from (SELECT NoticeId, NTitle, WrittenTime, NoticeMid FROM NOTICE ORDER BY WrittenTime DESC)) "
						+ "where num between " + startIndex + " and " + endIndex + "";
			else {
				sql = "select * from("
						+ "select NoticeId, NTitle, WrittenTime, NoticeMid, ROW_NUMBER() over(order by WrittenTime desc) num "
						+ "from (SELECT NoticeId, NTitle, WrittenTime, NoticeMid FROM NOTICE " 
								+ "WHERE NContent LIKE '%" + notiKeyword + "%' OR NTitle LIKE '%" + notiKeyword + "%' "
								+ "OR NoticeMid LIKE '%" + notiKeyword + "%' ORDER BY WrittenTime DESC)) "
						+ "where num between " + startIndex + " and " + endIndex + "";
			}
			try{
				rs = stmt.executeQuery(sql);
				int count = 0;
				while(rs.next()){
					count += 1;
					out.println("<tr class='notice-item'>");
					for(int i=1;i<=4;i++) {
						if (i == 2) 
							out.println("<td style='text-align:left;'><a class='notice-title' href='./noticeContent.jsp?NoticeId="
								+ rs.getInt(1) + "'>"+rs.getString(2)+"</a></td>");
						else if(i == 3) out.println("<td>"+rs.getString(i).substring(0, 10)+"</td>");
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
	const notiUnitPage = 10;
	
	//click event Listener 부착
	var cols = document.querySelectorAll(".page-index");
	[].forEach.call(cols, function(col){
	  col.addEventListener("click" , paging , false );
	});
	
	const notiCurrentPage = <%= pageParameter %>;
	const notiMaxPage = <%= notiMaxPage %>;
	const notiKeyword = '<%= notiKeyword %>';
	
	if(notiKeyword !== 'null'){
		const notiSearchBox = document.getElementById('noti-search');
		notiSearchBox.setAttribute('value', notiKeyword);
	}
	
	//데이터가 없을 경우 prev, next 버튼에 Listener 제거
	if(notiMaxPage === 0){
		cols[0].removeEventListener("click" , paging , false );
		cols[1].removeEventListener("click" , paging , false );
	}
	
	//데이터가 있을 경우 선택된 칸 색 변경
	if(notiMaxPage !== 0){
		if(notiCurrentPage%notiUnitPage > 0){
			cols[notiCurrentPage%notiUnitPage].style.background="#464646";
			cols[notiCurrentPage%notiUnitPage].style.color="white";
		}else{
			cols[notiCurrentPage%notiUnitPage+notiUnitPage].style.background="#464646";
			cols[notiCurrentPage%notiUnitPage+notiUnitPage].style.color="white";
		}
	}
	
	//첫 페이지의 경우 prev 버튼 Listener 제거
	if(notiCurrentPage === 1){
		cols[0].removeEventListener("click" , paging , false );
	}
	
	//마지막 페이지의 경우 next 버튼 Listener 제거
	if(notiCurrentPage > 0 && notiCurrentPage === notiMaxPage){
		cols[cols.length-1].removeEventListener("click" , paging , false );
	}
	
	function paging(event){
		let index = event.target.childNodes[0].nodeValue;
		const notiCurrentPage = <%= pageParameter %>
		
		if(index === "Prev"){
			index = parseInt(notiCurrentPage) - 1;
		}
		else if(index === "Next"){
			index = parseInt(notiCurrentPage) + 1;
		}
		
		if(notiKeyword == 'null'){
			location.href="./notice.jsp?page=" + index;
		}else{
			location.href="./notice.jsp?notiKeyword=" + notiKeyword + "&page=" + index;
		}
	}
</script>
</body>
</html>