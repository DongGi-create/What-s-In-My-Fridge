
import java.sql.Date;
import java.sql.Timestamp;
import java.util.Objects;

public class Recipe {
	private int recipe_ID;
	private int cuisine_ID;
	private String title;
	private String writer_ID;
	private Date cooking_Time;
	private int level_NM;
	private String qnt;
	private String content;
	private String link;
	private Timestamp write_Time;

	public Recipe(int recipe_ID, int cuisine_ID, String title, String writer_ID, Date cooking_Time, int level_NM,
			String qnt, String content, String link, Timestamp write_Time) {
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

	public int getRecipe_ID() {
		return recipe_ID;
	}

	public void setRecipe_ID(int recipe_ID) {
		this.recipe_ID = recipe_ID;
	}

	public int getCuisine_ID() {
		return cuisine_ID;
	}

	public void setCuisine_ID(int cuisine_ID) {
		this.cuisine_ID = cuisine_ID;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getWriter_ID() {
		return writer_ID;
	}

	public void setWriter_ID(String writer_ID) {
		this.writer_ID = writer_ID;
	}

	public Date getCooking_Time() {
		return cooking_Time;
	}

	public void setCooking_Time(Date cooking_Time) {
		this.cooking_Time = cooking_Time;
	}

	public int getLevel_NM() {
		return level_NM;
	}

	public void setLevel_NM(int level_NM) {
		this.level_NM = level_NM;
	}

	public String getQnt() {
		return qnt;
	}

	public void setQnt(String qnt) {
		this.qnt = qnt;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getLink() {
		return link;
	}

	public void setLink(String link) {
		this.link = link;
	}

	public Timestamp getWrite_Time() {
		return write_Time;
	}

	public void setWrite_Time(Timestamp write_Time) {
		this.write_Time = write_Time;
	}

	public String toString() {
		return "Recipe [recipe_ID=" + recipe_ID + ", cuisine_ID=" + cuisine_ID + ", title=" + title + ", writer_ID="
				+ writer_ID + ", cooking_Time=" + cooking_Time + ", level_NM=" + level_NM + ", qnt=" + qnt
				+ ", content=" + content + ", link=" + link + ", write_Time=" + write_Time + "]";
	}

	public boolean equals(Object obj) {
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
}
