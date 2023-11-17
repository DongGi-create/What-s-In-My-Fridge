import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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

		System.out.println(user.getUser_ID() + "님 환영합니다.");
		do
		{
			try
			{
				System.out.println("1. 요리, 레시피 검색 2. 냉장고 관리 3. 나의 정보 4. 레시피 작성 5. 종료");
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
				else
				{
					System.out.println("1, 2, 3, 4, 5 중에 선택해주세요.");
					keyboard.nextLine();
				}
			}
			catch (InputMismatchException e)
			{
				System.out.println("1, 2, 3, 4, 5 중에 선택해주세요.");
				keyboard.nextLine();
			}

		} while (select != 5);
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
					searchCuisine(conn);

				}
				else if (select == 3)
				{
					searchRecipe(conn);
				}
				else
				{
					System.out.println("1, 2, 3, 4 중에 선택해주세요.");
					keyboard.nextLine();
				}
			}
			catch (InputMismatchException e)
			{
				System.out.println("1, 2, 3, 4 중에 선택해주세요.");
				keyboard.nextLine();
			}

		} while (select != 4);
	}

	public static void searchCuisine(Connection conn)
	{
		System.out.println("[요리 검색]");
		int select = 0;
		String cuisineName = null;
		Scanner keyboard = new Scanner(System.in);
		ArrayList<Cuisine> Cuisines = new ArrayList<>();

		do
		{
			try
			{
				System.out.println("요리 이름을 입력해주세요: ");
				cuisineName = keyboard.nextLine();
				System.out.println("1. 한식 2. 양식 3. 일식 4. 중식 5. 선택안함");
				select = keyboard.nextInt();

				String query = "SELECT * FROM CUISINE C WHERE C.CUISINE_NAME LIKE ? AND C.CATEGORY LIKE ?";
				PreparedStatement pstmt = conn.prepareStatement(query);
				ResultSet rs = null;

				String[] category =
				{ "한식", "양식", "일식", "중식", "" };
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

			}
			catch (InputMismatchException e)
			{
				System.out.println("1, 2, 3, 4, 5 중에 선택해주세요.");
				keyboard.nextLine();
			}
			catch (SQLException e)
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
				System.out.println("원하시는 요리를 선택하세요 (레시피 보여드립니다)");
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

			}
			catch (InputMismatchException e)
			{
				System.out.println("1~" + c.size() + " 중에 선택해주세요.");
				keyboard.nextLine();
			}
			catch (SQLException e)
			{
				e.printStackTrace();
			}
		} while (!(0 < select && select <= c.size()));
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
				System.out.println("1. 제목으로 검색 2. 내용으로 검색 3. 글쓴이로 검색 4. 뒤로");
				select = keyboard.nextInt();
				if (select == 1)
				{
					String query = "SELECT * FROM RECIPE R WHERE R.title Like \'%";
					retrieveRecipe(conn, "제목으로 검색합니다", query);
				}
				else if (select == 2)
				{
					String query = "SELECT * FROM RECIPE R WHERE R.content Like \'%";
					retrieveRecipe(conn, "내용으로 검색합니다", query);
				}
				else if (select == 3)
				{
					String query = "SELECT * FROM RECIPE R, USERS U WHERE R.Writer_ID = U.User_ID AND U.Name Like \'%";
					retrieveRecipe(conn, "글쓴이로 검색합니다", query);
				}
				else if (select == 4)
				{

				}
				else
				{
					System.out.println("1, 2, 3, 4 중에 선택해주세요.");
					keyboard.nextLine();
				}
			}
			catch (InputMismatchException e)
			{
				System.out.println("1, 2, 3, 4 중에 선택해주세요.");
				keyboard.nextLine();
			}

		} while (!(0 < select && select < 5));
	}
	
	
	
	public static void retrieveRecipe(Connection conn, String text, String query)
	{
		
		Scanner keyboard = new Scanner(System.in);
		System.out.println(text);
		String keyword = keyboard.nextLine();
		query = query + keyword + "%\'";
		ArrayList<Recipe> recipes = new ArrayList<>();
		Statement stmt;
		try {
			stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			
			while (rs.next())
			{
				recipes.add(new Recipe(rs));
				System.out.println(recipes.size() + ". " + rs.getString(3));
			}
			if(recipes.size()==0) {
				System.out.println("해당되는 결과가 존재하지 않습니다..");
				return;
			}
			getDetailRecipe(conn, recipes);
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void getDetailRecipe(Connection conn, ArrayList<Recipe> r)
	{
		int select = 0;
		Scanner keyboard = new Scanner(System.in);
		
		do
		{
			try
			{
				System.out.println("자세히 보고 싶으신 레시피 번호를 입력해주세요");
				select = keyboard.nextInt();
				r.get(select - 1).showRecipe(conn);
			}
			catch (InputMismatchException e)
			{
				System.out.println("1~" + r.size() + " 중에 선택해주세요.");
				keyboard.nextLine();
			}
		} while (!(0 < select && select <= r.size()));
	}
}
