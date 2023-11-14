
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Objects;

public class Bookmark
{
	private String bookmark_User_ID;
	private int bookmark_Recipe_ID;
	private String bookmark_Title;

	public Bookmark(String bookmark_User_ID, int bookmark_Recipe_ID, String bookmark_Title)
	{
		this.bookmark_User_ID = bookmark_User_ID;
		this.bookmark_Recipe_ID = bookmark_Recipe_ID;
		this.bookmark_Title = bookmark_Title;
	}

	public Bookmark(ResultSet rs)
	{
		try
		{
			bookmark_User_ID = rs.getString(1);
			bookmark_Recipe_ID = rs.getInt(2);
			bookmark_Title = rs.getString(3);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
	}

	public String getBookmark_User_ID()
	{
		return bookmark_User_ID;
	}

	public void setBookmark_User_ID(String bookmark_User_ID)
	{
		this.bookmark_User_ID = bookmark_User_ID;
	}

	public int getBookmark_Recipe_ID()
	{
		return bookmark_Recipe_ID;
	}

	public void setBookmark_Recipe_ID(int bookmark_Recipe_ID)
	{
		this.bookmark_Recipe_ID = bookmark_Recipe_ID;
	}

	public String getBookmark_Title()
	{
		return bookmark_Title;
	}

	public void setBookmark_Title(String bookmark_Title)
	{
		this.bookmark_Title = bookmark_Title;
	}

	public String toString()
	{
		return "Bookmark [bookmark_User_ID=" + bookmark_User_ID + ", bookmark_Recipe_ID=" + bookmark_Recipe_ID
				+ ", bookmark_Title=" + bookmark_Title + "]";
	}

	public boolean equals(Object obj)
	{
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Bookmark other = (Bookmark) obj;
		return Objects.equals(bookmark_Recipe_ID, other.bookmark_Recipe_ID)
				&& Objects.equals(bookmark_Title, other.bookmark_Title)
				&& Objects.equals(bookmark_User_ID, other.bookmark_User_ID);
	}
}
