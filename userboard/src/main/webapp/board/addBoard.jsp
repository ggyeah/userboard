<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addBoard</title>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/main.css" />
</head>
<body class="is-preload">
	<header id="header">
		<span class="logo"><strong>userboard</strong> </span>
		   <div>
		      <jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		   </div>
	</header>
     <%
     if(session.getAttribute("loginMemberId") != null) { // 로그인을 해야 추가폼 출력
     %>
     <h2>목록추가</h2>
		<% // 오류메세지 출력
			if(request.getParameter("msg") != null) {
		%>
				<div class='text-danger'><%=request.getParameter("msg")%></div>
		<%		
			}
		%>
	<form action="<%=request.getContextPath()%>/board/addBoardAction.jsp" method="post">
		<table>
			<tr>
				<td>카테고리</td>
				<td><input type="text" name="localName"></td>
			</tr>
			<tr>
				<td>제목</td>
				<td><input type="text" name="boardTitle"></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><input type="text" name="boardContent"></td>
			</tr>
			<tr>
		</table>
		<button type="submit" class="btn btn-danger">추가</button>
	  </form>
	 	<%   
		         }
		%>
</body>
</html>