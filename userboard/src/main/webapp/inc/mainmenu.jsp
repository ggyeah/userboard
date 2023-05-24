<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
<link rel="stylesheet" href="assets/css/main.css" />

		<a href = "<%=request.getContextPath()%>/home.jsp" class="button small">홈으로</a>
		<!--
			  로그인전 : 회원가입
		 	  로그인후 : 회원정보 / 로그아웃 (로그인정보 세션 loginMemverId
		 -->
		 <% 
		 	if(session.getAttribute("loginMemberId") == null) { //로그인전
		 %>
		 	<a href = "<%=request.getContextPath()%>/member/insertMemberForm.jsp" class="button small" >회원가입</a>
		 	<a href = "<%=request.getContextPath()%>/local/localList.jsp" class="button small">카테고리</a>
		 <%
		 	} else { // 로그인후
		 %>
		<a href = "<%=request.getContextPath()%>/member/memberOne.jsp" class="button small">회원정보</a>
		<a href = "<%=request.getContextPath()%>/member/logoutAction.jsp" class="button small">로그아웃</a>
		<a href = "<%=request.getContextPath()%>/local/localList.jsp" class="button small">카테고리</a>
	
		<%} %>