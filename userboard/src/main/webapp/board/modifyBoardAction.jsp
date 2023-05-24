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

	//유효값 받아오기
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardContent = request.getParameter("boardContent");
	String boardTitle = request.getParameter("boardTitle");
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	String msg =null;
	
	//디버깅
	System.out.println(boardNo + " <- modifyBoardAction boardNo");
	System.out.println(boardContent + " <- modifyBoardAction boardContent");
	System.out.println(boardTitle + " <- modifyBoardAction boardTitle");
	System.out.println(loginMemberId + " <- modifyBoardAction loginMemberId");
	
	//null이나 공백의 수정이 되지 않도록
	if(request.getParameter("boardContent") == null
			||request.getParameter("boardContent") == "") {
		msg = URLEncoder.encode("내용을 입력하지 않았습니다","utf-8");
		response.sendRedirect(request.getContextPath() + "/board/modifyBoard.jsp?boardNo=" + boardNo + "&msg="+msg);
		return; 
	}else if(request.getParameter("boardTitle") == null
			||request.getParameter("boardTitle") == "") {
		msg = URLEncoder.encode("제목을 입력하지 않았습니다","utf-8");
		response.sendRedirect(request.getContextPath() + "/board/modifyBoard.jsp?boardNo=" + boardNo + "&msg="+msg);
		return; 
	}
	//db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 댓글입력 결과셋
	String modifyboardSql = "UPDATE board SET board_title = ?, board_content = ?, updatedate = now() WHERE board_no=? and member_id=?";
	PreparedStatement modifyboardStmt = conn.prepareStatement(modifyboardSql);
	modifyboardStmt.setString(1, boardTitle);
	modifyboardStmt.setString(2, boardContent);
	modifyboardStmt.setInt(3, boardNo);
	modifyboardStmt.setString(4, loginMemberId);
	System.out.println(modifyboardStmt + " <- modifyboardActionStmt");
	
	//영향받은 행
	int row = modifyboardStmt.executeUpdate();
	
	if(row == 0) { // 수정행이 0행
		System.out.println("수정에 실패하였습니다");
		response.sendRedirect(request.getContextPath() + "/home.jsp");		
		return;
		} else {
		response.sendRedirect(request.getContextPath() + "/home.jsp");	
		System.out.println("수정에 성공하였습니다");
		return;
		}
	
%>