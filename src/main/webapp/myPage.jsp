<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page language="java" import="java.time.*, java.time.format.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이 페이지</title>
<link rel="icon" href="./image/favicon.png">
<link rel="stylesheet" href="./style/globalStyle.css">
<style type="text/css">
	#title {
		display: flex;
	    align-items: center;
	    justify-content: center;
	    font-size: 1.5em;
	    font-weight: 500;
		height: 130px;
		background: #f0f0f0;
	}
	#mypage {
		display: flex;	
		justify-content: center;
	}
	#mypage-wrapper {
		display: flex;	
		justify-content: space-around;
		width: 80%;
	}
	.mypage-contents {
		margin: 70px 0 30px 0;
	    padding: 20px;
	    height: 355px;
	    border: 1px solid lightgray;
	}
	#mypage-userInfo {
		justify-content: space-around;
		width: 300px;
		display: flex;
    	flex-direction: column;
    	height: 90%;
    	border-top: 1px solid;
	}
	
	.hidden-input{
		display:none;
	}
	
	.shown-input{
		font-weight: normal;
	}
	
	#mypage-roomInfo {
		width: auto;
		overflow-y: auto;
	}
	span {
		font-weight: bold;
	}
	#reserve-table {
		border-bottom: 1px solid lightgray;
		border-top: 1px solid;
	    border-spacing: 0;
	}
	#reserve-table th, #reserve-table td {
		padding: 5px;
		border-bottom: 1px solid lightgray;
		color: #666;
		text-align: center;
		height:40px;
	}
	
	.rating {
		background: gray;
		opacity: 0.5;
		color:white;
		cursor:auto;
	}
	.rating:hover {
		background: gray;
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
</head>
<body>
<%@ include file="./connectDB.jsp" %>
<%!
	String Name = "";
	String StudentId = "";
	String UserId = "";
	String ManagerId = "";
	String Department = "";
	String RatingId = "";
	
	String RoomNum = "";
	String RoomClassification = "";
	String RoomMaxAvailable = "";
	String StartTime = "";
	String EndTime = "";
	String Date = "";
	
	public void printRatingBtn(javax.servlet.jsp.JspWriter out) throws ServletException {
		try {
			if (RatingId == null)
				out.println("<td><button class='no-rating'>평가하기</button></td>");
			else 
				out.println("<td><button class='rating' disabled>평가완료</td>");
		} catch (Exception e){
			System.err.println("error = " + e.getMessage());
		}
	}
%>
<%
	if(session.getAttribute("userid") != null)
		UserId = session.getAttribute("userid").toString();
	else if(session.getAttribute("managerid") != null) {
		out.println("<script>location.href='managerPage.jsp';</script>");	
	}
	else {
		out.println("<script>alert('로그인을 하십시오.');</script>");
		out.println("<script>location.href='./';</script>");
	}
	
	//page 설정
	String pageParameter = request.getParameter("page");
	if(pageParameter == null) pageParameter = "1";
	
	//전체 행 개수 및 Page 개수 조회용 sql
	String sql = "select reserverno, classification, room.maxavailable, timeline.starttime, timeline.endtime, rdate, rateuid"
			+ " from (select * from reserves left outer join rating on reserveRno = rateRno and reserveuid = rateuid), timeline, room"
			+ " where timelineid = reservetid" 
			+ " and timelinerno = reserverno" 
			+ " and reserverno = roomnumber" 
			+ " and reserveuid = '"+ UserId +"'";
	
	int maxPage = 0;
	int unitPage = 4;
	
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
<%
	sql = "SELECT Name, StudentId, Department, RatingId" 
			+ " FROM (SELECT * FROM KNU_USER LEFT OUTER JOIN RATING ON UserId = RateUid)"
			+ "	WHERE UserId = '" + UserId + "'";
	try{
		rs = stmt.executeQuery(sql);
		rs.next();
		Name =  rs.getString(1);
		StudentId =  rs.getString(2);
		Department =  rs.getString(3);
		rs.close();
	} catch (SQLException e) {
		System.err.println("sql error = " + e.getMessage());
	}
%>
<script type="text/javascript">	
	let roomNumber = null;
	function openModal(className) {
		var elems = document.getElementsByClassName(className);
		for (var i=0;i<elems.length;i+=1){
			elems[i].style.display = 'block';
		}
	}
	
	function changeVisibility(){
		const shownInputs = document.querySelectorAll(".shown-input");
		const hiddenInputs = document.querySelectorAll(".hidden-input");
		
		shownInputs.forEach(function(shownInput){
			shownInput.classList.toggle('shown-input');
			shownInput.classList.toggle('hidden-input');
		})
		
		hiddenInputs.forEach(function(hiddenInput){
			hiddenInput.classList.toggle('shown-input');
			hiddenInput.classList.toggle('hidden-input');
		})
	}
	
	function editInfo(){
		document.getElementById("name").value = '<%= Name %>';
		document.getElementById("sid").value = '<%= StudentId %>';
		const select = document.getElementById('major');
		
		const oriMajor = '<%=Department %>'
		
		if(oriMajor === '컴퓨터공학부'){
			select[0].selected = true;
		}else if(oriMajor === '전기공학과'){
			select[1].selected = true;
		}else{
			select[2].selected = true;
		}
		
		changeVisibility();
	}
	
	function OKButton(){
		changeVisibility();
	}
	
	function editCheck(){
		const namePattern = /[^ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z]/;//한글영어
		
		let name = document.getElementById("name").value;
		let sid = document.getElementById("sid").value;
		let major = document.getElementById('major').value;
		
		if(namePattern.test(name)){
			alert("이름은 영문/한글 이외에 들어갈 수 없습니다.");
			changeVisibility();
			return false;
		}
		
		if(name.length > 7){
			alert("7글자까지 작성 가능합니다");
			changeVisibility();
			return false;
		}
		
		if(sid.length != 10){
			alert("학번을 올바로 입력하세요.");
			changeVisibility();
			return false;
		}
		
		if(!confirm('이름 : ' + name + '\n학번 : ' + sid + '\n학과 : ' + major + '\n\n 변경하려는 정보가 맞습니까?')){
			document.getElementById('ok-btn').setAttribute('type','button');
			changeVisibility();
			return false;
		}
		
		return true;
	}
	
	function ifChange(){
		document.getElementById('ok-btn').setAttribute('type','sumbit');
	}
</script>

<%@ include file="./navbar.jsp" %>
<div id="title">마이페이지</div>
<div id="mypage">
	<div id="mypage-wrapper">
		<div class="mypage-contents">
			<h3 style="text-align:center;margin-top: 0;">내 정보</h3>
			<form id="mypage-userInfo" action="./editInfo.jsp" onsubmit="return editCheck();" method="post">
				<div><span>이름&nbsp;&nbsp;&nbsp; :&nbsp;&nbsp;&nbsp;</span><span class="shown-input"><%= Name %></span><input class="hidden-input" id="name" name="name" onchange="ifChange()" value=<%= Name %> /></div>
				<div><span>학번&nbsp;&nbsp;&nbsp; :&nbsp;&nbsp;&nbsp;</span><span class="shown-input"><%= StudentId %></span><input class="hidden-input" id="sid" name="sid" type="number" onchange="ifChange()" value=<%= StudentId %> /></div>
				<div><span>아이디 :&nbsp;&nbsp;&nbsp;</span><%= UserId %></div>
				<div><span>비밀번호 :&nbsp;&nbsp;&nbsp;</span><button id="pwd-btn" type="button" onclick="openModal('modal');">비밀번호 변경</button></div>
				<div><span>학과&nbsp;&nbsp;&nbsp; :&nbsp;&nbsp;&nbsp;</span><span class="shown-input"><%= Department %></span>
					<select class="hidden-input" id="major" name="major" onchange="ifChange()">
			            <option value="컴퓨터공학부">컴퓨터공학부</option>
			            <option value="전기공학과">전기공학과</option>
			            <option value="전자공학부">전자공학부</option>
			        </select>
		        </div>
				<div>
					<span class="shown-input"><button id=edit-btn" type="button" onclick="editInfo()">정보 수정</button></span>
					<button id="ok-btn" class="hidden-input" type="button" onclick="OKButton()">확인</button>
					<button id="cancel-btn" class="hidden-input" type="button" onclick="changeVisibility()">취소</button>
					<button id="delete-btn" class="shown-input" type="button" onclick="openModal('deletemodal');">탈퇴하기</button>
				</div>
			</form>
			<jsp:include page="./changePwdModal.jsp" />
			<jsp:include page="./ratingWriteModal.jsp" />
			<jsp:include page="./deleteAccountModal.jsp" />
		</div>
		<div id="mypage-roomInfo" class="mypage-contents">
			<h3 style="text-align:center;margin-top: 0;">강의실 예약내역</h3>
			<table id="reserve-table">
				<colgroup>
					<col width="200px">
					<col width="200px">
					<col width="200px">
					<col width="200px">
					<col width="200px">
					<col width="120px">
				</colgroup>
				<thead>
					<tr>
						<th colspan="1">강의실</th>
						<th colspan="1">허용 가능 인원</th>
						<th colspan="1">이용 시작 시간</th>
						<th colspan="1">이용 종료 시간</th>
						<th colspan="1">예약 날짜</th>
						<th colspan="1"></th>
					</tr>
				</thead>
				<tbody class="reserve-list-tbody">
			<%
				sql = "select reserverno, classification, room.maxavailable, timeline.starttime, timeline.endtime, rdate, rateuid"
						+ " from (select * from reserves left outer join rating on reserveRno = rateRno and reserveuid = rateuid), timeline, room"
						+ " where timelineid = reservetid" 
						+ " and timelinerno = reserverno" 
						+ " and reserverno = roomnumber" 
						+ " and reserveuid = '"+ UserId +"'";
				
				int count = 0;
				
				sql = "select * "
						+ "from (select reserverno, classification, room.maxavailable, timeline.starttime, timeline.endtime, rdate, rateuid, ROW_NUMBER() over(order by rdate desc) num "
								+ "from (select * from reserves left outer join rating on reserveRno = rateRno and reserveuid = rateuid), timeline, room "
								+ "where timelineid = reservetid and timelinerno = reserverno "
								+ "and reserverno = roomnumber "
								+ "and reserveuid = '" + UserId + "' "
								+ "order by rdate desc, timeline.starttime desc) "
						+ "where num between " + startIndex + " and " + endIndex + "";
				try{
					rs = stmt.executeQuery(sql);
					while(rs.next()){
						String Rdate = "";
						count += 1;
						out.println("<tr class='reserve-item'>");
						out.println("<td>"+rs.getString(1)+"("+rs.getString(2)+")</td>");
						for(int i=3;i<=6;i++) {
							if(i == 6) {
								Rdate = rs.getString(i).substring(0, 10);
								out.println("<td>"+Rdate+"</td>");
							}
							else out.println("<td>"+rs.getString(i)+"</td>");
						}
						RatingId = rs.getString(7);
						// 예약 날짜가 지난 것만 평가할 수 있게 함
						LocalDateTime now = LocalDateTime.now();
						String date = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
						if (Integer.valueOf(date.substring(0, 4)) - Integer.valueOf(Rdate.substring(0, 4)) > 0)
							printRatingBtn(out);
						else if (Integer.valueOf(date.substring(0, 4)) - Integer.valueOf(Rdate.substring(0, 4)) == 0)
							if (Integer.valueOf(date.substring(5, 7)) - Integer.valueOf(Rdate.substring(5, 7)) > 0)
								printRatingBtn(out);
							else if (Integer.valueOf(date.substring(5, 7)) - Integer.valueOf(Rdate.substring(5, 7)) == 0)
								if (Integer.valueOf(date.substring(8, 10)) - Integer.valueOf(Rdate.substring(8, 10)) > 0)
									printRatingBtn(out);
								else
									out.println("<td></td>");
							else
								out.println("<td></td>");
						else
							out.println("<td></td>");
						
						out.println(" </tr>");
					}
				}catch (SQLException e) {
					System.err.println("sql error = " + e.getMessage());
				}
				if (count ==0) {
					out.println("<tr><td colspan='6'>");
					out.println("<div style='text-align: center;'>예약 내역이 없습니다.</div>");
					out.println("</td></tr>");
				}else{
					for(int i=0; i<4-count; i++){
						out.println("<tr>");
						out.println("<td colspan='6'></td>");
						out.println("</tr>");
					}
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
	</div>
</div>
<%@ include file="./footer.jsp" %>
<script>
	//평가하기/평가완료 그리는 코드
	var cols = document.querySelectorAll(".no-rating");
	[].forEach.call(cols, function(col){
	  col.addEventListener("click" , doRating , false );
	});
	  
	function doRating(e){
		informantion = e.target.parentNode.parentNode;
		
		const roomNo = document.getElementById("roomNo");
		const startTime = document.getElementById("startTime");
		const endTime = document.getElementById("endTime");
		
		roomNo.value = informantion.cells[0].childNodes[0].nodeValue.split('(')[0];
		startTime.value = informantion.cells[2].childNodes[0].nodeValue;
		endTime.value = informantion.cells[3].childNodes[0].nodeValue;
		openModal('ratingmodal');
	}
	
	//paging 코드
	const unitPage = 4;
	
	//click event Listener 부착
	var cols = document.querySelectorAll(".page-index");
	[].forEach.call(cols, function(col){
	  col.addEventListener("click" , paging , false );
	});
	
	const currentPage = <%= pageParameter %>
	const maxPage = <%= maxPage %>
	
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
		
		location.href="./myPage.jsp?page=" + index;
	}
	
	
	//이름 Byte 관리 코드
	document.getElementById('name').addEventListener('keyup', checkNameByte);
	const number = document.getElementById('sid');
	number.addEventListener('keyup', checkSIDByte);
	
	number.onkeydown = function(e) {
	    if(!((e.keyCode > 95 && e.keyCode < 106)
	      || (e.keyCode > 47 && e.keyCode < 58) 
	      || e.keyCode == 8)) {
	        return false;
	    }
	}
	
	let name = "";
	const MAX_NAME_LIMIT = 15;
	
	function checkNameByte(event){
		let count = 0;
		
		for(index = 0; index < event.target.value.length; index++){
			if(event.target.value.charCodeAt(index) <= 128) count++;
			else count += 2;
		}
		
		if(count <= MAX_NAME_LIMIT){
			name = event.target.value;
		}else{
			alert("이름은 " + MAX_NAME_LIMIT + " Bytes만큼만 입력할 수 있습니다.\n(한글 : 2 Bytes, 영문 : 1 Bytes))");
			event.target.value = name;
		}
	}
	
	let sid = "";
	const MAX_SID_LIMIT = 10;
	
	function checkSIDByte(event){
		let count = 0;
		
		for(index = 0; index < event.target.value.length; index++){
			if(event.target.value.charCodeAt(index) <= 128) count++;
			else count += 2;
		}
		
		if(count <= MAX_SID_LIMIT){
			sid = event.target.value;
		}else{
			event.target.value = sid;
		}
	}
</script>
</body>
</html>