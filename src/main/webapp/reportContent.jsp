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
    flex-direction: column;
    align-items: center;
    margin-top: 20px;
}
.report {
	width: 900px;
	border-top: 1px solid;
    border-bottom: 1px solid;
}
.report-detail {
	display: flex;
	justify-content: flex-start;
	background: #f0f0f0;
	padding: 15px;
}
.report-detail span {
	font-weight: bold;
	margin: 0 15px;
}
.report-content {
	padding: 20px;
	height: 125px;
	white-space: pre-line;
	word-break: break-all;
}
#no-answer {
	display: flex;
	align-items: center;
	padding: 0;
}
</style>
</head>
<body>
<script type="text/javascript">
	function openAnswerModal(){
		var elems = document.getElementById("modal-update").style.display = 'block';
	}
	function closeModal(){
		var elems = document.getElementsByClassName("modal");
		for (var i=0;i<elems.length;i+=1){
			elems[i].style.display = 'none';
		}
	}
	function hideAnswer(){
		document.getElementById("answer").style.display = 'none';
	}
	function hideAnsBtn() {
		document.getElementById("answer-btn").style.display = 'none';
	}
	function checkForm(){
	    var RAnswer = document.getElementById('RAnswer');
	    if(RAnswer.value == ''){
	    	window.alert('내용을 입력하세요.');
	        return false;
	    }
	}
</script>
<%!
	String ReportId = "";
	String ReportUid = "";
	String RTitle = "";
	String RContent = "";
	String RTime = "";
	String ReportMid = "";
	String RAnswer = "";
	String RAnsTime = "";
%>
<%@ include file="./connectDB.jsp" %>
<%@ include file="./navbar.jsp" %>
<div id="title">문의사항</div>
<%
	ReportId = request.getParameter("ReportId");
	String sql = "SELECT * FROM REPORT WHERE ReportId = " + ReportId;
	try{
		rs = stmt.executeQuery(sql);
		rs.next();
		ReportUid = rs.getString(1);
		RTitle = rs.getString(3);
		RContent = rs.getString(4);
		RTime = rs.getString(5);
		ReportMid = rs.getString(6);
		RAnswer = rs.getString(7);
		RAnsTime = rs.getString(8);
		rs.close();
	} catch (SQLException e) {
		System.err.println("sql error = " + e.getMessage());
	}
	
	// answer
	if (request.getParameter("Answer") != null) {
		ReportMid = 
		RAnswer = request.getParameter("RAnswer");
		// get date
		LocalDateTime now = LocalDateTime.now();
		String date = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
		try {
			sql = "UPDATE REPORT SET ReportMid = '"+ session.getAttribute("managerid") +"', RAnswer = '" + RAnswer + "', RAnsTime = TO_DATE('" + date
					+ "', 'YYYY-MM-DD HH24:MI:SS') WHERE ReportId  = " + ReportId;
			stmt.executeUpdate(sql);
			response.sendRedirect("reportContent.jsp?ReportId=" + ReportId);
		} catch (SQLException ex2) {
			System.err.println("sql error = " + ex2.getMessage());
		}
	}
%>

<div id="wrapper">
	<div class="report">
		<h3 style="padding-left: 15px;"><%= RTitle %></h3>
		<div class="report-detail">
			<div><span>작성자</span><%= ReportUid %></div>
			<div style="margin-left: 50px;"><span>등록일</span><%= RTime %></div>
		</div>
		<div class="report-content"><%= RContent %></div>
		<div style="width:100%;margin-bottom: 10px;text-align: right;">
			<button id="answer-btn" type='submit' onclick="openAnswerModal();"><%
				if(ReportMid == null) out.println("답변");
				else out.println("답변 수정");
			%></button>
		</div>
	</div>
	<div class="report" id="answer">
		<div class="report-detail">
			<div><span>관리자</span><%= ReportMid %></div>
			<div style="margin-left: 50px;"><span>답변일</span><%= RAnsTime %></div>
		</div>
		<div class="report-content"><%= RAnswer %></div>
	</div>
	<%
		if(ReportMid == null) { 
			out.println("<script>hideAnswer();</script>");
			out.println("<div class='report-content' id='no-answer'>답변이 없습니다.</div>");
		}
		if(session.getAttribute("managerid") == null) {
			out.println("<script>hideAnsBtn();</script>");
		}
	%>
</div>
<!-- Answer modal -->
<div id="modal-update" class="modal">
  <form class="modal-content" method="post" action="./reportContent.jsp?ReportId=<%= ReportId %>&Answer=yes" onsubmit="return checkForm();">
        <p style="text-align: center;"><span style="font-size: 20pt;">
        	<b><span style="font-size: 14pt;margin-left: 50px;">답변하기</span></b></span>
        	<button type="button" class="close-btn" onclick="closeModal();">X</button>
        </p>
        <div style="display:flex;flex-direction:column;align-items: baseline;">
         	<div style="width:100%;margin-bottom: 5px;text-align: left;">내용:</div>
         	<div style="width: 100%;margin-bottom: 20px;">
         		<textarea style="width: 100%;height: 150px;resize: none;" name="RAnswer" id="RAnswer"><% 
         			if(RAnswer != null) out.println(RAnswer);
         		%></textarea>
         		<div style="text-align:right">
					<span id="byte-count">0</span><span> Bytes</span>
				</div>
         	</div>
        </div>
        <button class="submit-btn" type="submit">
            <span class="pop_bt" style="font-size: 13pt;" >
                 완료
            </span>
        </button>
  </form>
</div>
<%@ include file="./footer.jsp" %>
<script>
document.querySelector('textarea').addEventListener('keyup', checkByte);
var byteCount = document.getElementById('byte-count');

let message = "";
const MAX_LIMIT = 300;

function checkByte(event){
	let count = 0;
	
	for(index = 0; index < event.target.value.length; index++){
		if(event.target.value.charCodeAt(index) <= 128) count++;
		else count += 2;
	}
	
	if(count <= MAX_LIMIT){
		message = event.target.value;
		byteCount.innerText = count;
	}else{
		alert("내용은 " + MAX_LIMIT + " Bytes만큼만 입력할 수 있습니다.");
		event.target.value = message;
	}
}
</script>

</body>
</html>