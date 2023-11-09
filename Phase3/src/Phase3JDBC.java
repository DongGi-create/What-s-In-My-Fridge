
import java.sql.*;
import java.util.Scanner;

public class Phase3JDBC {
	public static final String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	public static final String DB_ID = "WIF";
	public static final String DB_PW = "comp322";

	public static void main(String[] args) {
		Connection conn = null;
		JDBCDriver.load();
		conn = JDBCDriver.getConnection(URL, DB_ID, DB_PW);
		Users user = initialPage(conn);

		JDBCDriver.close(conn);
	}

	public static Users initialPage(Connection conn) {
		int select;
		Users user = null;
		Scanner keyboard = new Scanner(System.in);

		do {
			System.out.println("1. �α��� 2. ȸ������, 3.����");
			select = keyboard.nextInt();
			if (select == 1) {
				user = LoginWIF.loginAccount(conn);
				if (user != null)
				{	
					System.out.println(user.getUser_ID() + "�� ȯ���մϴ�.");
					break;
				}
				else
					System.out.println("�ش��ϴ� ������ �������� �ʽ��ϴ�.");
			}
		} while (select != 3);

		return user;
	}
}
