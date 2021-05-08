<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>	<!-- 게시판 목록 출력을 위해 필요 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<!-- <link rel="stylesheet" href="css/bootstrap.css"> -->
<link rel="stylesheet" href="css/bootstrap.min.css">
<title>JSP 게시판 웹 사이트</title>
<style type="text/css">
	/* 링크 스타일: 검은색, 줄 쳐지지 않도록 */	
	a, a:hover { color: #000000; text-decoaration: none; }
</style>
</head>
<body>
	<%
		// 로그인 한 사용자는 세션ID가, 그렇지 않은 경우는 null 값을 가진다.
		String userID = null;
		if(session.getAttribute("userID") != null)
		{
			userID = (String) session.getAttribute("userID");
		}
		int pageNumber = 1;				// 처음 페이지 넘버는 1.
		
		// 요청 객체의 pageNumber를 String에서 int로 변환
		if(request.getParameter("pageNumber") != null)
		{
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
	%>

	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collpased"
			 data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
			 aria-expanded="false">
			 <!-- 작은 화면에서 옆에 작대기(아이콘)이 3개 나오도록. -->
			 <span class="icon-bar"></span>
			 <span class="icon-bar"></span>
			 <span class="icon-bar"></span>
		</button>
		<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<!-- id는 위의 data-target과 동일하게 넣어주어야 한다. -->
		<div class="collapse navbar-collpase"
			id="bs-example-navbar-collapse-1">
			<!-- ul: 리스트 보여주기 -->
			<ul class="nav navbar-nav">
				<!-- main 페이지 부분에 class="active"를 추가해 현재 접속한 페이지가 main.jsp임을 알 수 있음 -->
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			
			<%
				// 로그인하지 않은 사용자에게만 접속하기가 보이도록!!
				if(userID==null)
				{
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">접속하기 <span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li class="active"><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<%
				} else
				{	// 로그인한 사용자에게는 회원관리, 로그아웃 창이 보이도록 함!
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리 <span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			<%		
				}
			%>
		</div>
	</nav>
	
	<!-- 게시판 화면 구성: 내용 담을 수 있는 컨테이너, 테이블 들어갈 공간 클래스 만들고..  -->
	<div class="container">
		<div class="row">
			<table class="table table-stripted" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">번호</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody>
					<%
						BbsDAO bbsDAO = new BbsDAO();
						ArrayList<Bbs> list = bbsDAO.getList(pageNumber);
						for (int i=0; i<list.size(); i++)
						{ // DB에서 게시글 정보를 하나씩 가져와서 목록에서 보여준다.
					%>
					<tr>
						<td><%= list.get(i).getBbsID() %></td>
						<!-- 게시글 제목을 눌렀을 때 해당 게시물로 이동할 수 있도록 링크 설정(<a>태그 이용)
						     페이지: view.jsp / 매개변수: bbsID (게시물 번호) -->
						<td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle() %></a></td>
						<td><%= list.get(i).getUserID() %></td>
						<td><%= list.get(i).getBbsDate() %></td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
			<%
				// 페이지를 넘길 수 있는 부분
				if (pageNumber != 1)
				{
			%>
				<a href="bbs.jsp?pageNumber=<%=pageNumber -1 %>" class="btn btn-success btn-arrow-left">이전</a>
			<%
				} if(bbsDAO.nextPage(pageNumber + 1))		// '다음' 페이지가 있는지 물어보는 것이므로 1 더하기!
				{
			%>
				<a href="bbs.jsp?pageNumber=<%=pageNumber +1 %>" class="btn btn-success btn-arrow-left">다음</a>
			<%	
				}
			%>
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	</div>
	
<!-- <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script> -->
 	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
 	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</body>
</html>