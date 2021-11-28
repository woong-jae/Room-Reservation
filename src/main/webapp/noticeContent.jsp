<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page language="java" import="java.time.*, java.time.format.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="./style/globalStyle.css">
<link rel="stylesheet" href="./style/modalStyle.css">
<style>
	#title {
		display: flex;
	    align-items: center;
	    justify-content: center;
	    font-size: 1.5em;
	    font-weight: 500;
		height: 130px;
		background: #f0f0f0;
	}
	#wrapper {
		display:flex;
	    justify-content: center;
	    margin-top: 20px;
	}
	#notice {
		width: 900px;
		border-top: 1px solid;
	    border-bottom: 1px solid;
	}
	#notice-detail {
		display: flex;
		justify-content: flex-start;
		background: #f0f0f0;
		padding: 15px;
	}
	#notice-detail span {
		font-weight: bold;
		margin: 0 15px;
	}
	#notice-content {
		padding: 20px;
		height: 250px;
		white-space: pre-line;
		word-break: break-all;
	}
	#delete-notice, #update-notice {
		height: 32px;
	}
	#delete-notice {
		background: #b41a1f;
	}
</style>
</head>
<body>
<script type="text/javascript">
	function openDeleteModal(){
		var elems = document.getElementById("modal-delete").style.display = 'block';
	}
	function openUpdateModal(){
		var elems = document.getElementById("modal-update").style.display = 'block';
	}
	function closeModal(){
		var elems = document.getElementsByClassName("modal");
		for (var i=0;i<elems.length;i+=1){
			elems[i].style.display = 'none';
		}
	}
	function hideModalBtn(){
		document.getElementById("update-notice").style.display = 'none';
		document.getElementById("delete-notice").style.display = 'none';
	}
	function checkForm(){
		var RTitle = document.getElementById('NTitle');
	    if(RTitle.value == '') {
	        window.alert("제목을 입력하세요");
	        return false;
	    }
	    var RContent = document.getElementById('NContent');
	    if(RContent.value == ''){
	    	window.alert('내용을 입력하세요.');
	        return false;
	    }
	}
</script>
<%!
	String NoticeId = "";
	String NoticeMid = "";
	String NTitle = "";
	String NContent = "";
	String WrittenTime = "";
%>
<%@ include file="./connectDB.jsp" %>
<%@ include file="./navbar.jsp" %>
<div id="title">공지사항</div>
<%
	NoticeId = request.getParameter("NoticeId");
	String sql = "SELECT * FROM NOTICE WHERE NoticeId = " + NoticeId;
	try{
		rs = stmt.executeQuery(sql);
		rs.next();
		NoticeMid = rs.getString(1);
		NTitle = rs.getString(3);
		NContent = rs.getString(4);
		WrittenTime = rs.getString(5);
		rs.close();
	} catch (SQLException e) {
		System.err.println("sql error = " + e.getMessage());
	}
	
	// delete
	if (request.getParameter("Delete") != null) {
		try {
			sql = "DELETE FROM NOTICE WHERE NoticeId = " + NoticeId;
			stmt.executeUpdate(sql);
			out.println("<script>location.href='notice.jsp';</script>");
		} catch (SQLException ex2) {
			System.err.println("sql error = " + ex2.getMessage());
		}
	}
	
	// update
	if (request.getParameter("Update") != null) {
		NTitle = request.getParameter("NTitle");
		NContent = request.getParameter("NContent");
		// get date
		LocalDateTime now = LocalDateTime.now();
		String date = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
		try {
			sql = "UPDATE NOTICE SET NTitle = '" + NTitle + "', NContent = '" + NContent + "', WrittenTime = TO_DATE('" + date
					+ "', 'YYYY-MM-DD HH24:MI:SS') WHERE NoticeId = " + NoticeId;
			stmt.executeUpdate(sql);
			out.println("<script>location.href='noticeContent.jsp?NoticeId=" + NoticeId + "';</script>");
		} catch (SQLException ex2) {
			System.err.println("sql error = " + ex2.getMessage());
		}
	}
%>


