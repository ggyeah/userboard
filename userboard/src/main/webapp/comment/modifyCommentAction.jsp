<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	// request 인코딩 설정// 글씨가 깨지지 않도록함
	request.setCharacterEncoding("UTF-8");

	//로그인상태가 아니면 들어올수없음
	if(session.getAttribute("loginMemberId") == null) {
	response.sendRedirect(request.getContextPath()+"/home.jsp");
	return;
	}
	
	// 요청값 변수선언
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentContent = request.getParameter("commentContent");
	
	//디버깅
	System.out.println(loginMemberId + " <-- modifyCommentAction loginMemberId");
	System.out.println(commentNo + " <-- modifyCommentAction commentNo");
	
	
	//댓글이 null 이거나 공백으로 넘어오면 다시 되돌아감
	String msg = null;  
	if(request.getParameter("commentContent") == null
		||request.getParameter("commentContent").equals("")){
		msg = URLEncoder.encode("비밀번호가 입력되지 않았습니다", "utf-8");	
		response.sendRedirect(request.getContextPath() +"/comment/modifyComment.jsp?commentNo=" + commentNo + "&msg="+msg);
		return;
		}
	System.out.println(commentContent + " <-- modifyCommentAction commentContent");
	//db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 비밀번호 수정 쿼리문
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql =  "UPDATE comment SET comment_content = ? , updatedate = now() WHERE member_id=? and comment_no= ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, commentContent);
	stmt.setString(2, loginMemberId);
	stmt.setInt(3, commentNo);
	System.out.println(stmt + " <-- modifyCommentStmt");
	
	//영향받은 행값
	int row = stmt.executeUpdate();
	
	if(row == 0) { //수정행이 0행 수정실패
		response.sendRedirect(request.getContextPath() + "/comment/modifyComment.jsp?commentNo=" + commentNo);
		System.out.println("댓글수정에 실패하였습니다");
		return;
		} else {
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
		System.out.println("댓글수정에 성공하였습니다ㄴ");
		return;
		}
%>