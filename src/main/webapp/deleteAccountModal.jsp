<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<link rel="stylesheet" href="./style/modalStyle.css">
<script>
const pwPattern = /[^a-zA-Z0-9!@#$%^&*]/;//영어숫자특수기호

function deleteCheck(){
	const password = document.getElementById("deleteCheckPwd");
	
	if(!pwPattern.test(password)){
		alert("비밀번호는 영숫자 및 !@#%$^&*만 사용 가능합니다.");
		return false;
	}
	
	return true;
}
</script>

<div id="Modal" class="deletemodal">
  <form class="modal-content" method="post" action="./deleteAccount.jsp" onsubmit="return deleteCheck();">
        <p style="text-align: center;"><span style="font-size: 20pt;">
        	<b><span style="font-size: 14pt;">탈퇴하기</span></b></span>
        	<button type="button" class="close-btn" onclick="closeModal('deletemodal');">X</button>
        </p>
        <div style="display:flex;flex-direction:column;align-items: baseline;">
         	<div style="width: 100%;margin-bottom: 20px;display: flex;align-items: flex-end;">
         		<div>비밀번호 확인:</div>
         		<input type="password" style="width: 73%;margin-left: auto;" name="deleteCheckPwd" id="deleteCheckPwd">
         	</div>
        </div>
        <button class="submit-btn" type="submit">
            <span class="pop_bt" style="font-size: 13pt;" >
                 탈퇴하기
            </span>
        </button>
  </form>
</div>