<div id="wrapper">
	<div id="notice">
		<h3 style="padding-left: 15px;"><%= NTitle %></h3>	
		<div id="notice-detail">
			<div><span>작성자</span><%= NoticeMid %></div>
			<div style="margin-left: 50px;"><span>등록일</span><%= WrittenTime %></div>
		</div>
		<div id="notice-content"><%= NContent %></div>
		<div style="margin-bottom: 10px;text-align: end;">
			<button id="update-notice" onclick="openUpdateModal();">수정</button>
			<button id="delete-notice" onclick="openDeleteModal();">삭제</button>
		</div>
	</div>
</div>
<%
	if(session.getAttribute("managerid") == null || !session.getAttribute("managerid").toString().equals(NoticeMid.trim())) { 
		out.println("<script>hideModalBtn();</script>");
	}
%>
<!-- delete modal -->
<div id="modal-delete" class="modal">
  <form class="modal-content" method="post" action="./noticeContent.jsp?NoticeId=<%= NoticeId %>&Delete=yes">
        <p style="text-align: center;"><span style="font-size: 20pt;">
        	<b><span style="font-size: 14pt;">해당 공지를 정말로 삭제하시겠습니까?</span></b></span>
        	<button type="button" class="close-btn" onclick="closeModal();">X</button>
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

<!-- update modal -->
<div id="modal-update" class="modal">
  <form class="modal-content" method="post" action="./noticeContent.jsp?NoticeId=<%= NoticeId %>&Update=yes" onsubmit="return checkForm();">
        <p style="text-align: center;"><span style="font-size: 20pt;">
        	<b><span style="font-size: 14pt;margin-left: 50px;">공지 수정하기</span></b></span>
        	<button type="button" class="close-btn" onclick="closeModal();">X</button>
        </p>
        <div style="display:flex;flex-direction:column;align-items: baseline;">
         	<div style="width: 100%;margin-bottom: 20px;display: flex;align-items: flex-end;">
         		<div>제목:</div> <input type="text" style="width: 89%;margin-left: 6px;" name="NTitle" id="NTitle" value="<%= NTitle %>">
         	</div>
         	<div style="width: 100%;margin-bottom: 5px;text-align: left;">내용:</div>
         	<div style="width: 100%;margin-bottom: 20px;">
         		<textarea style="width: 100%;height: 150px;resize: none;" name="NContent" id="NContent"><%= NContent %></textarea>
         		<div style="text-align:right">
					<span id="byte-count">0</span><span> Bytes</span>
				</div>
         	</div>
        </div>
        <button class="submit-btn" type="submit">
            <span class="pop_bt" style="font-size: 13pt;" >
                 수정
            </span>
        </button>
  </form>
</div>
<%@ include file="./footer.jsp" %>
<script>
document.getElementById('NTitle').addEventListener('keyup', checkTitleByte);
document.querySelector('textarea').addEventListener('keyup', checkContentByte);
var byteCount = document.getElementById('byte-count');

let title = "";
let message = "";
const MAX_TITLE_LIMIT = 50;
const MAX_CONTENT_LIMIT = 300;

function checkTitleByte(event){
	let count = 0;
	
	for(index = 0; index < event.target.value.length; index++){
		if(event.target.value.charCodeAt(index) <= 128) count++;
		else count += 2;
	}
	
	if(count <= MAX_TITLE_LIMIT){
		title = event.target.value;
	}else{
		alert("제목은 " + MAX_TITLE_LIMIT + " Bytes만큼만 입력할 수 있습니다.");
		event.target.value = title;
	}
}

function checkContentByte(event){
	let count = 0;
	
	for(index = 0; index < event.target.value.length; index++){
		if(event.target.value.charCodeAt(index) !== 10 && event.target.value.charCodeAt(index) <= 128) count++;
		else count += 2;
	}
	
	if(count <= MAX_CONTENT_LIMIT){
		message = event.target.value;
		byteCount.innerText = count;
	}else{
		alert("내용은 " + MAX_CONTENT_LIMIT + " Bytes만큼만 입력할 수 있습니다.");
		event.target.value = message;
	}
}
</script>
</body>
</html>