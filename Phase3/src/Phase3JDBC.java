
import java.sql.*;
import java.util.Scanner;

public class Phase3JDBC {
	public static final String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	public static final String DB_ID = "WIF";
	public static final String DB_PW = "comp322";

	public static void main(String[] args) {
		Connection conn = null;
		Users user = null;
		JDBCDriver.load();
		conn = JDBCDriver.getConnection(URL, DB_ID, DB_PW);

		user = LoginWIF.initialPage(conn);
		UserPages.mainPage(conn, user);

		JDBCDriver.close(conn);
	}
}
