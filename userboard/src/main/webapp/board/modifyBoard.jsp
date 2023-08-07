<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%  
	//인코딩 처리 // 한글이 깨지지 않도록
	request.setCharacterEncoding("UTF-8"); 
	response.setCharacterEncoding("utf-8");
	
	// 세션 유효성 검사 로그인 되어있지 않으면 들어올 수 없음
   	if(session.getAttribute("loginMemberId") == null) {
	response.sendRedirect(request.getContextPath()+"/home.jsp");
	return;
	}

	//요청값 저장
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	// db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 수정폼에 출력할 board 데이터 가져오기
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
<title>modifyBoard</title>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/home.css" />
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
	</header>>
	<form action="<%=request.getContextPath()%>/board/modifyBoardAction.jsp?boardNo=<%=boardNo%>" method="post">

		<table>
			<% // 오류메세지 출력
			if(request.getParameter("msg") != null) {
			%>
				<%=request.getParameter("msg")%>
			<%		
				}
			%>
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
				<td><input type="text" value="<%=b.getBoardTitle()%>" name="boardTitle"></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><textarea rows="2" cols="80" name="boardContent"><%=b.getBoardContent()%></textarea></td>
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
		<button type="submit" class="btn btn-danger">수정</button>
	</form>

</body>
</html>