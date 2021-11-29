<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>매니저 페이지</title>
<link rel="icon" href="./image/favicon.png">
<link rel="stylesheet" href="./style/globalStyle.css">
<link rel="stylesheet" href="./style/modalStyle.css">
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
	.manage-modal {
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
	#managerPage-background {
		display: flex;	
		justify-content: center;
	}
	#managerPage-wrapper {
		display: flex;	
    	flex-direction: column;
		justify-content: space-evenly;
		align-items: center;
		width: 80%;
	}
	.manager-contents {
		margin: 70px 0 30px 0;
	    padding: 20px;
	    height: fit-content;
	    border: 1px solid lightgray;
	}
	#manager-info {
		justify-content: space-around;
		width: 500px;
		display: flex;
    	border-top: 1px solid;
    	padding-top: 20px;
	}
	#manage-contents {
		display: flex;
	    width: 800px;
	    justify-content: space-evenly;
	}
	.manage-room {
	    border: 1px solid lightgray;
		margin: 30px 0 30px 0;
	    padding: 20px;
	    display: flex;
    	flex-direction: column;
	    max-width: 1000px;
   		max-height: 400px;
   		justify-content: space-around;
	}
	.manage-room-insert {
    	height: 50px;
	    font-size: 1em;
	}
	.manage-room-delete {
    	height: 50px;
	    background: #b41a1f;
	    font-size: 1em;
	}
	.manage-room-delete:hover {
		background: #951418;
	}
	.manage-room-elem{
		display: flex;
    	justify-content: flex-start;
    	height: 85%;
    	border-top: 1px solid;
    	overflow-y: auto;
    	flex-wrap: wrap;
	}
	.room-elem {
		margin: 9px;
    	background: aliceblue;
    	cursor: pointer;
    	text-align: center;
    	width: 105px;
    	padding: 5px;
    	color: black;
	}
	.room-elem:hover {
		background: #9ecbf2;
	}
	.clicked {
        background: #9ecbf2;
       	box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
     }
</style>
</head>
<body>
<%@ include file="./connectDB.jsp" %>
<%!
	String ManagerId = "";
	String RoomNumber = "";
%>
<%
	try {
		ManagerId = session.getAttribute("managerid").toString();
	} catch (Exception e) {
		out.println("<script>location.href='./';</script>");
	}
%>

<%@ include file="./navbar.jsp" %>
<div id="title">관리자 페이지</div>
<div id="managerPage-background">
	<div id="managerPage-wrapper">
		<div class="manager-contents">
			<h3 style="text-align:center;margin-top: 0;">내 정보</h3>
			<div id="manager-info">
				<div><span style="font-weight: bold;">아이디 :&nbsp;&nbsp;&nbsp;</span><%= ManagerId  %></div>
				<div><button id="pwd-btn" onclick="openModal('modal');">비밀번호 변경</button></div>
				<jsp:include page="./changePwdModal.jsp" />
			</div>
		</div>
		<div id="manage-contents">
			<div class="manage-room">
				<h3 style="text-align:center;margin-top: 0;">강의실 관리</h3>
				<div class="manage-room-elem">
					<%
						String sql = "SELECT RoomNumber"
								+ " FROM ROOM"
								+ " ORDER BY RoomNumber";
						try{
							rs = stmt.executeQuery(sql);
							int count = 0;
							while(rs.next()){
								count += 1;
								out.println("<button class='room-elem' name='"+rs.getString(1)+"'>");
								out.println(rs.getString(1)+"</button>");
							}
							if (count == 0) {
								out.println("<div style='width:100%;text-align: center;'>등록된 강의실이 없습니다.</div>");
							}
							rs.close();
						} catch (SQLException e) {
							System.err.println("sql error = " + e.getMessage());
						}
					%>
				</div>
				<div style="display: flex;justify-content: space-evenly;margin-top:30px;">
					<button class="manage-room-insert" onclick="openManageModal('room-insert');">강의실 추가</button>
					<button class="manage-room-delete" onclick="openManageModal('room-delete');">강의실 삭제</button>
					<div style="width: 1px;background: black;"></div>
					<button class="manage-room-insert" onclick="openManageModal('timeline-insert');">시간대 추가</button>
					<button class="manage-room-delete" onclick="openManageModal('timeline-delete');">시간대 삭제</button>
				</div>
				<jsp:include page="./roomManageModal.jsp" />
			</div>
		</div>
	</div>
</div>
<%@ include file="./footer.jsp" %>
<script type="text/javascript">	
	function openModal(className) {
		var elems = document.getElementsByClassName(className);
		console.log(className, elems, elems.length);
		for (var i=0;i<elems.length;i+=1){
			elems[i].style.display = 'block';
		}
	}

   var room = document.getElementsByClassName("room-elem");
   function handleClick(event) {
     if (event.target.classList[1] === "clicked") {
       event.target.classList.remove("clicked");
       history.pushState(null, '', './managerPage.jsp')
     } else {
       for (var i = 0; i < room.length; i++) {
    	   room[i].classList.remove("clicked");
       }
       event.target.classList.add("clicked");
   	   history.pushState(event.target.name, '', './managerPage.jsp')
     }
   }
   function init() {
     for (var i = 0; i < room.length; i++) {
    	 room[i].addEventListener("click", handleClick);
     }
   }

   init();
</script>
</body>
</html>