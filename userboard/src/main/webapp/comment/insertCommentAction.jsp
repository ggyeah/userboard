<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import = "java.net.*" %>
    <%@ page import = "java.sql.*" %>
    <%@ page import = "vo.*" %>
<%
	// 세션 유효성검사  로그인이 되어있지 않으면 댓글을 남길수 없음
	if (request.getParameter("boardNo") == null
				|| request.getParameter("loginMemberId") == null){
			response.sendRedirect(request.getContextPath() + "/home.jsp");
			return;
	}

	//유효값 받아오기
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentContent = request.getParameter("commentContent");
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	//null이나 공백의 댓글이 입력되지 않도록
	if(request.getParameter("commentContent") == null
			||request.getParameter("commentContent") == "") {
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo);	
		return; // 1) 코드진행종료 2) 반환값을 남길때
	}
	
	//db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 댓글입력 결과셋
	String insertCommentSql = "INSERT INTO COMMENT(board_no, comment_content, member_id, createdate, updatedate) value(?, ?, ?, NOW(), NOW())";
	PreparedStatement insertCommentStmt = conn.prepareStatement(insertCommentSql);
	insertCommentStmt.setInt(1, boardNo);
	insertCommentStmt.setString(2, commentContent);
	insertCommentStmt.setString(3, loginMemberId);
	System.out.println(insertCommentStmt + " <- insertCommentAction insertCommentStmt");
	int row = insertCommentStmt.executeUpdate();
	System.out.println(row + " <- insertCommentAction row");
	
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo);	
%>