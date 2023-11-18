
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Objects;

public class Own
{
	private String user_ID;
	private int ingredient_ID;
	private int quantity;
	private String unit;

	public Own(String user_ID, int ingredient_ID, int quantity, String unit)
	{
		this.user_ID = user_ID;
		this.ingredient_ID = ingredient_ID;
		this.quantity = quantity;
		this.unit = unit;
	}

	public Own(ResultSet rs)
	{
		try
		{
			this.user_ID = rs.getString(1);
			this.ingredient_ID = rs.getInt(2);
			this.quantity = rs.getInt(3);
			this.unit = rs.getString(4);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
	}

	public String getUser_ID()
	{
		return user_ID;
	}

	public void setUser_ID(String user_ID)
	{
		this.user_ID = user_ID;
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
		return "Own [user_ID=" + user_ID + ", ingredient_ID=" + ingredient_ID + ", quantity=" + quantity + ", unit="
				+ unit + "]";
	}

	public boolean equals(Object obj)
	{
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Own other = (Own) obj;
		return ingredient_ID == other.ingredient_ID && quantity == other.quantity && Objects.equals(unit, other.unit)
				&& Objects.equals(user_ID, other.user_ID);
	}
}
