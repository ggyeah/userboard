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
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	//db 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 1) 삭제전 보여주는 기존데이터
	PreparedStatement modifyBoardStmt = null;
	ResultSet modifyBoardRs = null;
	String modifyBoardSql = "SELECT board_no boardNO, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board WHERE board_no = ? and member_id = ? ";
	modifyBoardStmt = conn.prepareStatement(modifyBoardSql);
	modifyBoardStmt.setInt(1, boardNo);
	modifyBoardStmt.setString(2, loginMemberId);
	System.out.println(modifyBoardStmt + " <- modifyBoardStmt stmt");
	modifyBoardRs = modifyBoardStmt.executeQuery();
	
	Board b = new Board();
	if(modifyBoardRs.next()){
		b.setBoardNo(modifyBoardRs.getInt("boardNo"));
		b.setLocalName(modifyBoardRs.getString("localName"));
		b.setBoardTitle(modifyBoardRs.getString("boardTitle"));
		b.setBoardContent(modifyBoardRs.getString("boardContent"));
		b.setMemberId(modifyBoardRs.getString("memberId"));
		b.setCreatedate(modifyBoardRs.getString("createdate"));
		b.setUpdatedate(modifyBoardRs.getString("updatedate"));
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateNoticeForm</title>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/main.css" />
</head>
<body>
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
	<div class = "container"> 
	     <!--  삭제전 기존데이터 보여주기 -->
	     <table  class="table table-bordered ">
			<tr>
				<td>게시글번호</td>
				<td><%=b.getBoardNo()%></td>
			</tr>
			<tr>
				<td>지역이름</td>
				<td><%=b.getLocalName()%></td>
			</tr>
			<tr>
				<td>제목</td>
				<td><%=b.getBoardTitle()%></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><%=b.getBoardContent()%></td>
			</tr>
			<tr>
				<td>아이디</td>
				<td><%=b.getMemberId()%></td>
			</tr>
			<tr>
				<td>작성일</td>
				<td><%=b.getCreatedate()%></td>
			</tr>
			<tr>
				<td>수정일</td>
				<td><%=b.getUpdatedate()%></td>
			</tr>
		</table>
		<form action= "<%=request.getContextPath()%>/board/removeBoardAction.jsp?boardNo=<%=boardNo%>" method="post">
		<h2>게시글삭제</h2>
			<table  class="table table-bordered ">
		<% // 오류메세지 출력
		if(request.getParameter("msg") != null) {
		%>
			<%=request.getParameter("msg")%>
		<%		
			}
		%>
			<tr> 
				<td>작성자 확인</td>
		        <td>
		       	 <input type="text" name="rememberId">
		        </td>
			</tr>
			<tr>
		         <td colspan="2">
		              <button type="submit" class="btn btn-danger">삭제</button>
				</td>
			</tr>
		</table>
	</form>
</div>
</body>
</html>