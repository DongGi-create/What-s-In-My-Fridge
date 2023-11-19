import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.InputMismatchException;
import java.util.Scanner;

public class Profile
{
	private static Scanner keyboard = new Scanner(System.in);

	public static Users ProfileManagement(Connection conn, Users user)
	{
		int select = 0;

		System.out.println("[나의 정보]");
		do
		{
			try
			{
				showProfile(user);

				System.out.println("1. 비밀번호 변경 2. 내가 작성한 레시피 3. 탈퇴하기 4. 뒤로");
				select = keyboard.nextInt();
				if (select == 1)
				{
					user = changePassword(conn, user);
				}
				else if (select == 2)
				{
					showMyRecipes(conn, user);
				}
				else if (select == 3)
				{
					user = deleteAccount(conn, user);
				}
				else if (select == 4)
				{
					continue;
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
		return user;
	}

	public static void showProfile(Users user)
	{
		System.out.println("------------------------");
		System.out.println("아이디: " + user.getUser_ID());
		System.out.print("비밀번호: ");
		for (int i = 0; i < user.getPassword().length(); i++)
			System.out.print("*");
		System.out.println();
		System.out.println("이름: " + user.getName());
		System.out.println("Email: " + user.getEmail());
		System.out.println("생년월일: " + user.getBirth());
		System.out.println("성별: " + user.getSex());
		System.out.println("------------------------");
	}

	public static Users changePassword(Connection conn, Users user)
	{
		String pw = null;
		String query = null;
		PreparedStatement pstmt = null;

		System.out.println("[나의 정보 - 비밀번호 변경]");
		System.out.print("본인 확인을 위해 기존의 비밀번호를 입력해주세요: ");
		pw = keyboard.next();
		if (!pw.equals(user.getPassword()))
		{
			System.out.println("비밀번호가 일치하지 않습니다. 이전 화면으로 돌아갑니다.");
			return user;
		}

		boolean fail = true;
		do
		{
			System.out.print("새로 바꿀 비밀번호를 입력해주세요: ");
			pw = keyboard.next();
			if (pw.length() < 5 || pw.length() > 12)
			{
				System.out.println("비밀번호는 5~12자 사이로 입력해주세요.");
				continue;
			}
			System.out.print("한 번 더 입력해주세요: ");
			String checkPw = keyboard.next();
			if (!checkPw.equals(pw))
			{
				System.out.println("비밀번호가 일치하지 않습니다.");
				continue;
			}
			fail = false;
		} while (fail);

		query = "UPDATE USERS SET USERS.PASSWORD = ? WHERE USERS.USER_ID = ?";
		try
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, pw);
			pstmt.setString(2, user.getUser_ID());
			int result = pstmt.executeUpdate();
			if (result > 0)
			{
				System.out.println("성공적으로 비밀번호가 변경되었습니다.");
				user.setPassword(pw);
			}
			else
				System.out.println("비밀번호 변경에 실패했습니다.");
			pstmt.close();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return user;
	}

	public static void showMyRecipes(Connection conn, Users user)
	{
		String q7 = "SELECT\r\n" + "	R.*, (\r\n" + "		SELECT\r\n" + "			C.CUISINE_NAME\r\n"
				+ "		FROM\r\n" + "			CUISINE C\r\n" + "		WHERE\r\n"
				+ "			R.CUISINE_ID = C.CUISINE_ID\r\n" + "	) AS CUISINE_NAME\r\n" + "FROM\r\n"
				+ "	RECIPE R\r\n" + "WHERE\r\n" + "	R.WRITER_ID = ?";

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Recipe> recipes = new ArrayList<>();

		System.out.println("[나의 정보 - 내가 작성한 레시피]");
		try
		{
			pstmt = conn.prepareStatement(q7);
			pstmt.setString(1, user.getUser_ID());
			rs = pstmt.executeQuery();
			while (rs.next())
			{
				recipes.add(new Recipe(rs));
				System.out.println(recipes.size() + ". " + rs.getString(11) + " - " + rs.getString(3));
			}
			rs.close();
			pstmt.close();
			if (recipes.size() == 0)
			{
				System.out.println("아직 작성한 레시피가 없으시네요. 한 번 작성해보세요!");
				return;
			}
			System.out.println("--------------------------------------");
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		int select = 0;
		do
		{
			System.out.println("보고 싶은 레시피를 선택해주세요. 0을 입력하면 이전으로 돌아갑니다.");
			try
			{
				select = keyboard.nextInt();
				if (select < 0 || select > recipes.size())
				{
					System.out.println("0~" + recipes.size() + " 사이의 값만 입력해주세요.");
					continue;
				}
				if (select == 0)
					continue;
				recipes.get(select - 1).showRecipe(conn);
			}
			catch (InputMismatchException e)
			{
				System.out.println("0~" + recipes.size() + " 사이의 값만 입력해주세요.");
			}
		} while (select != 0);
	}

	public static Users deleteAccount(Connection conn, Users user)
	{
		String query = null;
		PreparedStatement pstmt = null;

		System.out.println("[나의 정보 - 탈퇴하기]");
		System.out.print("본인 확인을 위해 기존의 비밀번호를 입력해주세요: ");
		String pw = keyboard.next();
		if (!pw.equals(user.getPassword()))
		{
			System.out.println("비밀번호가 일치하지 않습니다. 이전 화면으로 돌아갑니다.");
			return user;
		}

		try
		{
			System.out.println("정말로 탈퇴하시겠습니까?");
			System.out.println("1. 예 2. 아니요");
			int select = keyboard.nextInt();
			if (select != 1)
			{
				return user;
			}
		}
		catch (InputMismatchException e)
		{
			System.out.println("잘못된 입력이 들어와 이전 화면으로 돌아갑니다.");
		}

		query = "DELETE FROM USERS WHERE USERS.USER_ID = ?";
		try
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, user.getUser_ID());
			int result = pstmt.executeUpdate();
			if (result > 0)
			{
				System.out.println("성공적으로 탈퇴가 완료되었습니다.");
				user.setPassword(pw);
			}
			else
				System.out.println("탈퇴에 실패했습니다.");
			pstmt.close();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return null;
	}
}
