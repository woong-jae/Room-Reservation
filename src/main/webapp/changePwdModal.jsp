<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<link rel="stylesheet" href="./style/modalStyle.css">

<script type="text/javascript">
	function closeModal(className){
		var elems = document.getElementsByClassName(className);
		for (var i=0;i<elems.length;i+=1){
			elems[i].style.display = 'none';
		}
	}
	function checkForm(){
		var Password = document.getElementById('password').value;
		var CheckPwd = document.getElementById('checkPwd').value;
	    if(Password.value == '') {
	        window.alert("새 비밀번호를 입력하세요.");
	        return false;
	    }
	    else if (Password.value.length > 15) {
	    	window.alert("비밀번호는 16자리 미만이어야 합니다.");
		    return false;
	    }
	    else if (Password != CheckPwd) {
	    	console.log(Password);
	    	window.alert("비밀번호 확인이 일치하지 않습니다.");
		    return false;
	    }
	}
</script>

<%@ include file="./connectDB.jsp" %>
<%
	String sql = "";
	String Password = "";
	if(session.getAttribute("userid") != null) { 
		String UserId = session.getAttribute("userid").toString();
		Password = request.getParameter("Password");
		if (Password != null) {
			try {
				sql = "UPDATE KNU_USER SET Password = '" + Password + "' WHERE UserId = '" + UserId + "'";
				stmt.executeUpdate(sql);
				out.println("<script>alert('비밀번호가 변경되었습니다.');</script>");
				out.println("<script>location.href='myPage.jsp';</script>");
			} catch (SQLException ex2) {
				System.err.println("sql error = " + ex2.getMessage());
			}
		}
	}
	else if(session.getAttribute("managerid") != null) {
		String ManagerId = session.getAttribute("managerid").toString();
		Password = request.getParameter("Password");
		if (Password != null) {
			try {
				sql = "UPDATE MANAGER SET MPassword = '" + Password + "' WHERE ManagerId = '" + ManagerId + "'";
				stmt.executeUpdate(sql);
				out.println("<script>alert('비밀번호가 변경되었습니다.');</script>");
				out.println("<script>location.href='managerPage.jsp';</script>");
			} catch (SQLException ex2) {
				System.err.println("sql error = " + ex2.getMessage());
			}
		}
	}
%>

<div id="myModal" class="modal">
  <form class="modal-content" method="post" action="./myPage.jsp" onsubmit="return checkForm();">
        <p style="text-align: center;"><span style="font-size: 20pt;">
        	<b><span style="font-size: 14pt;">비밀번호 변경</span></b></span>
        	<button type="button" class="close-btn" onclick="closeModal('modal');">X</button>
        </p>
        <div style="display:flex;flex-direction:column;align-items: baseline;">
         	<div style="width: 100%;margin-bottom: 20px;display: flex;align-items: flex-end;">
         		<div>새 비밀번호:</div>
         		<input type="password" style="width: 73%;margin-left: auto;" name="Password" id="password">
         	</div>
         	<div style="width: 100%;margin-bottom: 20px;display: flex;align-items: flex-end;">
         		<div>비밀번호 확인:</div>
         		<input type="password" style="width: 73%;margin-left: auto;" id="checkPwd">
         	</div>
        </div>
        <button class="submit-btn" type="submit">
            <span class="pop_bt" style="font-size: 13pt;" >
                 제출
            </span>
        </button>
  </form>
</div>