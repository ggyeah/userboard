<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	//세션 유효성 검사 로그인이 되어있지 않으면 들어올 수 없음
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	

	//요청값
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	//디버깅
	System.out.println(loginMemberId + " <- loginMemberId");
	System.out.println(commentNo + " <- commentNo");
	
	
	//db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 댓글삭제 쿼리문 
	PreparedStatement romoveCommentStmt = null;
	ResultSet romoveCommentRs = null;
	String romoveCommentSql =  "DELETE FROM comment WHERE member_id = ? and comment_no =?";
	romoveCommentStmt = conn.prepareStatement(romoveCommentSql);
	romoveCommentStmt.setString(1, loginMemberId);
	romoveCommentStmt.setInt(2, commentNo);
	
	System.out.println(romoveCommentStmt + " <-- romoveCommentStmt");
	
	//romoveCommentRs = romoveCommentStmt.executeQuery(); //이게 들어가면 안됨
	
	int row = romoveCommentStmt.executeUpdate();
	if(row == 0) { // 삭제행이 0행
		System.out.println(row + " <- 삭제실패"); 
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
		} else {
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
		System.out.println(row + " <- 삭제성공");
		return;
}

%>