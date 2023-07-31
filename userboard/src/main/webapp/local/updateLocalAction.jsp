<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.*" %>
<%
	//인코딩 처리 // 한글이 깨지지 않도록
	request.setCharacterEncoding("UTF-8"); 
	response.setCharacterEncoding("utf-8");

	//로그인상태가 아니면 들어올수없음
	if(session.getAttribute("loginMemberId") == null) {
	response.sendRedirect(request.getContextPath()+"/home.jsp");
	return;
	}
	
	// 요청값 오류메세지 출력
	String msg = null;
	String localName = request.getParameter("localName");
	if(request.getParameter("updateLocalName") == null
			|| request.getParameter("updateLocalName").equals("")) {
		msg = URLEncoder.encode("수정할 지역이름이 입력되지 않았습니다", "utf-8");
		localName = URLEncoder.encode(localName, "utf-8");
		response.sendRedirect(request.getContextPath()+"/local/updateLocalForm.jsp?localName="+localName+"&msg="+msg);
		return;
	}
	
	String updateLocalName = request.getParameter("updateLocalName");
	
	//db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 지역이름 수정 쿼리문
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql =  "UPDATE local SET local_name = ?, updatedate = now() WHERE local_name = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, updateLocalName);
	stmt.setString(2, localName);
	
	System.out.println(stmt + " <-- memberStmt");
	
	//영향받은 행값
	int row = stmt.executeUpdate();
		
	if(row == 0) { // 현재지역이름 틀려서 삭제행이 0행
		msg = URLEncoder.encode("현재 지역이름이 틀렸습니다", "utf-8"); 
		response.sendRedirect(request.getContextPath() + "/local/updateLocalForm.jsp?localName="+localName+"&msg="+msg);
		return;
	} else {
		response.sendRedirect(request.getContextPath()+"/local/localList.jsp");
		System.out.println("지역이름이 수정되었습니다");
		return;
		}
%>