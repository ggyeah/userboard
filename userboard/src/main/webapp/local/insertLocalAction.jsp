<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<% 
	response.setCharacterEncoding("utf-8");
   // 세션 유효성 검사	
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
   
	System.out.println(request.getParameter("localName")+"<- localName");
	//요청값 유효성 검사
	String localName = request.getParameter("localName");
	
	String msg =null;
	if(request.getParameter("localName") == null						
		|| request.getParameter("localName").equals("")) {		
		msg = URLEncoder.encode("지역이름이 입력되지 않았습니다", "utf-8");
		response.sendRedirect(request.getContextPath()+"/local/insertLocalForm.jsp?msg="+msg);
	      return;
	}
	
	//db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	PreparedStatement stmt1 = null;
	ResultSet rs = null;
 	//첫번째 쿼리문 중복된 지역이름확인
    String sql1 = "SELECT local_name FROM local where local_name = ?";
	stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, localName);
	System.out.println(stmt1);
	rs = stmt1.executeQuery();
	   
    if(rs.next()) { // 중복된 이름이 있으면 
      System.out.println("지역이름중복으로 추가실패");
      msg = URLEncoder.encode("중복된 이름입니다", "utf-8");
      response.sendRedirect(request.getContextPath()+"/local/insertLocalForm.jsp?msg="+msg);
      return;
    } 

	//두번째 쿼리문 db에 추가
	PreparedStatement stmt2 = null;
	String sql2 = "INSERT INTO local (local_name, createdate, updatedate) VALUES(?, NOW(), NOW())";
	stmt2 = conn.prepareStatement(sql2);
	// ?
	stmt2.setString(1, localName);
	System.out.println(stmt2 +"<- stmt2");
	
	//영향받은 행값 
	int row = stmt2.executeUpdate(); 
	if(row == 1) {  
		System.out.println("지역추가성공");
		response.sendRedirect(request.getContextPath() +"/local/localOne.jsp?");
	} else {
		System.out.println("지역추가실패");
	}	
%>