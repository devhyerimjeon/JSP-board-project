<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<!-- <link rel="stylesheet" href="css/bootstrap.css"> -->
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/custom.css">
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
				<li class="active"><a href="main.jsp">메인</a></li>
				<li><a href="bbs.jsp">게시판</a></li>
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
	
	<!-- 메인 화면 디자인 -->
	
	<div class="container">
		<div class="jumbotron"> <!-- jumbotron: 부트스트랩에서 사용 -->
			<div class="container">
				<h1>웹 사이트 소개</h1>
				<p>이 웹 사이트는 부투스트랩으로 만든 JSP 웹 사이트입니다.
				   최소한의 간단한 로직만을 이용해 개발했습니다. </p>
				<!-- 동작은 하지 않고 버튼만 보이도록 -->
				<p><a class="btn btn-primary btn-pull" href="#" role="button">자세히 알아보기</a></p>
			</div>
		</div>
	</div>
	
	
	
	
	
<!-- <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script> -->
 	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
 	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</body>
</html>