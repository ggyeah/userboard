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
	
	// 요청값 오류메세지 출력
	String msg = null;
	if(request.getParameter("memberPw") == null
			|| request.getParameter("memberPw").equals("")) {
		msg = URLEncoder.encode("현재 비밀번호가 입력되지 않았습니다", "utf-8");
	} else if(request.getParameter("memberPw1") == null
			|| request.getParameter("memberPw1").equals("")) {
		msg = URLEncoder.encode("새 비밀번호가 입력되지 않았습니다", "utf-8");
	} else if(request.getParameter("memberPw2") == null
			|| request.getParameter("memberPw2").equals("")) {
		msg = URLEncoder.encode("새 비밀번호 확인이 입력되지 않았습니다", "utf-8");
	}
	if(msg != null) {
		response.sendRedirect(request.getContextPath() + "/member/updatePwForm.jsp?msg=" + msg);
		return;
	}
	
	// 요청값 변수선언
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	String memberPw = request.getParameter("memberPw");
	String memberPw1 = request.getParameter("memberPw1");
	String memberPw2 = request.getParameter("memberPw2");
	
	// 새 비밀번호 두개 값 동일여부 오류메세지
	if(!memberPw1.equals(memberPw2)) {
		msg = URLEncoder.encode("새 비밀번호가 동일하지 않습니다.", "utf-8"); 
		response.sendRedirect(request.getContextPath() + "/member/updatePwForm.jsp?msg=" + msg);
		return;
	}
	
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
	String sql =  "UPDATE member SET member_pw =PASSWORD(?) WHERE member_id=? and member_pw=PASSWORD(?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberPw1);
	stmt.setString(2, loginMemberId);
	stmt.setString(3, memberPw);
	
	System.out.println(stmt + " <-- memberStmt");
	
	//영향받은 행값
	int row = stmt.executeUpdate();
	
	if(row == 0) { // 비빌번호 틀려서 삭제행이 0행
		msg = URLEncoder.encode("현재 비밀번호가 틀렸습니다.", "utf-8"); 
		response.sendRedirect(request.getContextPath() + "/member/updatePwForm.jsp?msg=" + msg);
		return;
		} else {
		response.sendRedirect(request.getContextPath()+"/member/memberOne.jsp");
		System.out.println("비밀번호가 수정되었습니다");
		return;
		}
%>