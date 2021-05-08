<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="user.UserDAO" %>
<!-- 자바스크립트 문장 작성하기 위해 사용 -->
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!-- 한 user를 담는 클래스(DTO)를 자바 beans로서 활용, 현재 페이지 안에서만 beans가 사용되도록. -->
<jsp:useBean id="user" class="user.User" scope="page" />
<!-- login페이지에서 넘어온 name=userID, userPassword 정보 받아옴 
     단, property는 User 클래스(DTO)의 변수와 대소문자까지 똑같아야 한다.
     (User 클래스에는 userPASSWORD로 되어있고 property는 userPassword로 되어있으면 에러 발생 -->
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		// 가장 먼저, 이미 로그인 되어 세션ID가 있는 경우 처리 필요
		String userID = null;
		if(session.getAttribute("userID") != null)
		{
			userID = (String)session.getAttribute("userID");
		}
		
		if(userID != null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어 있습니다.')");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
		
		UserDAO userDAO = new UserDAO();
		int result = userDAO.login(user.getUserID(), user.getUserPassword());
		
		if(result==1)
		{
			// 로그인이 성공적으로 이뤄진 사용자에겐 세션ID를 부여해야 한다.
			session.setAttribute("userID", user.getUserID());
			PrintWriter script = response.getWriter();
			script.println("<script>");
			// 로그인 성공 시 이동할 페이지
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
		else if(result==0)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호가 틀립니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if(result==-1)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 아이디입니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if(result==-2)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
	%>
</body>
</html>