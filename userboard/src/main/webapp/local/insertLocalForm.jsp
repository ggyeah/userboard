<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%
	response.setCharacterEncoding("utf-8");
	//세션 유효성 검사
	if (session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertLocalForm</title>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/home.css" />
</head>
<body class="is-preload">
	<header id="header">
		<span class="logo"><strong>userboard</strong> </span>
		   <div>
		      <jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		   </div>
	</header>

	<h2>새 카테고리 추가</h2>
	<form action="<%=request.getContextPath()%>/local/insertLocalAction.jsp" method="post">
	<% // 오류메세지 출력
		if(request.getParameter("msg") != null) {
	%>
		<div class="text-danger"> <%=request.getParameter("msg")%> </div>
	<%		
		}
	%>
		<table>
			<tr>
				<td>지역명</td>
				<td><input type="text" name="localName"></td>
				<td>
				<button type="submit" class="btn btn-danger"> 추가 </button>
				</td>
			</tr>
		</table>
	</form>
  <div>
      <jsp:include page="/inc/copyright.jsp"></jsp:include>
   </div>
</body>
</html>