import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.InputMismatchException;
import java.util.Scanner;

public class FridgeManagement
{
	private static Scanner keyboard = new Scanner(System.in);

	public static void showFridge(Connection conn, Users user)
	{
		System.out.println("[냉장고 관리]");
		int select = 0;

		do
		{
			try
			{
				// 냉장고 속 재료를 먼저 보여줌
				showIngredients(conn, user);

				System.out.println("1. 재료 추가하기 2. 재료 빼기 3, 뒤로");
				select = keyboard.nextInt();
				if (select == 1)
				{
					addIngredient(conn, user);
				}
				else if (select == 2)
				{

				}
				else
				{
					System.out.println("1, 2, 3 중에 선택해주세요.");
					keyboard.nextLine();
				}
			}
			catch (InputMismatchException e)
			{
				System.out.println("1, 2 중에 선택해주세요.");
				keyboard.nextLine();
			}

		} while (select != 3);
	}

	public static void showIngredients(Connection conn, Users user)
	{
		System.out.println(user.getUser_ID() + "님의 냉장고에 있는 재료들이에요.");
		System.out.println("-------------------");
		try
		{
			String query = "SELECT\r\n" + "	I.INGREDIENT_NAME,\r\n" + "	O.QUANTITY,\r\n" + "	O.UNIT\r\n" + "FROM\r\n"
					+ "	USERS      U,\r\n" + "	OWN        O,\r\n" + "	INGREDIENT I\r\n" + "WHERE\r\n"
					+ "	    U.USER_ID = O.USER_ID\r\n" + "	AND I.INGREDIENT_ID = O.INGREDIENT_ID\r\n"
					+ "	AND U.User_ID = ?\r\n" + "ORDER BY\r\n" + "	I.INGREDIENT_NAME";
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, user.getUser_ID());
			ResultSet rs = pstmt.executeQuery();
			while (rs.next())
			{
				System.out.println(rs.getString(1) + ": " + rs.getInt(2) + "(" + rs.getString(3) + ")");
			}
			System.out.println();
			rs.close();
			pstmt.close();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

	}

	public static void addIngredient(Connection conn, Users user)
	{
		String query = null;
		boolean isExistIngredientDB = true;
		boolean alreadyHaving = false;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Ingredient insertIngredient = null;
		Own insertOwn = null;

		System.out.println("[냉장고 관리 - 재료 추가하기]");
		// 재료 이름 입력
		do
		{
			System.out.print("재료의 이름을 입력해주세요: ");
			keyboard.nextLine();
			String input = keyboard.nextLine();

			if (input.length() > 40)
			{
				System.out.println("40자 이하로 입력해주세요.");
				continue;
			}

			query = "SELECT * FROM INGREDIENT I WHERE I.INGREDIENT_NAME = ?";
			try
			{
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, input);
				rs = pstmt.executeQuery();
				// Ingredient DB에 사용자가 추가할 재료가 없으면
				if (!rs.isBeforeFirst())
					System.out.println("재료 DB에 존재하지 않는 재료라 추가할 수 없어요.");
				else
				{
					while (rs.next())
						insertIngredient = new Ingredient(rs);
					// System.out.println(insertIngredient);
					isExistIngredientDB = false;
				}
				rs.close();
				pstmt.close();
			}
			catch (SQLException e)
			{
				e.printStackTrace();
			}
		} while (isExistIngredientDB);

		query = "SELECT O.* FROM USERS U, OWN O, INGREDIENT I WHERE U.USER_ID = O.USER_ID AND O.INGREDIENT_ID = I.INGREDIENT_ID AND U.USER_ID = ? AND O.INGREDIENT_ID = ?";
		try
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, user.getUser_ID());
			pstmt.setInt(2, insertIngredient.getIngredient_ID());
			rs = pstmt.executeQuery();
			// 이미 사용자가 재료를 가지고 있으면
			if (rs.isBeforeFirst())
			{
				while (rs.next())
				{
					insertOwn = new Own(rs);
					// System.out.println(insertOwn);
				}
				alreadyHaving = true;
			}
			rs.close();
			pstmt.close();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		// 입력한 재료를 이미 가지고 있다면 알려줌.
		if (alreadyHaving)
		{
			System.out.println("이미 \'" + insertIngredient.getIngredient_Name() + "\'를 \'" + insertOwn.getQuantity()
					+ "(" + insertOwn.getUnit() + ")' 만큼 가지고 계시네요.");
			query = "UPDATE OWN SET OWN.QUANTITY = ?, OWN.UNIT = ? WHERE OWN.USER_ID = ? AND OWN.INGREDIENT_ID = ?";
		}
		else
			query = "INSERT INTO OWN(OWN.QUANTITY, OWN.UNIT, OWN.USER_ID, OWN.INGREDIENT_ID) VALUES(?, ?, ?, ?)";

		// 재료 추가할지 재확인
		int select = 0;
		do
		{
			try
			{
				System.out.println("정말로 재료를 추가하실 건가요?");
				System.out.println("1. 예 2. 아니요");
				select = keyboard.nextInt();
				if (select == 2)
					return;
			}
			catch (InputMismatchException e)
			{
				System.out.println("1, 2 중에 선택해주세요.");
			}
		} while (select != 1 && select != 2);

		// 재료 양 입력
		System.out.println("얼마나 보유하고 계신가요?");
		try
		{
			if (insertOwn == null)
			{
				insertOwn = new Own();
				insertOwn.setIngredient_ID(insertIngredient.getIngredient_ID());
				insertOwn.setUser_ID(user.getUser_ID());
			}
			System.out.println("재료의 양을 숫자로 입력해주세요.");
			insertOwn.setQuantity(keyboard.nextInt());
			System.out.println("재료의 단위를 입력해주세요.");
			insertOwn.setUnit(keyboard.next());
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, insertOwn.getQuantity());
			pstmt.setString(2, insertOwn.getUnit());
			pstmt.setString(3, insertOwn.getUser_ID());
			pstmt.setInt(4, insertOwn.getIngredient_ID());
			int result = pstmt.executeUpdate();

			if (result > 0)
				System.out.println("성공적으로 추가가 완료되었습니다.");
			else
				System.out.println("?");
			System.out.println();
			rs.close();
			pstmt.close();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
		catch (InputMismatchException e)
		{
			System.out.println("잘못된 입력을 하셨습니다.");
		}

	}
}
