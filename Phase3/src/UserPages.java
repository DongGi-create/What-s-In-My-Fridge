import java.sql.Connection;
import java.util.InputMismatchException;
import java.util.Scanner;

public class UserPages {

	public static void mainPage(Connection conn, Users user) {
		if (user == null)
			return;
		int select = 0;
		Scanner keyboard = new Scanner(System.in);

		System.out.println(user.getUser_ID() + "님 환영합니다.");
		do {
			try {
				System.out.println("1. 요리, 레시피 검색 2. 냉장고 관리 3. 나의 정보 4. 종료");
				select = keyboard.nextInt();
				if (select == 1) {

				} else if (select == 2) {

				} else if (select == 3) {

				} else if (select == 4) {

				}
			} catch (InputMismatchException e) {
				System.out.println("1, 2, 3, 4 중에 선택해주세요.");
			}

		} while (select != 4);
	}
}
