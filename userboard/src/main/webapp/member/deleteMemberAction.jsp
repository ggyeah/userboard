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

	// 오류메세지 출력
	String msg = null;  
	if( request.getParameter("memberPw") == null) {
		msg = URLEncoder.encode("비밀번호가 입력되지 않았습니다", "utf-8");
		response.sendRedirect(request.getContextPath() +"/member/deleteMemberFrom.jsp?msg="+msg);
		return;
	}

	//요청값
	String memberId = (String)session.getAttribute("loginMemberId");
	String memberPw = request.getParameter("memberPw");

	
	//db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 회원삭제 쿼리문 
	PreparedStatement memberStmt = null;
	ResultSet memberRs = null;
	String memberSql =  "delete from member where member_id=? and member_pw=PASSWORD(?)";
	memberStmt = conn.prepareStatement(memberSql);
	memberStmt.setString(1, memberId);
	memberStmt.setString(2, memberPw);
	
	System.out.println(memberStmt + " <-- memberStmt");
	
	//memberRs = memberStmt.executeQuery(); //이게 들어가면 안됨
	
	int row = memberStmt.executeUpdate();
	if(row == 0) { // 비빌번호 틀려서 삭제행이 0행
		System.out.println(row + " <- 삭제실패"); 
		msg = URLEncoder.encode("비밀번호가 틀렸습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/deleteMemberForm.jsp?msg="+msg);
		return;
		} else {
		      response.sendRedirect(request.getContextPath()+"/home.jsp");
		      System.out.println(row + " <- 삭제성공");
		}
%>
