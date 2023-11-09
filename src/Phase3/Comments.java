package Phase3;

import java.sql.Timestamp;
import java.util.Objects;

public class Comments {
	private int comment_ID;
	private int recipe_ID;
	private String user_ID;
	private String comment_content;
	private Timestamp comment_time;

	public Comments(int comment_ID, int recipe_ID, String user_ID, String comment_content, Timestamp comment_time) {
		this.comment_ID = comment_ID;
		this.recipe_ID = recipe_ID;
		this.user_ID = user_ID;
		this.comment_content = comment_content;
		this.comment_time = comment_time;
	}

	public int getComment_ID() {
		return comment_ID;
	}

	public void setComment_ID(int comment_ID) {
		this.comment_ID = comment_ID;
	}

	public int getRecipe_ID() {
		return recipe_ID;
	}

	public void setRecipe_ID(int recipe_ID) {
		this.recipe_ID = recipe_ID;
	}

	public String getUser_ID() {
		return user_ID;
	}

	public void setUser_ID(String user_ID) {
		this.user_ID = user_ID;
	}

	public String getComment_content() {
		return comment_content;
	}

	public void setComment_content(String comment_content) {
		this.comment_content = comment_content;
	}

	public Timestamp getComment_time() {
		return comment_time;
	}

	public void setComment_time(Timestamp comment_time) {
		this.comment_time = comment_time;
	}

	public String toString() {
		return "Comments [comment_ID=" + comment_ID + ", recipe_ID=" + recipe_ID + ", user_ID=" + user_ID
				+ ", comment_content=" + comment_content + ", comment_time=" + comment_time + "]";
	}

	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Comments other = (Comments) obj;
		return comment_ID == other.comment_ID && Objects.equals(comment_content, other.comment_content)
				&& Objects.equals(comment_time, other.comment_time) && recipe_ID == other.recipe_ID
				&& Objects.equals(user_ID, other.user_ID);
	}
}
