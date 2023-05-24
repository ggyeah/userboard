<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 드라이버 로딩 및 db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// select 쿼리 작성 // 가장 최근에 생성한 카테고리가 상단으로 가도록 정렬
	String sql = "SELECT local_name localName, createdate createdate FROM local ORDER BY createdate DESC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();
	System.out.println(stmt + " <- localList stmt");
	
	// ArrayList로 변환
	ArrayList<Local> localList = new ArrayList<Local>();
	
	while(rs.next()) {
		Local local = new Local();
		local.setLocalName(rs.getString("localName"));
		local.setCreatedate(rs.getString("createdate"));
		localList.add(local);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>localList.jsp</title>
	<!-- 부트스트랩5 사용 -->
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

<!-------------------------------------------- localList  ------------------------------------------->
	<h2>카테고리 목록
	 	 <%
    	 if(session.getAttribute("loginMemberId") != null) { // 로그인을해야 새 카테고리 추가 폼이 보임
    	 %>
		<a href="<%=request.getContextPath()%>/local/insertLocalForm.jsp" class="button small">&#10133;카테고리추가</a>
		 <%
	      }
	     %>
	</h2>
	<div class="text-danger">
		<%
			if(request.getParameter("msg") != null) {
		%>
				<%=request.getParameter("msg")%>
		<%
			}
		%>
	</div>
	<table class="table container">
		<thead class="table table-striped">
			<tr>	
				<th>카테고리</th>
				<th>생성일자</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
		</thead>
		<tbody>
			<%
				for(Local l : localList) {
			%>
					<tr>
						<td><a href="<%=request.getContextPath()%>/local/localOne.jsp?localName=<%=l.getLocalName()%>">
						<%=l.getLocalName()%></a></td>
						<td><%=l.getCreatedate()%></td>
					<% // 로그인 사용자만 수정,삭제,댓글입력허용
						if(session.getAttribute("loginMemberId") != null) {

					%>
						<td>
							<a href="<%=request.getContextPath()%>/local/updateLocalForm.jsp?localName=<%=l.getLocalName()%>" class="btn">
							수정</a>
						</td>
						<td>
							<a href="<%=request.getContextPath()%>/local/deleteLocalForm.jsp?localName=<%=l.getLocalName()%>" class="btn">
							삭제</a>
						</td>
					<%
	                          } 
                     %>
					</tr>
			<%
				}
			%>
		</tbody>
	</table>	

<div>
	<!-- 액션태그 -->
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
</div>
</body>
</html>