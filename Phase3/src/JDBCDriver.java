
import java.sql.*;

public class JDBCDriver {
	public static void load() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			System.out.println("Oracle Driver Loading: Success!");
		} catch (ClassNotFoundException e) {
			System.err.println("Error = " + e.getMessage());
			System.exit(1);
		}
	}

	public static Connection getConnection(String url, String id, String pw) {
		Connection conn = null;
		try {
			conn = DriverManager.getConnection(url, id, pw);
			System.out.println("Oracle Connected.");
		} catch (SQLException e) {
			e.printStackTrace();
			System.err.println("Cannot get a connection: " + e.getLocalizedMessage());
			System.err.println("Cannot get a connection: " + e.getMessage());
		}
		return conn;
	}
	
	public static void close(Connection conn)
	{
		try {
			conn.close();
			System.out.println("Oracle was successfully disconnected.");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
