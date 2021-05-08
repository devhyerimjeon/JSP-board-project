<%@ page contentType="text/html; charset=UTF-8"%>
<!-- 빈즈 대신 추가 -->
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<!-- 자바스크립트 문장 작성하기 위해 사용 -->
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
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
		}
		
		//- update 페이지와 동일한 확인 과정
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
		else							// 권한이 있는 사람이라면
		{
			BbsDAO bbsDAO = new BbsDAO();
			int result = bbsDAO.delete(bbsID);
			
			if(result==-1)	// 글삭제 오류가 발생한 경우
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('글 삭제에 실패했습니다.')");
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
	%>
</body>
</html>