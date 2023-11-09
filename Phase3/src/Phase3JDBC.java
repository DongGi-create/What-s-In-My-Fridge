
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
			System.out.println("1. 로그인 2. 회원가입, 3.종료");
			select = keyboard.nextInt();
			if (select == 1) {
				user = LoginWIF.loginAccount(conn);
				if (user != null)
				{	
					System.out.println(user.getUser_ID() + "님 환영합니다.");
					break;
				}
				else
					System.out.println("해당하는 유저가 존재하지 않습니다.");
			}
		} while (select != 3);

		return user;
	}
}
