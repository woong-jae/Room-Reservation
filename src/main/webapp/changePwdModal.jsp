<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
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
		var Password = document.getElementById('password');
	    if(Password.value == '') {
	        window.alert("새 비밀번호를 입력하세요.");
	        return false;
	    }
	    else if (Password.value.length > 15) {
	    	window.alert("비밀번호는 16자리 미만이어야 합니다.");
		    return false;
	    }
	}
</script>

<%@ include file="./connectDB.jsp" %>
<%
	if(session.getAttribute("userid") != null) { 
		String sql = "";
		String UserId = session.getAttribute("userid").toString();
		String Password = request.getParameter("Password");
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
%>


<div id="myModal" class="modal">
  <form id="modal-content" method="post" action="./myPage.jsp" onsubmit="return checkForm();">
        <p style="text-align: center;"><span style="font-size: 20pt;">
        	<b><span style="font-size: 14pt;margin-left: 50px;">비밀번호 변경</span></b></span>
        	<button type="button" id="close-btn" onclick="closeModal();">X</button>
        </p>
        <div style="display:flex;flex-direction:column;align-items: baseline;">
         	<div style="width: 100%;margin-bottom: 20px;display: flex;align-items: center;">
         		새 비밀번호: <input type="password" style="width: 89%;margin-left: 6px;" 
         						name="Password" id="password">
         	</div>
        </div>
        <button id="submit-btn" type="submit">
            <span class="pop_bt" style="font-size: 13pt;" >
                 제출
            </span>
        </button>
  </form>
</div>