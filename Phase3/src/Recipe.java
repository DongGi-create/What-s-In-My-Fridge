
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Objects;

import oracle.sql.INTERVALDS;

public class Recipe
{
	private int recipe_ID;
	private int cuisine_ID;
	private String title;
	private String writer_ID;
	private INTERVALDS cooking_Time;
	private int level_NM;
	private String qnt;
	private String content;
	private String link;
	private Timestamp write_Time;

	public Recipe(int recipe_ID, int cuisine_ID, String title, String writer_ID, INTERVALDS cooking_Time, int level_NM,
			String qnt, String content, String link, Timestamp write_Time)
	{
		this.recipe_ID = recipe_ID;
		this.cuisine_ID = cuisine_ID;
		this.title = title;
		this.writer_ID = writer_ID;
		this.cooking_Time = cooking_Time;
		this.level_NM = level_NM;
		this.qnt = qnt;
		this.content = content;
		this.link = link;
		this.write_Time = write_Time;
	}

	public Recipe(ResultSet rs) throws SQLException
	{
		this.recipe_ID = rs.getInt(1);
		this.cuisine_ID = rs.getInt(2);
		this.title = rs.getString(3);
		this.writer_ID = rs.getString(4);
		this.cooking_Time = (INTERVALDS) rs.getObject(5);
		this.level_NM = rs.getInt(6);
		this.qnt = rs.getString(7);
		this.content = rs.getString(8);
		this.link = rs.getString(9);
		this.write_Time = rs.getTimestamp(10);
	}

	public int getRecipe_ID()
	{
		return recipe_ID;
	}

	public void setRecipe_ID(int recipe_ID)
	{
		this.recipe_ID = recipe_ID;
	}

	public int getCuisine_ID()
	{
		return cuisine_ID;
	}

	public void setCuisine_ID(int cuisine_ID)
	{
		this.cuisine_ID = cuisine_ID;
	}

	public String getTitle()
	{
		return title;
	}

	public void setTitle(String title)
	{
		this.title = title;
	}

	public String getWriter_ID()
	{
		return writer_ID;
	}

	public void setWriter_ID(String writer_ID)
	{
		this.writer_ID = writer_ID;
	}

	public INTERVALDS getCooking_Time()
	{
		return cooking_Time;
	}

	public void setCooking_Time(INTERVALDS cooking_Time)
	{
		this.cooking_Time = cooking_Time;
	}

	public int getLevel_NM()
	{
		return level_NM;
	}

	public void setLevel_NM(int level_NM)
	{
		this.level_NM = level_NM;
	}

	public String getQnt()
	{
		return qnt;
	}

	public void setQnt(String qnt)
	{
		this.qnt = qnt;
	}

	public String getContent()
	{
		return content;
	}

	public void setContent(String content)
	{
		this.content = content;
	}

	public String getLink()
	{
		return link;
	}

	public void setLink(String link)
	{
		this.link = link;
	}

	public Timestamp getWrite_Time()
	{
		return write_Time;
	}

	public void setWrite_Time(Timestamp write_Time)
	{
		this.write_Time = write_Time;
	}

	public String toString()
	{
		return "Recipe [recipe_ID=" + recipe_ID + ", cuisine_ID=" + cuisine_ID + ", title=" + title + ", writer_ID="
				+ writer_ID + ", cooking_Time=" + cooking_Time + ", level_NM=" + level_NM + ", qnt=" + qnt
				+ ", content=" + content + ", link=" + link + ", write_Time=" + write_Time + "]";
	}

	public boolean equals(Object obj)
	{
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Recipe other = (Recipe) obj;
		return Objects.equals(content, other.content) && Objects.equals(cooking_Time, other.cooking_Time)
				&& cuisine_ID == other.cuisine_ID && level_NM == other.level_NM && Objects.equals(link, other.link)
				&& Objects.equals(qnt, other.qnt) && recipe_ID == other.recipe_ID && Objects.equals(title, other.title)
				&& Objects.equals(write_Time, other.write_Time) && Objects.equals(writer_ID, other.writer_ID);
	}

	public void showRecipe(Connection conn)
	{
		System.out.println("제목:" + title);
		System.out.println("작성자: " + writer_ID + "   작성 시간: " + write_Time);
		try
		{
			String query = "SELECT * FROM CUISINE C WHERE C.Cuisine_ID = ?";
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, this.cuisine_ID);

			ResultSet rs = pstmt.executeQuery();
			while (rs.next())
			{
				System.out.println("요리 이름: " + rs.getString(2) + "   종류: " + rs.getString(3));
			}

			rs.close();
			pstmt.close();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		System.out.println("요리 시간: " + cooking_Time + "   난이도: " + level_NM + "   양: " + qnt + "\n");
		System.out.println(content);
		System.out.println("참고 링크: " + link + "\n");
	}
}
