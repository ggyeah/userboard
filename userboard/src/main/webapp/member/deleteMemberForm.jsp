<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%   
	//세션 유효성 검사 로그인이 되어있지 않으면 들어올 수 없음
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
<title>회원탈퇴</title>
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
   
	<h2>회원탈퇴</h2>
	<%
		if(request.getParameter("msg") != null) {
	%>
			<%=request.getParameter("msg")%>
	<%
		}
	%>
	<form action="<%=request.getContextPath()%>/member/deleteMemberAction.jsp" method="post">
	<table class ="table">
		<tr>
			<td  class="table-secondary">번호</td>
	        <td>
	        	<input type="text" name="memberId" value="<%=loginMemberId%>" readonly="readonly">
	       		 <!-- hidden : 안보여서 수정할 수 없다 // 보이지만 수정할수 없다 readonly="readonly"-->
	        </td>
		</tr>
		<tr>
			<td  class="table-secondary">비밀번호</td>
	        <td>
	       	 <input type="password" name="memberPw">
	        </td>
		</tr>
		<tr>
	         <td colspan="2">
	              <button type="submit" class="btn btn-danger">삭제</button>
			</td>
		</tr>
		
	</table>
	</form>

</body>
</html>