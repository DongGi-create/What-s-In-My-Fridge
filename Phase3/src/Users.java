
import java.sql.Date;
import java.util.Objects;

public class Users {
	private String user_ID;
	private String password;
	private String name;
	private String email;
	private Date birth;
	private char sex;

	public Users(String user_ID, String user_PW, String name, String email, Date birth, char sex) {
		this.user_ID = user_ID;
		this.password = user_PW;
		this.name = name;
		this.email = email;
		this.birth = birth;
		this.sex = sex;
	}

	public String getUser_ID() {
		return user_ID;
	}

	public void setUser_ID(String user_ID) {
		this.user_ID = user_ID;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Date getBirth() {
		return birth;
	}

	public void setBirth(Date birth) {
		this.birth = birth;
	}

	public char getSex() {
		return sex;
	}

	public void setSex(char sex) {
		this.sex = sex;
	}

	public String toString() {
		return "Users [user_ID=" + user_ID + ", password=" + password + ", name=" + name + ", email=" + email
				+ ", birth=" + birth + ", sex=" + sex + "]";
	}

	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Users other = (Users) obj;
		return Objects.equals(birth, other.birth) && Objects.equals(email, other.email)
				&& Objects.equals(name, other.name) && Objects.equals(password, other.password) && sex == other.sex
				&& Objects.equals(user_ID, other.user_ID);
	}
}
