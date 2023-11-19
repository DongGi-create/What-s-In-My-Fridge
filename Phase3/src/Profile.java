import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.InputMismatchException;
import java.util.Scanner;

public class Profile
{
	private static Scanner keyboard = new Scanner(System.in);

	public static Users ProfileManagement(Connection conn, Users user)
	{
		int select = 0;

		System.out.println("[���� ����]");
		do
		{
			try
			{
				showProfile(user);

				System.out.println("1. ��й�ȣ ���� 2. Ż���ϱ� 3. �ڷ�");
				select = keyboard.nextInt();
				if (select == 1)
				{
					user = changePassword(conn, user);
				}
				else if (select == 2)
				{
					user = deleteAccount(conn, user);
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
		return user;
	}

	public static void showProfile(Users user)
	{
		System.out.println("------------------------");
		System.out.println("���̵�: " + user.getUser_ID());
		System.out.print("��й�ȣ: ");
		for (int i = 0; i < user.getPassword().length(); i++)
			System.out.print("*");
		System.out.println();
		System.out.println("�̸�: " + user.getName());
		System.out.println("Email: " + user.getEmail());
		System.out.println("�������: " + user.getBirth());
		System.out.println("����: " + user.getSex());
		System.out.println("------------------------");
	}

	public static Users changePassword(Connection conn, Users user)
	{
		String pw = null;
		String query = null;
		PreparedStatement pstmt = null;

		System.out.println("[���� ���� - ��й�ȣ ����]");
		System.out.print("���� Ȯ���� ���� ������ ��й�ȣ�� �Է����ּ���: ");
		pw = keyboard.next();
		if (!pw.equals(user.getPassword()))
		{
			System.out.println("��й�ȣ�� ��ġ���� �ʽ��ϴ�. ���� ȭ������ ���ư��ϴ�.");
			return user;
		}

		boolean fail = true;
		do
		{
			System.out.print("���� �ٲ� ��й�ȣ�� �Է����ּ���: ");
			pw = keyboard.next();
			if (pw.length() < 5 || pw.length() > 12)
			{
				System.out.println("��й�ȣ�� 5~12�� ���̷� �Է����ּ���.");
				continue;
			}
			System.out.print("�� �� �� �Է����ּ���: ");
			String checkPw = keyboard.next();
			if (!checkPw.equals(pw))
			{
				System.out.println("��й�ȣ�� ��ġ���� �ʽ��ϴ�.");
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
				System.out.println("���������� ��й�ȣ�� ����Ǿ����ϴ�.");
				user.setPassword(pw);
			}
			else
				System.out.println("��й�ȣ ���濡 �����߽��ϴ�.");
			pstmt.close();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return user;
	}

	public static Users deleteAccount(Connection conn, Users user)
	{
		String query = null;
		PreparedStatement pstmt = null;

		System.out.println("[���� ���� - Ż���ϱ�]");
		System.out.print("���� Ȯ���� ���� ������ ��й�ȣ�� �Է����ּ���: ");
		String pw = keyboard.next();
		if (!pw.equals(user.getPassword()))
		{
			System.out.println("��й�ȣ�� ��ġ���� �ʽ��ϴ�. ���� ȭ������ ���ư��ϴ�.");
			return user;
		}

		try
		{
			System.out.println("������ Ż���Ͻðڽ��ϱ�?");
			System.out.println("1. �� 2. �ƴϿ�");
			int select = keyboard.nextInt();
			if (select != 1)
			{
				return user;
			}
		}
		catch (InputMismatchException e)
		{
			System.out.println("�߸��� �Է��� ���� ���� ȭ������ ���ư��ϴ�.");
		}

		query = "DELETE FROM USERS WHERE USERS.USER_ID = ?";
		try
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, user.getUser_ID());
			int result = pstmt.executeUpdate();
			if (result > 0)
			{
				System.out.println("���������� Ż�� �Ϸ�Ǿ����ϴ�.");
				user.setPassword(pw);
			}
			else
				System.out.println("Ż�� �����߽��ϴ�.");
			pstmt.close();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return null;
	}
}
