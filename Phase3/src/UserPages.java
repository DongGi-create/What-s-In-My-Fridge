import java.sql.Connection;
import java.util.InputMismatchException;
import java.util.Scanner;

public class UserPages {

	public static void mainPage(Connection conn, Users user) {
		if (user == null)
			return;
		int select = 0;
		Scanner keyboard = new Scanner(System.in);

		System.out.println(user.getUser_ID() + "�� ȯ���մϴ�.");
		do {
			try {
				System.out.println("1. �丮, ������ �˻� 2. ����� ���� 3. ���� ���� 4. ����");
				select = keyboard.nextInt();
				if (select == 1) {

				} else if (select == 2) {

				} else if (select == 3) {

				} else if (select == 4) {

				}
			} catch (InputMismatchException e) {
				System.out.println("1, 2, 3, 4 �߿� �������ּ���.");
			}

		} while (select != 4);
	}
}
