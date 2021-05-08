<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
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
		if(userID == null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
		
		// 수정 전, 유효한 글인지 확인
		int bbsID = 0;			
		if (request.getParameter("bbsID") != null)
		{
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if(bbsID == 0)				// 글이 들어오지 않았다면
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
		
		// 넘어온 bbsID 를 가지고 게시물 객체 가져옴
		Bbs bbs = new BbsDAO().getBbs(bbsID);
		
		// 작성자가 맞는지 확인하는 과정
		if(!userID.equals(bbs.getUserID()))
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
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
	
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리 <span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>

		</div>
	</nav>
	
	<!-- 게시판 화면 구성: 내용 담을 수 있는 컨테이너, 테이블 들어갈 공간 클래스 만들고..  -->
	<div class="container">
		<div class="row">
			<!-- 수정 시 action에 bbsID를 넘겨줄 수 있도록 만듦 -->
			<form action="updateAction.jsp?bbsID=<%=bbsID %>" method="post">
				<table class="table table-stripted" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 수정 양식</th>
						</tr>
					</thead>
					<tbody>
						<tr> <!-- 글제목, 글내용을 각각 tr로 묶으면 한 줄씩 나오게 할 수 있다. -->
							<td><input type="text" class="form-contrl" placeholder="글 제목"
							 name="bbsTitle" maxlength="50" value="<%=bbs.getBbsTitle()%>"></td>
						</tr>
						<tr>	
							<!-- bbs.getBbsContent()를 넣어 수정 전 제목과 내용을 확인할 수 있다. 
							     input에서는 value와 함께, textarea에서는 그냥 사이에 넣어준다. -->
							<td><textarea class="form-control" placeholder="글 내용" name="bbsContent"
 								maxlength="2048" style="height: 350px;"><%=bbs.getBbsContent()%></textarea></td>
						</tr>
					</tbody>
				</table>
				<input type="submit" class="btn btn-primary pull-right" value="글쓰기">
			</form>
		</div>
	</div>
 	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
 	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</body>
</html>