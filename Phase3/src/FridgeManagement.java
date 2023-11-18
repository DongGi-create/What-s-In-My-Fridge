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
		System.out.println("[����� ����]");
		int select = 0;

		do
		{
			try
			{
				// ����� �� ��Ḧ ���� ������
				showIngredients(conn, user);

				System.out.println("1. ��� �߰��ϱ� 2. ��� ���� 3, �ڷ�");
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
					System.out.println("1, 2, 3 �߿� �������ּ���.");
					keyboard.nextLine();
				}
			}
			catch (InputMismatchException e)
			{
				System.out.println("1, 2 �߿� �������ּ���.");
				keyboard.nextLine();
			}

		} while (select != 3);
	}

	public static void showIngredients(Connection conn, Users user)
	{
		System.out.println(user.getUser_ID() + "���� ����� �ִ� �����̿���.");
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

		System.out.println("[����� ���� - ��� �߰��ϱ�]");
		// ��� �̸� �Է�
		do
		{
			System.out.print("����� �̸��� �Է����ּ���: ");
			keyboard.nextLine();
			String input = keyboard.nextLine();

			if (input.length() > 40)
			{
				System.out.println("40�� ���Ϸ� �Է����ּ���.");
				continue;
			}

			query = "SELECT * FROM INGREDIENT I WHERE I.INGREDIENT_NAME = ?";
			try
			{
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, input);
				rs = pstmt.executeQuery();
				// Ingredient DB�� ����ڰ� �߰��� ��ᰡ ������
				if (!rs.isBeforeFirst())
					System.out.println("��� DB�� �������� �ʴ� ���� �߰��� �� �����.");
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
			// �̹� ����ڰ� ��Ḧ ������ ������
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

		// �Է��� ��Ḧ �̹� ������ �ִٸ� �˷���.
		if (alreadyHaving)
		{
			System.out.println("�̹� \'" + insertIngredient.getIngredient_Name() + "\'�� \'" + insertOwn.getQuantity()
					+ "(" + insertOwn.getUnit() + ")' ��ŭ ������ ��ó׿�.");
			query = "UPDATE OWN SET OWN.QUANTITY = ?, OWN.UNIT = ? WHERE OWN.USER_ID = ? AND OWN.INGREDIENT_ID = ?";
		}
		else
			query = "INSERT INTO OWN(OWN.QUANTITY, OWN.UNIT, OWN.USER_ID, OWN.INGREDIENT_ID) VALUES(?, ?, ?, ?)";

		// ��� �߰����� ��Ȯ��
		int select = 0;
		do
		{
			try
			{
				System.out.println("������ ��Ḧ �߰��Ͻ� �ǰ���?");
				System.out.println("1. �� 2. �ƴϿ�");
				select = keyboard.nextInt();
				if (select == 2)
					return;
			}
			catch (InputMismatchException e)
			{
				System.out.println("1, 2 �߿� �������ּ���.");
			}
		} while (select != 1 && select != 2);

		// ��� �� �Է�
		System.out.println("�󸶳� �����ϰ� ��Ű���?");
		try
		{
			if (insertOwn == null)
			{
				insertOwn = new Own();
				insertOwn.setIngredient_ID(insertIngredient.getIngredient_ID());
				insertOwn.setUser_ID(user.getUser_ID());
			}
			System.out.println("����� ���� ���ڷ� �Է����ּ���.");
			insertOwn.setQuantity(keyboard.nextInt());
			System.out.println("����� ������ �Է����ּ���.");
			insertOwn.setUnit(keyboard.next());
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, insertOwn.getQuantity());
			pstmt.setString(2, insertOwn.getUnit());
			pstmt.setString(3, insertOwn.getUser_ID());
			pstmt.setInt(4, insertOwn.getIngredient_ID());
			int result = pstmt.executeUpdate();

			if (result > 0)
				System.out.println("���������� �߰��� �Ϸ�Ǿ����ϴ�.");
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
			System.out.println("�߸��� �Է��� �ϼ̽��ϴ�.");
		}

	}
}
