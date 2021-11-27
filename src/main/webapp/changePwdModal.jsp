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
		var Password = document.getElementById('password');
		var CheckPwd = document.getElementById('checkPwd');
	    if(Password.value == '') {
	        window.alert("새 비밀번호를 입력하세요.");
	        return false;
	    }
	    else if (Password.value.length > 15) {
	    	window.alert("비밀번호는 16자리 미만이어야 합니다.");
		    return false;
	    }
	    else if (Password.value != CheckPwd.value) {
	    	window.alert("비밀번호 확인이 일치하지 않습니다.");
		    return false;
	    }
	}
</script>

<div id="pwdModal" class="modal">
  <div class="modal-content">
        <p style="text-align: center;"><span style="font-size: 20pt;">
        	<b><span style="font-size: 14pt;">비밀번호 변경</span></b></span>
        	<button type="button" class="close-btn" onclick="closeModal('modal');">X</button>
        </p>
        <form method="post" action="./changePwd.jsp" onsubmit="return checkForm();">
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
</div>