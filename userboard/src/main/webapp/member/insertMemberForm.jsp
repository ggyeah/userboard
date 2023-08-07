<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertMemberForm</title>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/home.css" />
</head>
<body class="is-preload">
<div id="main">
	<div class="inner">
		<header id="header">
			<span class="logo"><strong>userboard</strong> </span>
			   <div>
			      <jsp:include page="/inc/mainmenu.jsp"></jsp:include>
			   </div>
		</header>
  	<%
         if(session.getAttribute("loginMemberId") == null) { // 로그인전이여야 회원가입폼출력
 	 %>
 	 <div class="center">
	<h2>회원가입</h2>
	<% // 오류메세지 출력
		if(request.getParameter("msg") != null) {
	%>
			<%=request.getParameter("msg")%>
	<%		
		}
	%>
	<form action="<%=request.getContextPath()%>/member/insertMemberAction.jsp" method="post">
		<table style="width:40%">
			<tr>
				<td>아이디</td>
				<td><input type="text" name="memberId"></td>
			</tr>
			<tr>
				<td>패스워드</td>
				<td><input type="password" name="memberPw"></td>
			</tr>
		</table>
		<button type="submit" class="button">회원가입</button>
	</form>
	  <%   
	         }
	  %>
	</div>  
		<div>
	      <jsp:include page="/inc/copyright.jsp"></jsp:include>
	   </div>
   </div>
</div>
	<!-- Scripts -->
	<script src="assets/js/jquery.min.js"></script>
	<script src="assets/js/browser.min.js"></script>
	<script src="assets/js/breakpoints.min.js"></script>
	<script src="assets/js/util.js"></script>
	<script src="assets/js/main.js"></script>
   
</body>
</html>