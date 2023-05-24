<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	// 세션 유효성 검사	
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// 요청값 유효성 검사
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	
	// 아이디와 비밀번호가 입력되지 않았을 때 오류메세지 출력
	String msg =null;
	if(request.getParameter("memberId") == null 
			|| request.getParameter("memberId").equals("")) {
		 msg = URLEncoder.encode("아이디가 입력되지 않았습니다", "utf-8");
	} else if (request.getParameter("memberPw") == null
			|| request.getParameter("memberPw").equals("")) {
			 msg = URLEncoder.encode("비밀번호가 입력되지 않았습니다", "utf-8");
	} 
	if(msg != null) {
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
		return;
	}
	
	//db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	/*첫번째 쿼리문 중복된 아이디확인*/
	String sql1 = "SELECT member_id FROM member where member_id = ?";
	stmt1 = conn.prepareStatement(sql1);
	// ? 두개
	stmt1.setString(1, paramMember.getMemberId());
	System.out.println(stmt1);
	rs = stmt1.executeQuery();
	
	if(rs.next()) { // 아이디가 있으면
		System.out.println("아이디중복 회원가입실패");
		msg = URLEncoder.encode("중복된아이디입니다", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
		return;
	} 
	/*두번째 쿼리문 db에 추가*/
	/*
	insert into member(member_id, member_pw, createdate, updatedate)  
	values(?,?,now(),now())"
	*/
	PreparedStatement stmt2 = null;
	String sql2 = "INSERT INTO member(member_id, member_pw, createdate, updatedate) VALUES(?, PASSWORD(?), NOW(), NOW())";
	stmt2 = conn.prepareStatement(sql2);
	// ? 두개
	stmt2.setString(1, paramMember.getMemberId());
	stmt2.setString(2, paramMember.getMemberPw());
	System.out.println(stmt2);
	
	//영향받은 행값 
	int row = stmt2.executeUpdate(); 
	if(row == 1) {  
		System.out.println("회원가입성공");
		response.sendRedirect(request.getContextPath() + "/home.jsp?");
	} else {
		System.out.println("회원가입실패");
	}	
%>