import java.sql.Connection;
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
				System.out.println("1. �丮, ������ �˻� 2. ����� ���� 3. ���� ���� 4. ����");
				select = keyboard.nextInt();
				if (select == 1)
				{

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
				System.out.println("1, 2, 3, 4 �߿� �������ּ���.");
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

				}
				else if (select == 3)
				{

				}
			} catch (InputMismatchException e)
			{
				System.out.println("1, 2, 3, 4 �߿� �������ּ���.");
				keyboard.nextLine();
			}

		} while (select != 4);
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
