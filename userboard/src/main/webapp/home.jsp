<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
	<%
	//1. 요청분석 (컨트롤러 계층)
		//1) session JSP내장(기본)객체
		//2) request / response
		// 현재페이지
		int currentPage = 1;
		if(request.getParameter("currentPage") != null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		String localName = "전체";
		if(request.getParameter("localName") != null) {			
			localName = request.getParameter("localName");		
		}

		//2. 모델계층
		//db연결
		String driver = "org.mariadb.jdbc.Driver";
		String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
		String dbuser = "root";
		String dbpw = "java1234";
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
		
		// 1) ----------------- 서브메뉴 결과셋(모델)
		//----------------------------------------------------
		/*SELECT '전체' localName, COUNT(local_name) cnt FROM board
		UNION all
		SELECT local_name localName, COUNT(local_name) cnt FROM board GROUP BY local_name*/
		String subMenuSql = "SELECT '전체' localName, COUNT(local_name) cnt FROM board UNION all SELECT local_name localName, COUNT(local_name) cnt FROM board GROUP BY local_name";
		PreparedStatement subMenuStmt = conn.prepareStatement(subMenuSql);
		ResultSet subMenuRs = subMenuStmt.executeQuery();
		// snbMenuList 모델데이터
		ArrayList<HashMap<String, Object>> subMenuList = new ArrayList<HashMap<String, Object>>();
		while(subMenuRs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("localName", subMenuRs.getString("localName")); 
			m.put("cnt", subMenuRs.getInt("cnt"));
			subMenuList.add(m);
		}
		// -------------------------2) 페이징--------------------------
		
		//출력할 총행의 수 
		String totalRowSql = "select count(*) from board";
		PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
		ResultSet totalRowRs = totalRowStmt.executeQuery();
		// 총 행수
		int totalRow = 0;
		
		if(totalRowRs.next()) {
			totalRow = totalRowRs.getInt(1); // totalRowRs.getInt("count(*)")
		}  

	 	//페이지당 출력할 행의 수
		int rowPerPage = 10;
		// 시작 행번호
		int beginRow = (currentPage-1)*rowPerPage;
		
		

	 	//----------------12345~ 하단 페이징
	 	
		// 하단 페이징 숫자를 나타내는 변수로, 한 번에 표시되는 페이지 숫자의 개수
		int pagePerPage = 10;
		//시작 페이지
		int beginPage = ((currentPage - 1) / pagePerPage) * pagePerPage + 1;
		//마지막 페이지
		int endPage = beginPage + pagePerPage - 1;
		
		//총 페이지 수
		int lastPage = totalRow/rowPerPage;
		
		//마지막 페이지가 나머지가 0이 아니면 페이지수 1추가
		if(totalRow%rowPerPage!=0){
			lastPage++;
		}
		
		//출력할 전체 페이지 수
		int totalPage = totalRow / pagePerPage;
	

		if(currentPage > totalPage){
			currentPage = totalPage;
		}
		
		if(endPage > totalPage){
			endPage = totalPage;
		}
		
		// --------------3) boardlist 선택된 지역이름 10개 출력-----------------------------------------

		// 2) 게시판 목록 결과셋(모델)
		PreparedStatement boardStmt = null;
		ResultSet boardRs = null;
		// 이름값에 따라 10개까지 출력하는 쿼리
		String boardSql = "";
		if(localName.equals("전체")) {
			boardSql = "SELECT board_no boardNo, local_name localName,board_title boardTitle,createdate FROM board ORDER BY board_no DESC LIMIT ?, ?";
			boardStmt = conn.prepareStatement(boardSql);
			boardStmt.setInt(1, beginRow);
			boardStmt.setInt(2, rowPerPage);
		} else {
			boardSql = "SELECT board_no boardNo, local_name localName,board_title boardTitle,createdate FROM board WHERE local_name = ? ORDER BY board_no DESC LIMIT ?, ?";
			boardStmt = conn.prepareStatement(boardSql);
			boardStmt.setString(1, localName);
			boardStmt.setInt(2, beginRow);
			boardStmt.setInt(3, rowPerPage);
		}
		// db쿼리 결과셋 모델
		boardRs = boardStmt.executeQuery();
		// 애플리케이션에서 사용할 모델(사이즈 0)
		ArrayList<Board> boardList = new ArrayList<Board>();
		// boardRs->boardList
		while(boardRs.next()) {
			Board b = new Board();
			b.setBoardNo(boardRs.getInt("boardNo"));
			b.setLocalName(boardRs.getString("localName"));
			b.setBoardTitle(boardRs.getString("boardTitle"));
			b.setCreatedate(boardRs.getString("createdate"));
			boardList.add(b);
		}
	 	//디버깅
	 	System.out.println(boardList);
	 	System.out.println(boardList.size());
	 	

	%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>home</title>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/main.css" />
</head>
<body class="is-preload">
<!-- Wrapper -->
		<div id="wrapper">

		<!-- Main -->
			<div id="main">
				<div class="inner">
		<!-- Header -->
				<header id="header">
					<a href="home.jsp" class="logo"><strong>userboard</strong></a> 						 
					<%
					     if(session.getAttribute("loginMemberId") != null) { // 로그인 상태여야만 게시글 추가가 보임
					 %>
					     <a href="<%=request.getContextPath()%>/board/addBoard.jsp" class="button small"> &#10133; 게시글 추가</a>
					 <%
					      	}
					  %>
					   <div>
					      <jsp:include page="/inc/mainmenu.jsp"></jsp:include>
					   </div>
				</header>
		<!-- Banner -->
			<div class="content">
				<header>
				<!-- 지역별 게시글 10개씩  -->
				  <h2>게시글목록</h2>
				 </header>
			     <!-- Banner -->
				<div class="table-wrapper">
		  		 <table>
					<tr>
						<th>board_no</th>
						<th>local_name</th>
						<th>board_title</th>
					</tr>
					<%
						for(Board b : boardList) {
					%>
					<tr>
						<td><%=b.getBoardNo()%></td>
						<td><a href="<%=request.getContextPath()%>/local/localOne.jsp?localName=<%=b.getLocalName()%>">
								<%=b.getLocalName()%>
							</a>
						</td>
						<td>
							<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo()%>">
								<%=b.getBoardTitle()%>
							</a>
						</td>
					</tr>
					<%
						}
					%>
				</table>
		<!--------------------------------- 페이징 ----------------------------------------->
			<ul class="pagination">		
				<% //현재 페이지가 페이지네이션 숫자 범위를 넘어섰을 때만 이전 버튼이 표시
	     			 if(currentPage > pagePerPage) {
	   			%>	
					<li><a href="./home.jsp?currentPage=<%=beginPage-10%>&localName=<%=localName%>"  class="button">이전</a></li>
			   	<%
	     			} for(int i = beginPage; i <= endPage; i++){
	        	if(i==currentPage){
			    %>
	         		<li><span class="page active"><%=i%></span></li>
			    <%
			        	}else{
			   	%>  
			   		<li><a href="./home.jsp?currentPage=<%=i%>&localName=<%=localName%>" class="page"><%=i%></a></li>
			   	 <% 
		       			}
		       		} //현재 페이지가 마지막 페이지를 넘지 않았을 때만 다음 버튼이 표시
		      if(currentPage < (lastPage-pagePerPage+1)) {  
			  	 %>
					<li><a href="./home.jsp?currentPage=<%=endPage+1%>&localName=<%=localName%>" class="button">다음</a></li>
				 <%
	      			}
	   			 %>
		</ul>													
		</div>
	</div>
</div>
</div>									
s								
<!-- Sidebar ---------------------------------------------------------------->
	<div id="sidebar">
		<div class="inner">
			<nav id="menu">
				<header class="major">
				  <!-- 로그인 폼 -->
				  <div>
			     <%
			         if(session.getAttribute("loginMemberId") == null) { // 로그인전이면 로그인폼출력
			     %>
		            <form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post">
	               <table>
	                  <tr>
	                     <td>아이디</td>
	                     <td><input type="text" name="memberId"></td>
	                  </tr>
	                  <tr>
	                     <td>패스워드</td>
	                     <td><input type="password" name="memberPw"></td>
	                  </tr>
	               </table>
		               <button type="submit">로그인</button>
		            </form>
			      <%   
			         }else{
			        	 String loginMemberId = (String)session.getAttribute("loginMemberId");
			      %>
			     <h2>&#9989;<%=loginMemberId%>접속중</h2> 
			      <%   
			         }
			      %>
			      </div>
					<h2>category</h2>
			</header>
					<ul>
						<%
						for(HashMap<String, Object> m : subMenuList) {
						%>
						<li>
		                  <a href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>">
		                     <%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)
		                  </a>
						</li>
						<%
						}
						%>
					 </ul>
				 </nav>
			 </div>
		</div>
	</div>
			<!-- Scripts -->
			<script src="assets/js/jquery.min.js"></script>
			<script src="assets/js/browser.min.js"></script>
			<script src="assets/js/breakpoints.min.js"></script>
			<script src="assets/js/util.js"></script>
			<script src="assets/js/main.js"></script>
</body>
</html>