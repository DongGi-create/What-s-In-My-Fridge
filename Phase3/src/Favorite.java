
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Objects;

public class Favorite
{
	private String like_User_ID;
	private int like_Recipe_ID;
	private Timestamp like_time;

	public Favorite(String like_User_ID, int like_Recipe_ID)
	{
		this.like_User_ID = like_User_ID;
		this.like_Recipe_ID = like_Recipe_ID;
	}

	public Favorite(ResultSet rs)
	{
		try
		{
			like_User_ID = rs.getString(1);
			like_Recipe_ID = rs.getInt(2);
			like_time = rs.getTimestamp(3);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

	}

	public String getLike_User_ID()
	{
		return like_User_ID;
	}

	public void setLike_User_ID(String like_User_ID)
	{
		this.like_User_ID = like_User_ID;
	}

	public int getLike_Recipe_ID()
	{
		return like_Recipe_ID;
	}

	public void setLike_Recipe_ID(int like_Recipe_ID)
	{
		this.like_Recipe_ID = like_Recipe_ID;
	}

	public String toString()
	{
		return "Favorite [like_User_ID=" + like_User_ID + ", like_Recipe_ID=" + like_Recipe_ID + "]";
	}

	public int hashCode()
	{
		return Objects.hash(like_Recipe_ID, like_User_ID);
	}

	public boolean equals(Object obj)
	{
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Favorite other = (Favorite) obj;
		return Objects.equals(like_Recipe_ID, other.like_Recipe_ID) && Objects.equals(like_User_ID, other.like_User_ID);
	}
}
