<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		// joinAction, loginAction에서 로그인 한 사용자에게 부여한 세션ID 할당 해제
		session.invalidate();
	%>
	
	<script>
		location.href = 'main.jsp';
	</script>
</body>
</html>