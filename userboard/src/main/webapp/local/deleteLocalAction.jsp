<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%
	//세션 유효성 검사 
	response.setCharacterEncoding("utf-8");
	//세션 유효성 검사 로그인상태가 아니면 들어올 수 없음
	if (session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
	//세션 유효성 검사 
	if(request.getParameter("localName")==null
		||request.getParameter("localName")==""){
		response.sendRedirect(request.getContextPath()+"/category/categoryOne.jsp");
		return;
	}

	String localName = request.getParameter("localName");

	//db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	//1) board 에서 참조중인지 확인 하는 실행문 ------------------------------------------

	String sql = "select count(*) from board where local_name = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, localName);
	
	ResultSet rs = stmt.executeQuery();
	int cnt = 0;
	if(rs.next()){
		cnt = rs.getInt("count(*)");
	}
	
	// 오류메세지
	String msg = null;
	if(cnt != 0){
		msg = URLEncoder.encode("board에서 사용중이므로 삭제할 수 없습니다", "utf-8");
		localName = URLEncoder.encode(localName, "utf-8");
		response.sendRedirect(request.getContextPath()+"/local/deleteLocalForm.jsp?localName="+localName+"&msg="+msg);
		return;
	}
	
	
	//2) 삭제 쿼리 실행문 ---------------------------------------------------------

	String deleteSql = "DELETE FROM local WHERE local_name = ?";
	PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
	deleteStmt.setString(1, localName);
	System.out.println(deleteStmt + " <- deleteLocalAction Stmt");
	
	int row = deleteStmt.executeUpdate();
	
	if (row == 1){
		System.out.println(row + " <- 카테고리 삭제성공");
	} else {
		System.out.println(row + " <- 카테고리 삭제실패");
	}
	
	response.sendRedirect(request.getContextPath() + "/local/localList.jsp");
%>