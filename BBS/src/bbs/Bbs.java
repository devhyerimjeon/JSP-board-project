package bbs;

import java.sql.Date;

public class Bbs
{
	// 하나의 게시글 정보를 담기 위한 객체 클래스 → bins
	private int bbsID;
	private String bbsTitle;
	private String userID;
	private Date bbsDate;
	private String bbsContent;
	private int bbsAvailable;
	public int getBbsID()
	{
		return bbsID;
	}
	public void setBbsID(int bbsID)
	{
		this.bbsID = bbsID;
	}
	public String getBbsTitle()
	{
		return bbsTitle;
	}
	public void setBbsTitle(String bbsTitle)
	{
		this.bbsTitle = bbsTitle;
	}
	public String getUserID()
	{
		return userID;
	}
	public void setUserID(String userID)
	{
		this.userID = userID;
	}
	public Date getBbsDate()
	{
		return bbsDate;
	}
	public void setBbsDate(Date date)
	{
		this.bbsDate = date;
	}
	public String getBbsContent()
	{
		return bbsContent;
	}
	public void setBbsContent(String bbsContent)
	{
		this.bbsContent = bbsContent;
	}
	public int getBbsAvailable()
	{
		return bbsAvailable;
	}
	public void setBbsAvailable(int bbsAvailable)
	{
		this.bbsAvailable = bbsAvailable;
	}
	
	

}
