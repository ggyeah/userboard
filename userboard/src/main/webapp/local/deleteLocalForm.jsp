<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	response.setCharacterEncoding("utf-8");
	// controller
	if (session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
	String localName = request.getParameter("localName");
	System.out.println(localName + " <- updateLocalName localName");
	String msg = request.getParameter("msg");
	//db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	
	// 삭제할 지역정보 가져오는 쿼리문
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql = "SELECT local_name localName, createdate, updatedate FROM local WHERE local_name = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, localName);
	System.out.println(stmt + " <- updateLocalName stmt");
	rs = stmt.executeQuery();
	
	Local l = new Local();
	if(rs.next()){
		l.setLocalName(rs.getString("localName"));
		l.setCreatedate(rs.getString("createdate"));
		l.setUpdatedate(rs.getString("updatedate"));
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteLocalForm</title>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/main.css" />
</head>
<body class="is-preload">
					<header id="header">
						<span class="logo"><strong>userboard</strong> </span>
						   <div>
						      <jsp:include page="/inc/mainmenu.jsp"></jsp:include>
						   </div>
					</header>
    <div class = "container">
	<h2><%=l.getLocalName()%>삭제</h2>
	<div>
	<%
		if(msg != null){
	%>
		<div class="text-danger"><%=msg%></div>
	<%	
		}
	%>
	</div>
	<form action="<%=request.getContextPath()%>/local/deleteLocalAction.jsp" method="post">
		<table class="table table-bordered ">
			<tr>
				<th class="table-secondary">local_name</th>
				<td>
					<input type="hidden" value="<%=l.getLocalName()%>" name="localName" >
					<%=l.getLocalName()%>
				</td>
			</tr>
			<tr>
				<th class="table-secondary">createdate</th>
				<td>
					<%=l.getCreatedate()%>
				</td>
			</tr>
			<tr>
				<th class="table-secondary">updatedate</th>
				<td>
					<%=l.getUpdatedate()%>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<button type="submit" class="btn btn-danger"> 삭제 </button>
				</td>
			</tr>
		</table>
	</form>
	<div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
	</div>
</body>
</html>