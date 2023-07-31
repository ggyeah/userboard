<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<% 
	//세션 유효성 검사 로그인이 되어있지 않으면 들어올 수 없음
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	//db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//회원정보 결과셋-----------------------------------------------------
	PreparedStatement memberStmt = null;
	ResultSet memberRs = null;
	String memberSql = "SELECT member_id memberId, createdate, updatedate from member where member_id = ?";
	memberStmt = conn.prepareStatement(memberSql);
	memberStmt.setString(1, loginMemberId);
	
	System.out.println(memberStmt + " <-- memberStmt");
	
	memberRs = memberStmt.executeQuery(); //row -> 1 -> Board타입
	
	Member m = new Member();
	if(memberRs.next()) {
		m.setMemberId(memberRs.getString("memberId"));
		m.setCreatedate(memberRs.getString("createdate"));
		m.setUpdatedate(memberRs.getString("updatedate"));
	}
%>
		
		
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>memberOne</title>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/main.css" />
</head>
<body class="is-preload">
<div id="main">
	<div class="inner">
	<header id="header">
		<span class="logo"><strong>userboard</strong> </span>
		   <div>
		      <jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		   </div>
	</header>
	<div class = "container"> 
		<h2>회원정보</h2>
			<table class ="table">
	            <tr>
	               <th class="table-secondary">아이디</th>
	               <td><%=m.getMemberId()%></td>
	            </tr>
	            <tr>
	               <th class="table-secondary">가입일</th>
	               <td><%=m.getCreatedate()%></td>
	            </tr>
	            <tr>
	               <th class="table-secondary">수정일</th>
	               <td><%=m.getUpdatedate()%></td>
	            </tr>
			</table>
			<div>
				<a href="updatePwForm.jsp" class="btn btn-outline-danger">비밀번호수정</a>
				<a href="deleteMemberForm.jsp" class="btn btn-outline-danger">회원탈퇴</a>
			</div>
			<div>
	      <jsp:include page="/inc/copyright.jsp"></jsp:include>
	   </div>
	</div>
</div>
</div>  
</body>
</html>