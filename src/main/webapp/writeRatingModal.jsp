<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<link rel="stylesheet" href="./style/modalStyle.css">

<style>
	.grid-layout{
		display:grid;
		grid-template-rows: 1fr 1fr 3fr 1fr;
	}
	
	input[type="radio"]{
		display:none;
	}
	
	label{
		background:lightgray;
		width:25px;
		height:25px;
		border-radius:25px;
	}
	
	input[type="radio"]:checked + label{
		background:#b41a1f;
		color:white;
	}
</style>

<div id="ratingModal" class="ratingmodal">
	<form class="modal-content grid-layout" method="post" actions="./">
		<div style="text-align:center">
			<b>평가 작성</b>
			<button type="button" class="close-btn" onclick="closeModal('ratingmodal');">X</button>
		</div>
		<div style="text-align:center; display:grid; grid-template-columns: 1fr 1fr 1fr 1fr 1fr;">
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
		<textarea cols="50" rows="5" style="resize: none;" placeholder="제작중..."></textarea>
		<input class="submit-btn" type="submit" value="작성">
	</form>
</div>