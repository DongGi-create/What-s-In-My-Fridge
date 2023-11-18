import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.InputMismatchException;
import java.util.Scanner;

public class FridgeManagement
{
	public static void showFridge(Connection conn, Users user)
	{
		System.out.println("[����� ����]");
		int select = 0;
		Scanner keyboard = new Scanner(System.in);
		String query = null;
		
		do
		{
			try
			{
				System.out.println(user.getUser_ID() + "���� ����� �ִ� �����̿���.");
				
				query = "SELECT\r\n" + "	I.INGREDIENT_NAME,\r\n" + "	O.QUANTITY,\r\n" + "	O.UNIT\r\n" + "FROM\r\n"
						+ "	USERS      U,\r\n" + "	OWN        O,\r\n" + "	INGREDIENT I\r\n" + "WHERE\r\n"
						+ "	    U.USER_ID = O.USER_ID\r\n" + "	AND I.INGREDIENT_ID = O.INGREDIENT_ID\r\n"
						+ "	AND U.User_ID = ?\r\n" + "ORDER BY\r\n" + "	I.INGREDIENT_NAME";
				PreparedStatement pstmt = conn.prepareStatement(query);
				pstmt.setString(1, user.getUser_ID());
				ResultSet rs = pstmt.executeQuery();
				while (rs.next())
				{
					System.out.println(rs.getString(1) + ": " + rs.getInt(2) + " " + rs.getString(3));
				}
				
				System.out.println("\n");
				System.out.println("1. ����� ��� �߰��ϱ� 2. ������� ��� ���� 3, �ڷ�");
				select = keyboard.nextInt();
				if (select == 1)
				{

				}
				else if (select == 2)
				{

				}
				else
				{
					System.out.println("1, 2, 3 �߿� �������ּ���.");
					keyboard.nextLine();
				}
				rs.close();
				pstmt.close();
			}
			catch (InputMismatchException e)
			{
				System.out.println("1, 2 �߿� �������ּ���.");
				keyboard.nextLine();
			}
			catch (SQLException e)
			{
				e.printStackTrace();
			}

		} while (select != 3);
	}
}
