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

		System.out.println(user.getUser_ID() + "�� ȯ���մϴ�.");
		
		String Q10 = "SELECT\r\n"
				+ "   U.User_id\r\n"
				+ "FROM\r\n"
				+ "   USERS U\r\n"
				+ "WHERE\r\n"
				+ "   EXISTS (\r\n"
				+ "      SELECT\r\n"
				+ "         *\r\n"
				+ "      FROM\r\n"
				+ "         COMMENTS C\r\n"
				+ "      WHERE\r\n"
				+ "         c.User_id = U.User_id\r\n"
				+ "   )";
		
		do
		{
			try
			{
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery(Q10);
				boolean noComment = true;
				while(rs.next()) {
					if(user.getUser_ID().equals(rs.getString(1)))noComment = false;
				}
				if(noComment) {
					System.out.println("���� ����� �ѹ��� ���� �����̾��.!! �ѹ� �Ẹ�ô°� ��Ű���?");
				}
				else {
					System.out.println("����� �Ẹ�̱���!! �����ε� �� ��Ź�帳�ϴ�.!");
				}
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
				else
				{
					System.out.println("1, 2, 3, 4, 5 �߿� �������ּ���.");
					keyboard.nextLine();
				}
			}
			catch (InputMismatchException e)
			{
				System.out.println("1, 2, 3, 4, 5 �߿� �������ּ���.");
				keyboard.nextLine();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		} while (select != 5);
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
				else
				{
					System.out.println("1, 2, 3, 4 �߿� �������ּ���.");
					keyboard.nextLine();
				}
			}
			catch (InputMismatchException e)
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
				if(Cuisines.size()==0) {
					System.out.println("�˻� ����� �����ϴ�..");
				}
				else {
					getRecipe(conn, Cuisines);
				}
				rs.close();
				pstmt.close();

			}
			catch (InputMismatchException e)
			{
				System.out.println("1, 2, 3, 4, 5 �߿� �������ּ���.");
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
				System.out.println("���Ͻô� �丮�� �����ϼ��� (������ �����帳�ϴ�)");
				select = keyboard.nextInt();
				String query = "SELECT * FROM RECIPE R WHERE R.CUISINE_ID = ?";
				String Q5 = "SELECT\r\n"
						+ "   U.NAME\r\n"
						+ "FROM\r\n"
						+ "   USERS   U,\r\n"
						+ "   CUISINE C,\r\n"
						+ "   RECIPE  R\r\n"
						+ "WHERE\r\n"
						+ "       U.USER_ID = R.WRITER_ID\r\n"
						+ "   AND R.CUISINE_ID = C.CUISINE_ID\r\n"
						+ "   AND C.CUISINE_NAME = ?";
				String Q11 = "SELECT\r\n"
						+ "   I.INGREDIENT_NAME\r\n"
						+ "FROM\r\n"
						+ "   INGREDIENT I\r\n"
						+ "WHERE\r\n"
						+ "   I.INGREDIENT_ID IN (\r\n"
						+ "      SELECT\r\n"
						+ "         REQUIRE.INGREDIENT_ID\r\n"
						+ "      FROM\r\n"
						+ "         REQUIRE, RECIPE, CUISINE\r\n"
						+ "      WHERE\r\n"
						+ "             REQUIRE.RECIPE_ID = RECIPE.RECIPE_ID\r\n"
						+ "         AND RECIPE.CUISINE_ID = CUISINE.CUISINE_ID\r\n"
						+ "         AND CUISINE.CUISINE_NAME = ?)";
				
				PreparedStatement pstmt = conn.prepareStatement(query);
				PreparedStatement pstmt5 = conn.prepareStatement(Q5);
				PreparedStatement pstmt11 = conn.prepareStatement(Q11);
				
				pstmt.setInt(1, c.get(select - 1).getCuisine_ID());
				String selectedCuisineName = c.get(select-1).getCuisine_Name();
				pstmt5.setString(1, selectedCuisineName);
				pstmt11.setString(1, selectedCuisineName);
				
				ResultSet rs = pstmt.executeQuery();
				ResultSet rs5 = pstmt5.executeQuery();
				ResultSet rs11 = pstmt11.executeQuery();
				
				while (rs.next())
				{
					recipes.add(new Recipe(rs));
					recipes.get(recipes.size() - 1).showRecipe(conn);
					
				}
				if(recipes.size()==0) {
					System.out.println("�ش� �丮�� �����ǰ� ���� �ۼ����� �ʾҽ��ϴ�..");
				}
				else {
					System.out.println("Q5. �ش� �丮�� ���� �����Ǹ� �ۼ��� ������ �̸� ��ȸ");
					while (rs5.next())
					{
						System.out.println("���� " + rs5.getString(1));
					}
					System.out.println("Q11. "+ selectedCuisineName +"�� �ʿ��� ��� ��ȸ");
					while (rs11.next())
					{
						System.out.println("��� " + rs11.getString(1));
					}

				}								
				rs5.close();
				pstmt5.close();
				rs.close();
				pstmt.close();
				rs11.close();
				pstmt11.close();

			}
			catch (InputMismatchException e)
			{
				System.out.println("1~" + c.size() + " �߿� �������ּ���.");
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
		System.out.println("[������ �˻�]");
		int select = 0;
		Scanner keyboard = new Scanner(System.in);

		do
		{
			try
			{
				System.out.println("1. �������� �˻� 2. �������� �˻� 3. �۾��̷� �˻� 4. �ڷ�");
				select = keyboard.nextInt();
				if (select == 1)
				{
					String query = "SELECT * FROM RECIPE R WHERE R.title Like \'%";
					retrieveQ1(conn);
					retrieveRecipe(conn, "������ �Է��Ͻø� �������� �˻��մϴ�", query);

				}
				else if (select == 2)
				{
					String query = "SELECT * FROM RECIPE R WHERE R.content Like \'%";
					retrieveRecipe(conn, "������ �Է��Ͻø� �������� �˻��մϴ�", query);
				}
				else if (select == 3)
				{
					String query = "SELECT * FROM RECIPE R, USERS U WHERE R.Writer_ID = U.User_ID AND U.Name Like \'%";
					retrieveRecipe(conn, "�۾��̷� �˻��մϴ�", query);
				}
				else if (select == 4)
				{

				}
				else
				{
					System.out.println("1, 2, 3, 4 �߿� �������ּ���.");
					keyboard.nextLine();
				}
			}
			catch (InputMismatchException e)
			{
				System.out.println("1, 2, 3, 4 �߿� �������ּ���.");
				keyboard.nextLine();
			}

		} while (!(0 < select && select < 5));
	}
	
	public static void retrieveQ1(Connection conn)
	{
		String Q1 = "SELECT\r\n"
				+ "   R.WRITE_TIME,\r\n"
				+ "   R.TITLE\r\n"
				+ "FROM\r\n"
				+ "   RECIPE R\r\n"
				+ "WHERE\r\n"
				+ "   R.TITLE LIKE \'%";

		Scanner keyboard = new Scanner(System.in);
		System.out.println("������ ������ �Է��Ͻø� �� �������� �ۼ� �ð��� �̸��� ����ص帳�ϴ�.");
		String keyword = keyboard.nextLine();
		Q1 = Q1 + keyword + "%\'";
		Statement stmt;
		try {
			stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(Q1);
			int count = 0;
			while (rs.next())
			{
				System.out.println("�ۼ��ð�: "+rs.getString(1)+", ������ �̸�: "+rs.getString(2));
				count++;
			}
			rs.close();
			stmt.close();
			if(count == 0) {
				System.out.println("�ش�Ǵ� ����� �������� �ʽ��ϴ�..");
				return;
			}
		}catch (InputMismatchException e) {
			System.out.println("������ ������ �Է��Ͻø� �� �������� �ۼ� �ð��� �̸��� ����ص帳�ϴ� String���� �Է����ּ���.");
			keyboard.nextLine();
		} catch (SQLException e) {
			e.printStackTrace();
		}
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
			rs.close();
			stmt.close();
			if(recipes.size()==0) {
				System.out.println("�ش�Ǵ� ����� �������� �ʽ��ϴ�..");
				return;
			}
			getDetailRecipe(conn, recipes);
		}catch (InputMismatchException e) {
			System.out.println("�˻��� ������"+ text + "�� �Է����ּ���..");
			keyboard.nextLine();
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
				System.out.println("�ڼ��� ���� ������ ������ ��ȣ�� �Է����ּ���");
				select = keyboard.nextInt();
				r.get(select - 1).showRecipe(conn);
			}
			catch (InputMismatchException e)
			{
				System.out.println("1~" + r.size() + " �߿� �������ּ���.");
				keyboard.nextLine();
			}
		} while (!(0 < select && select <= r.size()));
	}
	
	public static void statsPage(Connection conn) {
		int select = 0;
		Scanner keyboard = new Scanner(System.in);
		
		do
		{
			try {
				System.out.println("[��� �м� ������]");
				System.out.println("1. ��Ȱ������ ���� 2. ���� ���� ���� 3. Ȱ���� ���� ��ŷ 4. �ڷ�");
				select = keyboard.nextInt();
				
				if (select == 1) 
					getInactiveUserRatio(conn);
				else if (select == 2)
					getUserAgeDistribution(conn);
				else if (select == 3)
					getActiveUserRanking(conn);
				
			} catch (InputMismatchException e) {
				System.out.println("1~4 �߿� �������ּ���.");
				keyboard.nextLine();
			}
		} while (select != 4);
	}
	
	public static void getInactiveUserRatio(Connection conn) {
		//Phase2 - Q9 Ȱ��. Order by ���� ���ְ� �����Լ��� ����.
		String sql1 = "SELECT\r\n"
				+ "	count(U.USER_ID) as inactives\r\n"
				+ "FROM\r\n"
				+ "	USERS U\r\n"
				+ "WHERE\r\n"
				+ "	NOT EXISTS (\r\n"
				+ "		SELECT\r\n"
				+ "			*\r\n"
				+ "		FROM\r\n"
				+ "			RECIPE R\r\n"
				+ "		WHERE\r\n"
				+ "			R.WRITER_ID = U.USER_ID\r\n"
				+ "	)";
		String sql2 = "SELECT COUNT(*) as total FROM USERS";
		
		try {
			Statement stmt = conn.createStatement();
			int inactives = 0, total = 0;
			ResultSet rs1 = stmt.executeQuery(sql1);
			if(rs1.next()) 
				inactives = rs1.getInt(1);
			ResultSet rs2 = stmt.executeQuery(sql2);
			if(rs2.next())
				total = rs2.getInt(1);
			//System.out.println(""+inactives+" "+total);
			
			if (total < 1)
				System.out.println("���� ȸ���� ����� �Ф�");
			else 
				System.out.println(inactives/(float)total*100+"%�� ȸ���Ե��� ���� Ȱ���� ���ϼ̾��! �ٰ��� ��������!");
			
			rs1.close(); rs2.close(); stmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public static void getUserAgeDistribution(Connection conn) {
		//Phase2 - Q13 Ȱ��. ���ı��� ����.
		String sql = "SELECT\r\n"
				+ "	AGE_GROUP,\r\n"
				+ "	COUNT(*) CNT\r\n"
				+ "FROM\r\n"
				+ "	(\r\n"
				+ "		SELECT\r\n"
				+ "			CASE\r\n"
				+ "			    WHEN Age < 10              THEN\r\n"
				+ "			        '9�� ����'\r\n"
				+ "			    WHEN Age BETWEEN 10 AND 19 THEN\r\n"
				+ "			        '10��'\r\n"
				+ "			    WHEN Age BETWEEN 20 AND 29 THEN\r\n"
				+ "			        '20��'\r\n"
				+ "			    WHEN Age BETWEEN 30 AND 39 THEN\r\n"
				+ "			        '30��'\r\n"
				+ "			    WHEN Age BETWEEN 40 AND 49 THEN\r\n"
				+ "			        '40��'\r\n"
				+ "			    WHEN Age BETWEEN 50 AND 59 THEN\r\n"
				+ "			        '50��'\r\n"
				+ "			    WHEN Age >= 60             THEN\r\n"
				+ "			        '60�� �̻�'\r\n"
				+ "			END AS AGE_GROUP\r\n"
				+ "		FROM\r\n"
				+ "			(\r\n"
				+ "				SELECT\r\n"
				+ "					User_ID,\r\n"
				+ "					Sex,\r\n"
				+ "					Birth,\r\n"
				+ "					TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE),\r\n"
				+ "					                     BIRTH) / 12) AS Age\r\n"
				+ "				FROM\r\n"
				+ "					USERS\r\n"
				+ "			)\r\n"
				+ "	)\r\n"
				+ "GROUP BY\r\n"
				+ "	AGE_GROUP\r\n"
				+ "ORDER BY\r\n"
				+ "	AGE_GROUP ASC";
		
		try {
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(sql);
			while (rs.next()) {
				String groupName = rs.getString(1);
				int cnt = rs.getInt(2);
				System.out.println(groupName+": "+cnt+"��");
			}
			rs.close(); stmt.close();
		}catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
	public static void getActiveUserRanking(Connection conn) {
		//Phase2 - Q14 Ȱ��. ���� ���� ����� id�� ����ϴ°� �ƴ� ���� 10���� �̸��� ����ϵ��� ����.
		String sql = "SELECT\r\n"
				+ "	name, S\r\n"
				+ "FROM\r\n"
				+ "	(\r\n"
				+ "		SELECT\r\n"
				+ "			SUM(Ccnt + Fcnt) AS S,\r\n"
				+ "			T1.id\r\n"
				+ "		FROM\r\n"
				+ "			     (\r\n"
				+ "				SELECT\r\n"
				+ "					COUNT(*)  AS Ccnt,\r\n"
				+ "					C.User_id AS id\r\n"
				+ "				FROM\r\n"
				+ "					COMMENTS C\r\n"
				+ "				GROUP BY\r\n"
				+ "					C.User_id\r\n"
				+ "			) T1\r\n"
				+ "			JOIN (\r\n"
				+ "				SELECT\r\n"
				+ "					COUNT(*)       AS Fcnt,\r\n"
				+ "					F.Like_user_id AS id\r\n"
				+ "				FROM\r\n"
				+ "					FAVORITE F\r\n"
				+ "				GROUP BY\r\n"
				+ "					F.Like_user_id\r\n"
				+ "			) T2 ON T1.id = T2.id\r\n"
				+ "		GROUP BY\r\n"
				+ "			T1.id\r\n"
				+ "		ORDER BY\r\n"
				+ "			S DESC\r\n"
				+ "	),\r\n"
				+ "    USERS\r\n"
				+ "WHERE\r\n"
				+ " id = User_ID and\r\n"
				+ "	ROWNUM <= 10";
		
		try {
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(sql);
			System.out.println("���ƿ並 ǥ���� Ƚ��, ����� �ۼ��� Ƚ���� ������� ����� �����Դϴ�!");
			int rank = 1;
			if (!rs.isBeforeFirst()) // resultset�� ������� false ��ȯ
				System.out.println("���� ȸ���� ����� �Ф�");
			else {
				while (rs.next()) {
					String userName = rs.getString(1);
					int score = rs.getInt(2);
					
					System.out.println(rank+"��! �� "+score+"���� "+userName+"��!");
					
					rank++;
				}
			}
			rs.close(); stmt.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}
}
