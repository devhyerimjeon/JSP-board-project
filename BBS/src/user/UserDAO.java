package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO
{
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	// 생성자 정의
	public UserDAO()
	{
		conn = DBConn.getConnection();
	}
	
	public int login(String userID, String userPassword)
	{
		String sql = "SELECT USERPASSWORD FROM TBL_USER WHERE USERID = ?";
		try
		{
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next())
			{
				if(rs.getString(1).equals(userPassword))
					return 1;	// 로그인 성공
				else
					return 0;	// 비밀번호 불일치
			}
			
			return -1;  // 아이디가 없음
	
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		return -2;	//데이터베이스 오류
	}
	
	public int join(User user)
	{
		String sql = "INSERT INTO TBL_USER VALUES(?, ?, ?, ?, ?)";
		try
		{
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			
			return pstmt.executeUpdate();	// 정보 입력 시 1 이상 숫자 반환
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return -1;	// 데이터베이스 오류
	}
}
