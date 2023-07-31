<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	//1. 요청분석 (컨트롤러 계층)
	if(request.getParameter("boardNo") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return; // 1) 코드진행종료 2) 반환값을 남길때
	}

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	//댓글현재패이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	//페이지당 출력할 행의 수
	int rowPerPage = 5;
	//시작행번호
	int startRow = (currentPage-1)*rowPerPage;
	
	
	//2. 모델계층
	//db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//2-1) board one 결과셋------------------------------------------
	PreparedStatement boardoneStmt = null;
	ResultSet boardoneRs = null;
	String boardoneSql =  "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberID, createdate, updatedate FROM board WHERE board_no=?";
	boardoneStmt = conn.prepareStatement(boardoneSql);
	boardoneStmt.setInt(1, boardNo);
	
	System.out.println(boardoneStmt + " <-- boardoneStmt");
	
	boardoneRs = boardoneStmt.executeQuery(); //row -> 1 -> Board타입
	
	Board board = null;
	
	if(boardoneRs.next()) {
		board = new Board();
		board.setBoardNo(boardoneRs.getInt("boardNo"));
		board.setLocalName(boardoneRs.getString("localName"));
		board.setBoardTitle(boardoneRs.getString("boardTitle"));
		board.setBoardContent(boardoneRs.getString("boardContent"));
		board.setMemberId(boardoneRs.getString("memberId"));
		board.setCreatedate(boardoneRs.getString("createdate"));
		board.setUpdatedate(boardoneRs.getString("updatedate"));
	}
	
	//2-2) insert 결과셋---------------------------------------
	//2-3) comment list 결과셋---------------------------------------
	/*SELECT comment_no, board_no, comment_content
	FROM COMMENT
	WHERE board_no = 1000
	LIMIT 0 , 10;*/
	PreparedStatement commentListStmt = null;
	ResultSet commentListRs = null;
	String commentListSql = "SELECT comment_no commentNo, member_id memberID, board_no boardNo, comment_content commentContent, createdate, updatedate FROM COMMENT WHERE board_no=? LIMIT ?, ?";
	commentListStmt = conn.prepareStatement(commentListSql);
	commentListStmt.setInt(1, boardNo);
	commentListStmt.setInt(2, startRow);
	commentListStmt.setInt(3, rowPerPage);
	
	commentListRs = commentListStmt.executeQuery(); 
	
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	
	while(commentListRs.next()) {
		Comment c = new Comment();
		c.setCommentNo(commentListRs.getInt("commentNo"));
		c.setCommentContent(commentListRs.getString("commentContent"));
		c.setMemberId(commentListRs.getString("memberId"));
		c.setCreatedate(commentListRs.getString("createdate"));
		c.setUpdatedate(commentListRs.getString("updatedate"));
		commentList.add(c);
	}

	//디버깅
 	System.out.println(commentList);
 	System.out.println(commentList.size());
 	
 // -------------------------페이징--------------------------
    // select count(*) from notice
    PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	String sql2 = "SELECT count(*) FROM comment WHERE board_no = ?";
    stmt2 = conn.prepareStatement(sql2);
    stmt2.setInt(1, boardNo);
    
    rs2 = stmt2.executeQuery(); 

    int totalRow = 0; // SELECT COUNT(*) FROM notice;
    
    if(rs2.next()) {
       totalRow = rs2.getInt("count(*)");
    }
    
    int lastPage = totalRow / rowPerPage;
    if(totalRow % rowPerPage != 0 || lastPage == 0) {
      lastPage = lastPage + 1;
    }

	//3. 뷰 계층
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>boardOne</title>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/main.css" />
</head>
<body class="is-preload">
	<div id="main">
		<div class="inner">
		<header id="header">
			<span class="logo"><strong>userboard</strong> 						
			 <%
			     if(session.getAttribute("loginMemberId") != null) { // 로그인 상태여야만 게시글 추가가 보임
			 %>
			     <a href="<%=request.getContextPath()%>/board/addBoard.jsp" class="button small">+ 게시글 추가</a>
			 <%
			      	}
			  %>
			 </span>
			   <div>
			      <jsp:include page="/inc/mainmenu.jsp"></jsp:include>
			   </div>
		</header>
	<div class = "container">
