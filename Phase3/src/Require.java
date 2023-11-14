
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Objects;

public class Require
{
	private int recipe_ID;
	private int ingredient_ID;
	private int quantity;
	private String unit;

	public Require(int recipe_ID, int ingredient_ID, int quantity, String unit)
	{
		this.recipe_ID = recipe_ID;
		this.ingredient_ID = ingredient_ID;
		this.quantity = quantity;
		this.unit = unit;
	}

	public Require(ResultSet rs)
	{
		try
		{
			recipe_ID = rs.getInt(1);
			ingredient_ID = rs.getInt(2);
			quantity = rs.getInt(3);
			unit = rs.getString(4);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
	}

	public int getRecipe_ID()
	{
		return recipe_ID;
	}

	public void setRecipe_ID(int recipe_ID)
	{
		this.recipe_ID = recipe_ID;
	}

	public int getIngredient_ID()
	{
		return ingredient_ID;
	}

	public void setIngredient_ID(int ingredient_ID)
	{
		this.ingredient_ID = ingredient_ID;
	}

	public int getQuantity()
	{
		return quantity;
	}

	public void setQuantity(int quantity)
	{
		this.quantity = quantity;
	}

	public String getUnit()
	{
		return unit;
	}

	public void setUnit(String unit)
	{
		this.unit = unit;
	}

	public String toString()
	{
		return "Require [recipe_ID=" + recipe_ID + ", ingredient_ID=" + ingredient_ID + ", quantity=" + quantity
				+ ", unit=" + unit + "]";
	}

	public boolean equals(Object obj)
	{
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Require other = (Require) obj;
		return ingredient_ID == other.ingredient_ID && quantity == other.quantity && recipe_ID == other.recipe_ID
				&& Objects.equals(unit, other.unit);
	}

}
