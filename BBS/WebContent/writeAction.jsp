<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<!-- 자바스크립트 문장 작성하기 위해 사용 -->
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!-- 한 user를 담는 클래스(DTO)를 자바 beans로서 활용, 현재 페이지 안에서만 beans가 사용되도록. -->
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<jsp:setProperty name="bbs" property="bbsTitle" />
<jsp:setProperty name="bbs" property="bbsContent" />
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
		
		if(userID == null)				// 로그인이 되어있지 않다면
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}else							// 로그인을 한 상태라면
		{
			if(bbs.getBbsTitle() == null || bbs.getBbsContent() == null)
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')");
				script.println("history.back()");
				script.println("</script>");
				
			}else
			{
				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent());
				
				if(result==-1)	// 글쓰기 등록 오류가 발생한 경우
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = 'bbs.jsp'");	// 게시판 메인화면으로 이동
					script.println("</script>");
				}
			}
			
		}
	%>
</body>
</html>