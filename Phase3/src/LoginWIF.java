
import java.sql.*;
import java.util.Scanner;

public class LoginWIF {
	private static Scanner keyboard = new Scanner(System.in);

	public static Users loginAccount(Connection conn) {
		String id;
		String pw;
		Users user = null;
		try {
			String query = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			System.out.print("���̵� �Է��ϼ���: ");
			id = (keyboard.next());
			System.out.print("��й�ȣ�� �Է��ϼ���: ");
			pw = (keyboard.next());

			query = "SELECT * FROM USERS U WHERE U.user_ID = ? AND U.password = ?";
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, id);
			pstmt.setString(2, pw);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				user = new Users(rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getDate(5),
						rs.getString(6).charAt(0));
				System.out.println(user);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return user;
	}
}
