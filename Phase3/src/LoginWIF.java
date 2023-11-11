
import java.sql.*;
import java.util.InputMismatchException;
import java.util.Scanner;

public class LoginWIF {
	private static Scanner keyboard = new Scanner(System.in);

	// ù ȭ�鿡�� �α������� ȸ���������� ����
	public static Users initialPage(Connection conn) {
		int select = 0;
		Users user = null;
		Scanner keyboard = new Scanner(System.in);

		do {
			try {
				System.out.println("1. �α��� 2. ȸ������, 3.����");
				select = keyboard.nextInt();
				if (select == 1) {
					user = LoginWIF.loginAccount(conn);
					if (user != null) {
						System.out.println(user.getUser_ID() + "�� ȯ���մϴ�.");
						break;
					} else
						System.out.println("�ش��ϴ� ������ �������� �ʽ��ϴ�.");
					System.out.println();
				} else if (select == 2)
					LoginWIF.SignUpAccount(conn);
			} catch (InputMismatchException e) {
				System.out.println("1, 2, 3 �߿� �������ּ���.");
				keyboard.nextLine();
			}

		} while (select != 3);
		return user;
	}

	// �α���
	public static Users loginAccount(Connection conn) {
		String id;
		String pw;
		Users user = null;

		try {
			String query = "SELECT * FROM USERS U WHERE U.user_ID = ? AND U.password = ?";
			PreparedStatement pstmt = conn.prepareStatement(query);
			ResultSet rs = null;

			System.out.println("[�α���]");
			System.out.print("���̵� �Է��ϼ���: ");
			id = (keyboard.next());
			pstmt.setString(1, id);
			System.out.print("��й�ȣ�� �Է��ϼ���: ");
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

	// ȸ������
	public static void SignUpAccount(Connection conn) {
		String id = null;
		String pw = null;
		String name = null;
		String email = null;
		Date birth = null;
		char sex = 0;
		boolean isExisting = true;

		try {
			String query = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			System.out.println("[ȸ������]");
			// ���̵� �ߺ� üũ
			query = "SELECT COUNT(*) FROM USERS U WHERE U.user_ID = ?";
			pstmt = conn.prepareStatement(query);
			do {
				System.out.print("���̵� �Է��ϼ���: ");
				id = (keyboard.next());
				pstmt.setString(1, id);
				rs = pstmt.executeQuery();
				rs.next();

				if (rs.getInt(1) == 0) {
					isExisting = false;
					break;
				} else
					System.out.println("�ش� ���̵�� �̹� �����մϴ�.\n");
			} while (isExisting);

			// ID, PW, NAME, EMAIL, BIRTH, SEX
			// Exception Handling X
			query = "INSERT INTO USERS VALUES(?, ?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(query);
			System.out.print("��й�ȣ�� �Է��ϼ���: ");
			pw = (keyboard.next());
			System.out.print("�̸��� �Է��ϼ���: ");
			name = (keyboard.next());
			// �ߺ� üũ �ؾ���
			System.out.print("Email�� �Է��ϼ���: ");
			email = (keyboard.next());

			int y = 0, m = 0, d = 0;
			do {
				try {
					System.out.println("��������� �Է��ϼ���.");
					System.out.print("��: ");
					y = keyboard.nextInt();
					System.out.print("��: ");
					m = keyboard.nextInt();
					System.out.print("��: ");
					d = keyboard.nextInt();
					birth = new Date(y, m, d);
				} catch (InputMismatchException e) {
					System.out.println("���ڸ� �Է����ּ���.");
				}
			} while (y > 1900 && m >= 1 && m <= 12 && d >= 1 && d <= 31);

			int sexSelect = 0;
			do {
				try {
					System.out.println("������ �����ϼ���.");
					System.out.println("1. ����  2. ����");
					sexSelect = keyboard.nextInt();
					if (sexSelect == 1)
						sex = 'M';
					if (sexSelect == 2)
						sex = 'F';
				} catch (InputMismatchException e) {
					System.out.println("1�� 2 �߿� �Է� ��");
					keyboard.nextLine();
				}
			} while (sexSelect == 1 || sexSelect == 2);

			pstmt.setString(1, id);
			pstmt.setString(2, pw);
			pstmt.setString(3, name);
			pstmt.setString(4, email);
			pstmt.setDate(5, birth);
			pstmt.setString(6, String.valueOf(sex));
			int res = pstmt.executeUpdate();

			if (res == 1)
				System.out.println("����");
			else
				System.out.println("����");
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
