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

		System.out.println(user.getUser_ID() + "님 환영합니다.");
		do
		{
			try
			{
				System.out.println("1. 요리, 레시피 검색 2. 냉장고 관리 3. 나의 정보 4. 종료");
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
				System.out.println("1, 2, 3, 4 중에 선택해주세요.");
				keyboard.nextLine();
			}

		} while (select != 4);
	}

	public static void searchPage(Connection conn)
	{
		System.out.println("[요리, 레시피 검색]");
		int select = 0;
		Scanner keyboard = new Scanner(System.in);

		do
		{
			try
			{
				System.out.println("1. 레시피 추천 받기 2. 요리 검색 3. 레시피 검색 4. 뒤로");
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
				System.out.println("1, 2, 3, 4 중에 선택해주세요.");
				keyboard.nextLine();
			}

		} while (select != 4);
	}

	public static void searchRecipe(Connection conn)
	{
		System.out.println("[레시피 검색]");
		int select = 0;
		Scanner keyboard = new Scanner(System.in);

		do
		{
			try
			{
				System.out.println("1. 제목으로 검색 2. 내용으로 검색 3. 글쓴이로 검색 4. 댓글로 검색 5. 뒤로");
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
				System.out.println("1, 2, 3, 4 중에 선택해주세요.");
				keyboard.nextLine();
			}

		} while (select != 4);
	}
}
