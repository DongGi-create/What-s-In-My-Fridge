import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.InputMismatchException;
import java.util.Scanner;

public class UserPages
{

	public static void mainPage(Connection conn, Users user)
	{
		if (user == null)
			return;
		int select = 0;
		Scanner keyboard = new Scanner(System.in);

		System.out.println(user.getUser_ID() + "�� ȯ���մϴ�.");
		do
		{
			try
			{
				System.out.println("1. �丮, ������ �˻� 2. ����� ���� 3. ���� ���� 4. ������ �ۼ� 5. ����");
				select = keyboard.nextInt();
				if (select == 1)
				{
					searchPage(conn);
				}
				else if (select == 2)
				{

				}
				else if (select == 3)
				{

				}
				else if (select == 4)
				{

				}
			} catch (InputMismatchException e)
			{
				System.out.println("1, 2, 3, 4, 5 �߿� �������ּ���.");
				keyboard.nextLine();
			}

		} while (select != 4);
	}

	public static void searchPage(Connection conn)
	{
		System.out.println("[�丮, ������ �˻�]");
		int select = 0;
		Scanner keyboard = new Scanner(System.in);

		do
		{
			try
			{
				System.out.println("1. ������ ��õ �ޱ� 2. �丮 �˻� 3. ������ �˻� 4. �ڷ�");
				select = keyboard.nextInt();
				if (select == 1)
				{

				}
				else if (select == 2)
				{
					searchCuisine(conn);

				}
				else if (select == 3)
				{
					searchRecipe(conn);
				}
			} catch (InputMismatchException e)
			{
				System.out.println("1, 2, 3, 4 �߿� �������ּ���.");
				keyboard.nextLine();
			}

		} while (select != 4);
	}

	public static void searchCuisine(Connection conn)
	{
		System.out.println("[�丮 �˻�]");
		int select = 0;
		String cuisineName = null;
		Scanner keyboard = new Scanner(System.in);
		ArrayList<Cuisine> Cuisines = new ArrayList<>();

		do
		{
			try
			{
				System.out.println("�丮 �̸��� �Է����ּ���: ");
				cuisineName = keyboard.nextLine();
				System.out.println("1. �ѽ� 2. ��� 3. �Ͻ� 4. �߽� 5. ���þ���");
				select = keyboard.nextInt();

				String query = "SELECT * FROM CUISINE C WHERE C.CUISINE_NAME LIKE ? AND C.CATEGORY LIKE ?";
				PreparedStatement pstmt = conn.prepareStatement(query);
				ResultSet rs = null;

				String[] category =
				{ "�ѽ�", "���", "�Ͻ�", "�߽�", "" };
				pstmt.setString(1, "%" + cuisineName + "%");
				pstmt.setString(2, "%" + category[0 < select && select < 5 ? select - 1 : 4] + "%");

				rs = pstmt.executeQuery();
				while (rs.next())
				{
					Cuisines.add(new Cuisine(rs));
					System.out.println(Cuisines.size() + ". " + rs.getString(2) + "|" + rs.getString(3));
				}
				getRecipe(conn, Cuisines);
				rs.close();
				pstmt.close();

			} catch (InputMismatchException e)
			{
				System.out.println("1, 2, 3, 4 �߿� �������ּ���.");
				keyboard.nextLine();
			} catch (SQLException e)
			{
				e.printStackTrace();
			}
		} while (!(0 < select && select < 5));

	}

	public static void getRecipe(Connection conn, ArrayList<Cuisine> c)
	{
		int select = 0;
		Scanner keyboard = new Scanner(System.in);
		ArrayList<Recipe> recipes = new ArrayList<>();

		do
		{
			try
			{
				System.out.println("���Ͻô� �丮�� �����ϼ��� (������ �����帳�ϴ�)");
				select = keyboard.nextInt();
				String query = "SELECT * FROM RECIPE R WHERE R.CUISINE_ID = ?";
				PreparedStatement pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, c.get(select - 1).getCuisine_ID());
				ResultSet rs = pstmt.executeQuery();
				while (rs.next())
				{
					recipes.add(new Recipe(rs));
					recipes.get(recipes.size() - 1).showRecipe(conn);
				}
				rs.close();
				pstmt.close();

			} catch (InputMismatchException e)
			{
				System.out.println("1~" + c.size() + " �߿� �������ּ���.");
				keyboard.nextLine();
			} catch (SQLException e)
			{
				e.printStackTrace();
			}
		} while (!(0 < select && select <= c.size()));
	}

	public static void searchRecipe(Connection conn)
	{
		System.out.println("[������ �˻�]");
		int select = 0;
		Scanner keyboard = new Scanner(System.in);

		do
		{
			try
			{
				System.out.println("1. �������� �˻� 2. �������� �˻� 3. �۾��̷� �˻� 4. ��۷� �˻� 5. �ڷ�");
				select = keyboard.nextInt();
				if (select == 1)
				{

				}
				else if (select == 2)
				{

				}
				else if (select == 3)
				{

				} // Q10
				else if (select == 4)
				{

				}
			} catch (InputMismatchException e)
			{
				System.out.println("1, 2, 3, 4 �߿� �������ּ���.");
				keyboard.nextLine();
			}

		} while (select != 4);
	}
}
