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

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String msg =null;
	// 오류메세지 출력
	
	if(request.getParameter("rememberId") == null
			||request.getParameter("rememberId").equals("")) {
		msg = URLEncoder.encode("작성자 확인이 입력되지 않았습니다", "utf-8");
		response.sendRedirect(request.getContextPath() +"/board/removeBoard.jsp?boardNo=" + boardNo + "&msg="+msg);
		return;
	}

	//요청값
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	String rememberId = request.getParameter("rememberId");
	
	//디버깅
	System.out.println(loginMemberId + " <- removeBoardAction loginMemberId");
	System.out.println(boardNo + " <- removeBoardAction boardNo");
	System.out.println(rememberId + " <- removeBoardAction memberId");

	
	// 작성자 입력과 세션작성자 동일 여부 확인
	if(!loginMemberId.equals(rememberId)) {
		msg = URLEncoder.encode("작성자확인이 틀렸습니다", "utf-8"); 
		response.sendRedirect(request.getContextPath() + "/board/removeBoard.jsp?boardNo=" + boardNo + "&msg="+msg);
		return;
	}
	
	//db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//1) 게시글 삭제 
	PreparedStatement removeBoardStmt = null;
	ResultSet removeBoardRs = null;
	String removeBoardSql =  "delete from board where board_no= ? and member_id = ?";
	removeBoardStmt = conn.prepareStatement(removeBoardSql);
	removeBoardStmt.setInt(1, boardNo);
	removeBoardStmt.setString(2, loginMemberId);
	
	System.out.println(removeBoardStmt + " <-- removeBoardStmt");
	
	//Rs = memberStmt.executeQuery(); //이게 들어가면 안됨
	
	int row = removeBoardStmt.executeUpdate();
	if(row == 0) { 
		System.out.println(row + " <- 삭제실패"); 
		response.sendRedirect(request.getContextPath() + "/board/removeBoard.jsp?boardNo" + boardNo);
		return;
		} else {
		      response.sendRedirect(request.getContextPath()+"/home.jsp");
		      System.out.println(row + " <- 삭제성공");
		}
%>
