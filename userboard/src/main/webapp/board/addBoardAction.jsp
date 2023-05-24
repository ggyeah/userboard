<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	//세션 유효성 검사 로그인이 되어있지 않으면 들어올 수 없음
	if (session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	//null이나 공백의 댓글이 입력되지 않도록
	if(request.getParameter("localName") == null
		||request.getParameter("localName").equals("")
		||request.getParameter("boardTitle") == null
		||request.getParameter("boardTitle").equals("")
		||request.getParameter("boardContent") == null
		||request.getParameter("boardContent").equals("")) {
		response.sendRedirect(request.getContextPath() +  "/home.jsp");	
		return; // 1) 코드진행종료 2) 반환값을 남길때
	}
	//유효값 받아오기
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String msg =null;
	
	//디버깅
	System.out.println(loginMemberId + " <-- addboardAction loginMemberId");
	System.out.println(localName + " <-- addboardAction localName");
	System.out.println(boardTitle + " <-- addboardAction boardTitle");
	System.out.println(boardContent + " <-- addboardAction boardContent");
	
	
	//db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	/* 1) board에 존재하는 카테고리 인지 확인*/
	String sql = "SELECT count(*) FROM board WHERE local_name = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,localName);
	System.out.println(stmt + "<- board 카테고리 유무확인");
	ResultSet rs = stmt.executeQuery();
	// 중복되는 local_name이 있으면 cnt 카운트가 오른다
	int cnt = 0;
	    if (rs.next()) {
	        cnt = rs.getInt("count(*)");
	    }
	
    // 중복된 local_name이값이 없으면 에러메세지 출력
    if (cnt <= 0) { //중복된 값이 없는경우
    	System.out.println("카테고리에 존재하지 않는 지역이름 입니다");
    	msg = URLEncoder.encode("카테고리에 존재하지 않는 지역이름입니다","utf-8");
        response.sendRedirect(request.getContextPath()+"/board/addBoard.jsp?msg="+msg);
        return;
    }


	/* 2) 게시글 추가 */
	String addBoardSql = "INSERT INTO board(local_name, board_title, board_content, member_id, createdate, updatedate) value(?, ?, ?, ?, NOW(), NOW())";
	PreparedStatement addBoardStmt = conn.prepareStatement(addBoardSql);
	addBoardStmt.setString(1, localName);
	addBoardStmt.setString(2, boardTitle);
	addBoardStmt.setString(3, boardContent);
	addBoardStmt.setString(4, loginMemberId);
	System.out.println(addBoardStmt + " <- addBoardStmt");

	//영향받은 행값 
	int row = addBoardStmt.executeUpdate(); 
	if(row == 1) {  
		System.out.println("게시물추가성공");
		response.sendRedirect(request.getContextPath() + "/home.jsp?");
	} else {
		System.out.println("게시물추가실패");
		response.sendRedirect(request.getContextPath() + "/board/addBoard.jsp?");
		return;
	}	

%>