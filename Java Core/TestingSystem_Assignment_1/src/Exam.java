import java.time.LocalDate;

public class Exam {
	byte id;
	String code;
	String title;
	CategoryQuestion category;
	String duration;
	Account creator;
	LocalDate creatDate;
	Question[] questions;
}
