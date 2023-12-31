package Phase3Package;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Objects;

public class Ingredient
{
	private int ingredient_ID;
	private String ingredient_Name;

	public Ingredient() {
		
	}
	public Ingredient(int ingredient_ID, String ingredient_Name)
	{
		this.ingredient_ID = ingredient_ID;
		this.ingredient_Name = ingredient_Name;
	}

	public Ingredient(ResultSet rs)
	{
		try
		{
			ingredient_ID = rs.getInt(1);
			ingredient_Name = rs.getString(2);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

	}

	public int getIngredient_ID()
	{
		return ingredient_ID;
	}

	public void setIngredient_ID(int ingredient_ID)
	{
		this.ingredient_ID = ingredient_ID;
	}

	public String getIngredient_Name()
	{
		return ingredient_Name;
	}

	public void setIngredient_Name(String ingredient_Name)
	{
		this.ingredient_Name = ingredient_Name;
	}

	public String toString()
	{
		return "Ingredient [ingredient_ID=" + ingredient_ID + ", ingredient_Name=" + ingredient_Name + "]";
	}

	public void Print() {
		System.out.println("print: "+this.toString());
	}
	public boolean equals(Object obj)
	{
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Ingredient other = (Ingredient) obj;
		return ingredient_ID == other.ingredient_ID && Objects.equals(ingredient_Name, other.ingredient_Name);
	}
}
