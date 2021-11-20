<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page language="java" import="java.time.*, java.time.format.*" %>
<style>
	/* The Modal (background) */
	.modal {
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
	
	/* Modal Content/Box */
	#modal-content {
	    background-color: #fefefe;
	    margin: 15% auto; /* 15% from the top and centered */
	    padding: 20px;
	    border: 1px solid #888;
	    width: 30%; /* Could be more or less, depending on screen size */                          
	}
	#close-btn {
		position: relative;
    	left: 32%;
    	width: 27px;
    	height: 27px;
	}	
	#close-btn:hover {
		background: #353535;
	}
	#submit-btn {
		cursor:pointer;
		background-color:#bcbcbc;
		text-align: center;
		padding-bottom: 10px;
		padding-top: 10px;
		width: 100%;
	}
	#submit-btn:hover {
		background-color: #b6b6b6;
	}
</style>

<script type="text/javascript">
	function closeModal(){
		var elems = document.getElementsByClassName("modal");
		for (var i=0;i<elems.length;i+=1){
			elems[i].style.display = 'none';
		}
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

<%@ include file="./connectDB.jsp" %>
<%
	if(session.getAttribute("managerid") != null) { 
		String sql = "";
		String managerId = session.getAttribute("managerid").toString();
		String NTitle = request.getParameter("NTitle");
		String NContent = request.getParameter("NContent");
		int noticeId = 0;
	
		if (NTitle != null && NContent != null) {
			try {
				sql = "SELECT MAX(NoticeId) FROM NOTICE";
				rs = stmt.executeQuery(sql);
				rs.next();
				noticeId = rs.getInt(1) + 1;
				rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			// get date
			LocalDateTime now = LocalDateTime.now();
			String date = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
			try {
				sql = "INSERT INTO NOTICE VALUES('" + managerId + "', '" + noticeId + "', '" 
					+ NTitle + "', '" + NContent + "', TO_DATE('" + date
					+ "', 'YYYY-MM-DD HH24:MI:SS'))";
				stmt.executeUpdate(sql);
				out.println("<script>alert('작성 완료했습니다.');</script>");
				out.println("<script>location.href='notice.jsp';</script>");
			} catch (SQLException ex2) {
				System.err.println("sql error = " + ex2.getMessage());
			}
		}
	}
%>

<div id="myModal" class="modal">
  <form id="modal-content" method="post" action="./notice.jsp" onsubmit="return checkForm();">
        <p style="text-align: center;"><span style="font-size: 20pt;">
        	<b><span style="font-size: 14pt;margin-left: 50px;">공지하기</span></b></span>
        	<button type="button" id="close-btn" onclick="closeModal();">X</button>
        </p>
        <div style="display:flex;flex-direction:column;align-items: baseline;">
         	<div style="width: 100%;margin-bottom: 20px;display: flex;align-items: center;">
         		제목: <input type="text" style="width: 89%;margin-left: 6px;" name="NTitle" id="NTitle">
         	</div>
         	내용:
         	<div style="width: 100%;margin-bottom: 20px;">
         		<textarea style="width: 100%;height: 150px;resize: none;" name="NContent" id="NContent"></textarea>
         	</div>
        </div>
        <button id="submit-btn" type="submit">
            <span class="pop_bt" style="font-size: 13pt;" >
                 제출
            </span>
        </button>
  </form>
</div>

