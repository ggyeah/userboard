<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%  
	// 세션 유효성 검사 로그인 되어있지 않으면 들어올 수 없음
   	if(session.getAttribute("loginMemberId") == null) {
	response.sendRedirect(request.getContextPath()+"/home.jsp");
	return;
	}

	//요청값 저장
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	
	//디버깅
	System.out.println(loginMemberId + " <-- modifyComment loginMemberId");
	System.out.println(commentNo + " <-- modifyComment commentNo"); 
	
	// db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 수정폼에 출력할 댓글 데이터 가져오기
	PreparedStatement commentListStmt = null;
	ResultSet commentListRs = null;
	String commentListSql = "SELECT member_id memberID, comment_content commentContent, createdate, updatedate FROM comment WHERE comment_no = ?";
	commentListStmt = conn.prepareStatement(commentListSql);
	commentListStmt.setInt(1, commentNo);

	commentListRs = commentListStmt.executeQuery(); 
	
	
	Comment c = new Comment();
	if(commentListRs.next()) {
		c.setCommentContent(commentListRs.getString("commentContent"));
		c.setMemberId(commentListRs.getString("memberId"));
		c.setCreatedate(commentListRs.getString("createdate"));
		c.setUpdatedate(commentListRs.getString("updatedate"));
	}
	

%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>modifyBoard</title>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/main.css" />
</head>
<body class="is-preload">
					<header id="header">
						<span class="logo"><strong>userboard</strong> 						 <%
						     if(session.getAttribute("loginMemberId") != null) { // 로그인 상태여야만 게시글 추가가 보임
						 %>
						     <a href="<%=request.getContextPath()%>/board/addBoard.jsp" class="button small">+ 게시글 추가</a>
						 <%
						      	}
						  %></span>
						   <div>
						      <jsp:include page="/inc/mainmenu.jsp"></jsp:include>
						   </div>
					</header>

   <%  if(session.getAttribute("loginMemberId") != null) { %>
	<form action="<%=request.getContextPath()%>/comment/modifyCommentAction.jsp?commentNo=<%=commentNo%>" method="post">
	<%
		if(request.getParameter("msg") != null) {
	%>
			<%=request.getParameter("msg")%>
	<%
		}
	%>
		<table class ="table">
			<tr>
				<td>댓글</td>
			<td><textarea rows="2" cols="80" name="commentContent"><%=c.getCommentContent()%></textarea></td>
			</tr>
			<tr>
				<td>작성자</td>
				<td><%=c.getMemberId()%></td>
			</tr>
			<tr>
				<td>작성일<td>
				<td><%=c.getCreatedate()%></td>
			</tr>
			<tr>
				<td>수정일</td>
				<td><%=c.getUpdatedate()%></td>
		</table>
		<% } %>
		<button type="submit" class="btn btn-danger">수정</button>
	</form>

</body>
</html>