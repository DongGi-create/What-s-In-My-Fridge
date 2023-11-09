
import java.util.Objects;

public class Cuisine {
	private int cuisine_ID;
	private String cuisine_Name;
	private String category;

	public Cuisine(int cuisine_ID, String cuisine_Name, String category) {
		this.cuisine_ID = cuisine_ID;
		this.cuisine_Name = cuisine_Name;
		this.category = category;
	}

	public int getCuisine_ID() {
		return cuisine_ID;
	}

	public void setCuisine_ID(int cuisine_ID) {
		this.cuisine_ID = cuisine_ID;
	}

	public String getCuisine_Name() {
		return cuisine_Name;
	}

	public void setCuisine_Name(String cuisine_Name) {
		this.cuisine_Name = cuisine_Name;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String toString() {
		return "Cuisine [cuisine_ID=" + cuisine_ID + ", cuisine_Name=" + cuisine_Name + ", category=" + category + "]";
	}

	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Cuisine other = (Cuisine) obj;
		return Objects.equals(category, other.category) && cuisine_ID == other.cuisine_ID
				&& Objects.equals(cuisine_Name, other.cuisine_Name);
	}

}
