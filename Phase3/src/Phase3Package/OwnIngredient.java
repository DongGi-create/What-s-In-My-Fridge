package Phase3Package;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Objects;

public class OwnIngredient
{
	private String ingredient_Name;
	private int quantity;
	private String unit;
	
	
	public OwnIngredient(String ingredient_Name, int quantity, String unit)
	{
		this.ingredient_Name = ingredient_Name;
		this.quantity = quantity;
		this.unit = unit;
	}

	public OwnIngredient(ResultSet rs)
	{
		try
		{
			this.ingredient_Name = rs.getString(1);
			this.quantity = rs.getInt(2);
			this.unit = rs.getString(3);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
	}

	public String getIngredient_Name()
	{
		return ingredient_Name;
	}

	public void setIngredient_Name(String ingredient_Name)
	{
		this.ingredient_Name = ingredient_Name;
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

	public String toString() {
        return "Ingredient: " + ingredient_Name + ", Quantity: " + quantity + ", Unit: " + unit;
    }

	public boolean equals(Object obj)
	{
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		OwnIngredient other = (OwnIngredient) obj;
		return Objects.equals(ingredient_Name, other.ingredient_Name) && quantity == other.quantity && Objects.equals(unit, other.unit);
	}
}