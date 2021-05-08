package bbs;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import user.DBConn;

public class BbsDAO
{
	private Connection conn;
	private ResultSet rs;
	
	// 생성자 정의
	public BbsDAO()
	{
		conn = DBConn.getConnection();
	}
	
	// 현재 시간을 가져오는 함수
	public Date getDate()
	{
		// 여러 함수가 정의되어 있는 BbsDAO
		// 따라서 데이터 베이스에 접근할 때 마찰이 생길 수 있으므로
		// PreparedStatement를 전역변수가 아닌 각각 함수 내의 지역변수로 선언한다.
		String sql = "SELECT SYSDATE FROM DUAL";
		
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next())
			{
				return rs.getDate(1);
			}
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		return null;	// 데이터베이스 오류
	}
	
	// 다음 게시글 번호를 산출하는 함수
	public int getNext()
	{
		String sql = "SELECT bbsID FROM TBL_BBS ORDER BY bbsID DESC";
		
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next())
			{
				return rs.getInt(1) + 1; 	// 다음 번호가 들어가도록 1을 더해 줌
			}
			return 1;							// 첫 번째 게시물인 경우
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		return -1;	// 데이터베이스 오류
	}
	
	// 게시물 작성 함수
	public int write(String bbsTitle, String userID, String bbsContent)
	{
		int result=0;
		String sql = "INSERT INTO TBL_BBS (bbsID, bbsTitle, userID, bbsDate, bbsContent, bbsAvailable)"
				+ " VALUES (?, ?, ?, ?, ?, ?)";

		try
		{
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, getNext());			// 위에서 작성한 함수가 들어가도록
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setDate(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);					// 기본: 삭제가 안 된 상태(1)
			
			result = pstmt.executeUpdate();
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		if(result<=0)
		{
			result = -1;	// 데이터베이스 오류
		}
		
		return result;
	}
	
	
	// DB에 저장된 게시물 객체를 가져오는 함수
	public ArrayList<Bbs> getList(int pageNumber)
	{
		ArrayList<Bbs> list= new ArrayList<Bbs>();
		
		String sql = "SELECT * FROM TBL_BBS WHERE bbsID<? AND bbsAvailable=1 AND ROWNUM <= 10 ORDER BY bbsID DESC";
		
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			// 현재 5개의 글이 DB에 저장되어 있다면, getNext()는 그 다음 글의 번호를 의미하므로 6.
			// 페이지 넘버는 1페이지인 경우 1. 한 페이지 당 10개씩 보여줄 수 있도록 한다.
			
			rs = pstmt.executeQuery();
			
			while(rs.next())
			{
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getDate(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);
			}		
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return list;			// 게시글 객체 반환
	}
	

	// 페이징 처리를 위한 함수 : 글이 10 단위로 끊기는 경우, 넥스트 페이지가 없도록 처리하는 함수
	// 즉, 특정 페이지가 존재하는지 물어보는 함수
	public boolean nextPage(int pageNumber)
	{
		String sql = "SELECT * FROM TBL_BBS WHERE bbsID<? AND bbsAvailable=1";
		
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			
			rs = pstmt.executeQuery();
			
			if(rs.next())
				return true;		// 다음 페이지로 넘어갈 수 있다.
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return false;				// 다음 페이지가 없다.
		
	}
	
	
	// 하나의 글 내용을 불러오는 함수
	public Bbs getBbs(int bbsID)
	{
		String sql = "SELECT * FROM TBL_BBS WHERE bbsID = ?";
		
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, bbsID);
			
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{
				Bbs bbs = new Bbs();
				
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getDate(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				
				return bbs;		// 해당 게시물 객체 반환
			}
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return null;
		
	}
	
	
	// 글 수정 함수
	public int update(int bbsID, String bbsTitle, String bbsContent)
	{
		String sql = "UPDATE TBL_BBS SET bbsTitle=?, bbsContent=? WHERE bbsID=?";

		try
		{
			PreparedStatement pstmt = conn.prepareStatement(sql);		
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			
			return pstmt.executeUpdate();
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return -1;
	}
	
	// 글 삭제 함수
	public int delete(int bbsID)
	{
		// 글을 삭제하더라도 글에 대한 정보가 남아있도록 delete 쿼리문이 아닌
		// bbsAvailable 항목으로 관리
		String sql = "UPDATE TBL_BBS SET bbsAvailable = 0 WHERE bbsID=?";

		try
		{
			PreparedStatement pstmt = conn.prepareStatement(sql);		
			pstmt.setInt(1, bbsID);
			
			return pstmt.executeUpdate();
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return -1;
	}
	
}
