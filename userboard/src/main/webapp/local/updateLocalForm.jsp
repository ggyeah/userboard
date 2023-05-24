<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	response.setCharacterEncoding("utf-8");
    // 세션 유효성 검사 로그인 되어있지 않으면 들어올 수 없음
   	if(session.getAttribute("loginMemberId") == null) {
	response.sendRedirect(request.getContextPath()+"/home.jsp");
	return;
   	}

	
	//요청값 저장
	String localName = request.getParameter("localName");
	
	String msg = request.getParameter("msg");
	// db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 웹에 출력할 local 데이터 가져오기
	PreparedStatement updateLocalNameStmt = null;
	ResultSet updateLocalNameRs = null;
	String updateLocalNameSql = "SELECT local_name localName, createdate, updatedate FROM local WHERE local_name = ?";
	updateLocalNameStmt = conn.prepareStatement(updateLocalNameSql);
	updateLocalNameStmt.setString(1, localName);
	System.out.println(updateLocalNameStmt + " <- updateLocalName stmt");
	updateLocalNameRs = updateLocalNameStmt.executeQuery();
	
	Local l = new Local();
	if(updateLocalNameRs.next()){
		l.setLocalName(updateLocalNameRs.getString("localName"));
		l.setCreatedate(updateLocalNameRs.getString("createdate"));
		l.setUpdatedate(updateLocalNameRs.getString("updatedate"));
	}
	
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateLocalForm</title>
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
<form action="<%=request.getContextPath()%>/local/updateLocalAction.jsp" method="post">
	<h2>지역수정</h2>
		<table class="table table-bordered ">
		<%
			if(msg != null){
		%>
			<%=msg%>
		<%	
			}
		%>
			<tr>
				<td class="table-secondary"> 
					현재 지역이름
				</td>
				<td>
					<input type="hidden" value="<%=l.getLocalName()%>" name="localName" >
					<input type="text" value="<%=l.getLocalName()%>" name="updateLocalName"> 
				</td>
			</tr>
			<tr>
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
	              <button type="submit" class="btn btn-danger">수정</button>
				</td>
			</tr>
		</table>
	</form>
</div>
</body>
</html>
