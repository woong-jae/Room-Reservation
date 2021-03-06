<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<link rel="stylesheet" href="./style/modalStyle.css">
<script>
function rateCheck(){
	try{
		const score = document.querySelectorAll('input[type=radio]');
		
		let check = false;
		
		for(i=1; i<score.length; i++){
			if(score[i].checked){
				check = !check;
			}
		}
		
		if(!check){
			alert("평점을 선택해주세요.");
			return false;
		}
		
		const Rcomment = document.querySelector('textarea');
		if(Rcomment.value.length == 0){
			alert("내용을 적어주세요.");
			return false;
		};
		
		if(!confirm("평가는 수정, 삭제 할 수 없습니다. 등록하시겠습니까?")){
			return false;
		}
		
		Rcomment.value = Rcomment.value.replace(/'/g,"''");
		
		return true;
	}catch(error){
		console.log(error);
		return false;
	}
}
</script>
<style>
	.grid-layout{
		display:grid;
		grid-template-rows: 1fr 1fr 1fr 1fr 3fr 1fr;
	}
	
	input[type="radio"]{
		display:none;
	}
	
	label{
		background:lightgray;
		opacity:0.5;
		width:20px;
		height:20px;
		border-radius:25px;
		display:inline-block;
		text-align:center;
		font-size:0.85em;
		cursor:pointer;
	}
	
	input[type="radio"]:checked + label{
		background:#b41a1f;
		color:white;
		opacity:1.0;
	}
	
	.readonly-input{
		border:none;
		width:40px;
		font-size:17px;
	}
	
	.readonly-input:focus{
    	outline: none;
	}
	
	textarea{
		resize: none; 
		margin-bottom:15px;
		border-radius:5px;
	}
</style>

<div id="ratingModal" class="ratingmodal">
	<form class="modal-content grid-layout" method="post" onsubmit="return rateCheck()" action="./rating.jsp">
		<div style="text-align:center">
			<b>평가 작성</b>
			<button type="button" class="close-btn" onclick="closeRate('ratingmodal');">X</button>
		</div>
		<div>
			<b>방</b> : <input id="roomNo" class="readonly-input" type="text" name="roomNo" readonly>
		</div>
		<div>
			<b>이용시간</b> : <input id="startTime" class="readonly-input" type="text" name="startTime" readonly>~  <input id="endTime" class="readonly-input" type="text" name="endTime" readonly>
		</div>
		<div style="display:grid; grid-template-columns: 1fr 1fr;">
			<div>
				<b>평점 </b> :
				<input id="star1" type="radio" name="starRate" value="1">
				<label id="star1Label" for="star1">1</label>
				<input id="star2" type="radio" name="starRate" value="2">
				<label id="star2Label" for="star2">2</label>
				<input id="star3" type="radio" name="starRate" value="3">
				<label id="star3Label" for="star3">3</label>
				<input id="star4" type="radio" name="starRate" value="4">
				<label id="star4Label" for="star4">4</label>
				<input id="star5" type="radio" name="starRate" value="5">
				<label id="star5Label" for="star5">5</label>
			</div>
			<div style="text-align:right">
				<span id="byte-count">0</span><span> Bytes</span>
			</div>
		</div>
		<textarea spellcheck="false" name="comment" cols="50" rows="5")></textarea>
		<button class="submit-btn" type="submit">작성</button>
	</form>
</div>

<script>
	function closeRate(className){
		closeModal(className);
		const RComment = document.querySelector('textarea');
		RComment.value = "";
		const score = document.querySelectorAll('input[type=radio]');
		for(i=0; i<score.length; i++){
			score[i].checked = false;
		}
	}
	
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