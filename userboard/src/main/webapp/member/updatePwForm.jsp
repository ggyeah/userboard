<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%  
	// 세션 유효성 검사 로그인 되어있지 않으면 들어올 수 없음
   	if(session.getAttribute("loginMemberId") == null) {
	response.sendRedirect(request.getContextPath()+"/home.jsp");
	return;
	}

	String loginMemberId = (String)session.getAttribute("loginMemberId");
%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updatePwForm</title>
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
   
	<form action="./updatePwAction.jsp" method="post">
	<h2>비밀번호 수정</h2>
		<table class="table table-bordered ">
		<%
		if(request.getParameter("msg") != null) {
		%>
			 <%=request.getParameter("msg")%>
		<%
			}
		%>
			<tr>
				<td  class="table-secondary">
					현재비밀번호
				</td>
				<td>
					<input type="password" name="memberPw"> 
				</td>
			</tr>
			<tr>
				<td  class="table-secondary">
					새 비밀번호
				</td>
				<td>
					<input type="password" name="memberPw1"> 
				</td>
			</tr>
			<tr>
				<td class="table-secondary"> 
					새 비밀번호 확인
				</td>
				<td>
					<input type="password" name="memberPw2"> 
				</td>
			</tr>
			<tr>
				 <td colspan="2">
	              <button type="submit" class="btn btn-danger">수정</button>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>