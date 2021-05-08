<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %>	<!-- 실제로 데이터베이스를 사용할 수 있도록 -->
<%@ page import="bbs.BbsDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<!-- <link rel="stylesheet" href="css/bootstrap.css"> -->
<link rel="stylesheet" href="css/bootstrap.min.css">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		// 로그인 한 사용자는 세션ID가, 그렇지 않은 경우는 null 값을 가진다.
		String userID = null;
		if(session.getAttribute("userID") != null)
		{
			userID = (String) session.getAttribute("userID");
		}
		int bbsID = 0;
		if (request.getParameter("bbsID") != null)
		{
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if(bbsID == 0)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
		
		Bbs bbs = new BbsDAO().getBbs(bbsID);
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
							<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th>
						</tr>
					</thead>
					<tbody>
						<tr> <!-- 글제목, 글내용을 각각 tr로 묶으면 한 줄씩 나오게 할 수 있다. -->
							<!-- 보안상, 크로스사이트스크립팅 문제를 해결하기 위해 글 제목에도
							     특수문자가 인식되지 않도록 설정한다. -->
							<td style="width: 20%;">글 제목</td>
							<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
						</tr>
						<tr>
							<td>작성자</td>
							<td colspan="2"><%= bbs.getUserID() %></td>
						</tr>
						<tr>
							<td>작성일자</td>
							<td colspan="2"><%= bbs.getBbsDate() %></td>
						</tr>
						<tr>
							<!-- 내용 부분에서는 사용자가 특수문자를 입력할 때 브라우저가 html문인지
							     구별하지 못해 입력한 내용을 제대로 출력하지 못하므로
							     replaceAll을 사용해 문제가 되는 특수문자를 대체하도록 한다.  -->
							<td>내용</td>
							<td colspan="2" style="min-height: 200[x; text-align: left;">
							<%=bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
						</tr>
					</tbody>
				</table>
				<a href="bbs.jsp" class="btn btn-primary">목록</a>
				<%
					// 해당 글의 작성자가 본인이라면 수정, 삭제할 수 있도록 링크 생성
					if( userID != null && userID.equals(bbs.getUserID()) )
					{
				%>
					<a href="update.jsp?bbsID=<%= bbsID%>" class="btn btn-primary">수정</a>
					<a onclick = "return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID%>" class="btn btn-primary">삭제</a>
				<%		
					}
				%>
				<input type="submit" class="btn btn-primary pull-right" value="글쓰기">
		</div>
	</div>
 	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
 	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</body>
</html>