<!---------------------------3-1 [시작] board one 결과셋--------------------- -->
	<h2>상세보기</h2>
			<table class ="table">
	            <tr>
	               <th class="table-secondary">번호</th>
	               <td><%=board.getBoardNo()%></td>
	            </tr>
	            <tr>
	               <th class="table-secondary">카테고리</th>
	               <td><%=board.getLocalName()%></td>
	            </tr>
	            <tr>
	               <th class="table-secondary">제목</th>
	               <td><%=board.getBoardTitle()%></td>
	            </tr>
	            <tr>
	               <th class="table-secondary">내용</th>
	               <td><%=board.getBoardContent()%></td>
	            </tr>
	            <tr>
	               <th class="table-secondary">작성자</th>
	               <td><%=board.getMemberId()%></td>
	            </tr>
	            <tr>
	               <th class="table-secondary">작성일</th>
	               <td><%=board.getCreatedate()%></td>
	            </tr>
	            <tr>
	               <th class="table-secondary">수정일</th>
	               <td><%=board.getUpdatedate()%></td>
	            </tr>
			</table>
			<% // 본인이 작성한 게시글만 수정,삭제허용
			if (session.getAttribute("loginMemberId") != null) {
			    // 현재 로그인 사용자의 아이디
			    String loginMemberId = (String) session.getAttribute("loginMemberId");
			
			    if (loginMemberId.equals(board.getMemberId())) {
			%>
			<div>
	             <a href="<%=request.getContextPath()%>/board/modifyBoard.jsp?boardNo=<%=boardNo%>" class="btn btn-outline-danger">수정</a>
				 <a href="<%=request.getContextPath()%>/board/removeBoard.jsp?boardNo=<%=boardNo%>" class="btn btn-outline-danger">삭제</a>
			</div>
			<%
					} 
				}
			%>
<!---------------------------3-2 [시작] comment 입력 --------------------- -->
		<% // 로그인 사용자만 수정,삭제,댓글입력허용
		if(session.getAttribute("loginMemberId") != null) {
			// 현재 로그인 사용자의 아이디
			String loginMemberId = (String)session.getAttribute("loginMemberId");
		%>
			<form action="<%=request.getContextPath()%>/comment/insertCommentAction.jsp">
				<input type="hidden" name="boardNo" value="<%=board.getBoardNo()%>">
				<input type="hidden" name="loginMemberId" value="<%=loginMemberId%>">
				<table  class ="table">
					<tr>
						<th>commentContent</th>
						<td>
							<textarea rows="2" cols="80" name="commentContent"></textarea>
						<td>
						<button type="submit" class="btn btn-outline-dark">댓글입력</button>
					</tr>
				</table>
			</form>
		<%
			} 
		%>
<!--------------------------- 3-3 [시작] comment list 결과셋----------- -->

	<table class ="table">
			<tr class="table-secondary">
				<th>댓글</th>
				<th>작성자</th>
				<th>작성일</th>
				<th>수정일</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
		<%
			for(Comment c : commentList) {
	 	%>
            <tr>	
               <td><%=c.getCommentContent()%></td>
               <td><%=c.getMemberId()%></td>
               <td><%=c.getCreatedate()%></td>
               <td><%=c.getUpdatedate()%></td>
             <% // 본인이 작성한 댓글만 수정,삭제허용
			if (session.getAttribute("loginMemberId") != null) {
			    // 현재 로그인 사용자의 아이디
			    String loginMemberId = (String) session.getAttribute("loginMemberId");
			
			    if (loginMemberId.equals(c.getMemberId())) {
			%>
               <td><a href="<%=request.getContextPath()%>/comment/modifyComment.jsp?commentNo=<%=c.getCommentNo()%>" class="btn btn-outline-danger">수정</a></td>
			   <td><a href="<%=request.getContextPath()%>/comment/removeCommentAction.jsp?commentNo=<%=c.getCommentNo()%>" class="btn btn-outline-danger">삭제</a></td>
           	<%
					} 
				}
			%>
            </tr>
	<%	
			}
		%>
	</table>
			<% if(currentPage > 1) {%>
			<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>" class="btn btn-outline-dark">
				이전
			</a>
			<% } %>
			<%=currentPage%>
			<% if( currentPage < lastPage) {%>
			<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>" class="btn btn-outline-dark">
				다음
			</a>
			<% } %>
		</div>
		<div>
	      <jsp:include page="/inc/copyright.jsp"></jsp:include>
	   </div>
	</div>
</div>
</body>
</html>