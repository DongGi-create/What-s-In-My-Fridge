
import java.sql.*;
import java.util.Scanner;

public class LoginWIF {
	private static Scanner keyboard = new Scanner(System.in);

	// 첫 화면에서 로그인할지 회원가입할지 선택
	public static Users initialPage(Connection conn) {
		int select;
		Users user = null;
		Scanner keyboard = new Scanner(System.in);

		do {
			System.out.println("1. 로그인 2. 회원가입, 3.종료");
			select = keyboard.nextInt();
			if (select == 1) {
				user = loginAccount(conn);
				if (user != null) {
					System.out.println(user.getUser_ID() + "님 환영합니다.");
					break;
				} else
					System.out.println("해당하는 유저가 존재하지 않습니다.");
				System.out.println();
			}
			if (select == 2)
				SignUpAccount(conn);

		} while (select != 3);
		return user;
	}

	// 로그인
	public static Users loginAccount(Connection conn) {
		String id;
		String pw;
		Users user = null;

		try {
			String query = "SELECT * FROM USERS U WHERE U.user_ID = ? AND U.password = ?";
			;
			PreparedStatement pstmt = conn.prepareStatement(query);
			ResultSet rs = null;

			System.out.println("[로그인]");
			System.out.print("아이디를 입력하세요: ");
			id = (keyboard.next());
			pstmt.setString(1, id);
			System.out.print("비밀번호를 입력하세요: ");
			pw = (keyboard.next());
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

	// 회원가입
	public static void SignUpAccount(Connection conn) {
		String id = null;
		String pw = null;
		String name = null;
		String email = null;
		Date birth = null;
		char sex;
		boolean isExisting = true;

		try {
			String query = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			System.out.println("[회원가입]");
			// 아이디 중복 체크
			query = "SELECT COUNT(*) FROM USERS U WHERE U.user_ID = ?";
			pstmt = conn.prepareStatement(query);
			do {
				System.out.print("아이디를 입력하세요: ");
				id = (keyboard.next());
				pstmt.setString(1, id);
				rs = pstmt.executeQuery();
				rs.next();

				if (rs.getInt(1) == 0) {
					isExisting = false;
					break;
				} else
					System.out.println("해당 아이디는 이미 존재합니다.\n");
			} while (isExisting);

			// ID, PW, NAME, EMAIL, BIRTH, SEX
			// Exception Handling X
			query = "INSERT INTO USERS VALUES(?, ?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(query);
			System.out.print("비밀번호를 입력하세요: ");
			pw = (keyboard.next());
			System.out.print("이름을 입력하세요: ");
			name = (keyboard.next());
			// 중복 체크 해야함
			System.out.print("Email을 입력하세요: ");
			email = (keyboard.next());

			int y, m, d;
			System.out.println("생년월일을 입력하세요.");
			System.out.print("년: ");
			y = keyboard.nextInt();
			System.out.print("월: ");
			m = keyboard.nextInt();
			System.out.print("일: ");
			d = keyboard.nextInt();
			birth = new Date(y, m, d);
			System.out.print("성별을 입력하세요: ");
			sex = keyboard.next().charAt(0);

			pstmt.setString(1, id);
			pstmt.setString(2, pw);
			pstmt.setString(3, name);
			pstmt.setString(4, email);
			pstmt.setDate(5, birth);
			pstmt.setString(6, String.valueOf(sex));
			int res = pstmt.executeUpdate();

			if (res == 1)
				System.out.println("성공");
			else
				System.out.println("실패");
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
