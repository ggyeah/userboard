<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
    
<%
	// 요청분석
	if(request.getParameter("localName") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return; // 1) 코드진행종료 2) 반환값을 남길때
	}
	
	String localName = request.getParameter("localName");
	
	//db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);

	// 지역상세정보 출력 결과셋
	PreparedStatement localStmt = null;
	ResultSet localRs = null;
	String localSql =  "SELECT local_name localName, createdate, updatedate FROM local WHERE local_name = ?";
	localStmt = conn.prepareStatement(localSql);
	localStmt.setString(1, localName);
	
	System.out.println(localStmt + " <-- localStmt");
	
	localRs = localStmt.executeQuery(); //row -> 1 -> Board타입
	
	Local local = null;
	
	if(localRs.next()) {
		local = new Local();
		local.setLocalName(localRs.getString("localName"));
		local.setCreatedate(localRs.getString("createdate"));
		local.setUpdatedate(localRs.getString("updatedate"));
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/home.css" />
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
	<h2>상세보기</h2>
		<table class ="table">
			<tr>
               <th class="table-secondary">지역이름</th>
               <td><%=local.getLocalName()%></td>
            </tr>
			 <tr>
               <th class="table-secondary">생성일</th>
               <td><%=local.getCreatedate()%></td>
            </tr>
            <tr>
               <th class="table-secondary">수정일</th>
               <td><%=local.getUpdatedate()%></td>
            </tr>
		</table>
		<% // 로그인 사용자만 수정,삭제,댓글입력허용
		if(session.getAttribute("loginMemberId") != null) {
			// 현재 로그인 사용자의 아이디
		%>
			<div>
				<a href="<%=request.getContextPath()%>/local/updateLocalForm.jsp?localName=<%=local.getLocalName()%>" class="btn btn-outline-danger">지역이름수정</a>
				<a href="<%=request.getContextPath()%>/local/deleteLocalForm.jsp?localName=<%=local.getLocalName()%>" class="btn btn-outline-danger">지역삭제</a>
			</div>	
		<%
			} 
		%>
		</div>
		<div>
	      <jsp:include page="/inc/copyright.jsp"></jsp:include>
	   </div>
	</div>
</div>
</body>
</html>