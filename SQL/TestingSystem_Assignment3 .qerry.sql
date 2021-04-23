-- quesition 2 : lấy ra all các phòng ban 
SELECT * 
FROM department;

-- quesition 3 : lấy ra id của phòng ban sale 
SELECT departmentID
FROM department 
WHERE departmentName = 'Sale';


-- question 4 : lấy ra thông tin account có fullname dài nhất

## char_length : lấy độ dài của chuỗi dữ liệu của cột fulname
## lấy ra độ dài nhất của chuỗi dữ liệu cột fulltime trong bảng `account`
SELECT MAX(char_length(fullname)) from `account`;

SELECT *
FROM `account` 
WHERE Char_length(fullname ) = (SELECT MAX(char_length(fullname)) from `account`);

-- question 5 : lấy ra thông tin account có fulltime dài nhất và thuộc phòng ban có id=3
SELECT AccountID,FullName,length(FullName)
FROM   `account`
WHERE DepartmentID=3
ORDER BY length(FullName) DESC
limit 1;


-- question 6: lấy ra têt group đã tham gia trước ngày 20/12/2019
SELECT GroupName
FROM  `Group`
where CreateDate < '2019-12-20';


-- question 7:lấy ra id của question >=4 câu tra lời 
SELECT QuestionID
FROM answer 
GROUP BY QuestionID 
HAVING COUNT(AnswerID)>=4 ;

-- question8 : lấy ra các mã đề thi có TIME>=60 và tạo trc ngày 20/12/2019
SELECT Code
FROM exam 
WHERE Duration>=60 and CreateDate <'2019-12-20';


-- question 9 : lấy ra 5 group được tạo gần đâi nhất 
SELECT  GroupName ,CreateDate 
FROM  `Group`
ORDER BY CreateDate DESC
limit 5;

-- question 10: đếm số nhân viên thuộc department có id =2
SELECT COUNT(DepartmentID)
FROM Department 
WHERE DepartmentID = 2;

-- question11 : lấy ra nhân viên có tên bắt đầu bằng chữ D và kết thúc bằng chữ O
SELECT FullName
FROM `account`
WHERE FullName LIKE 'D%o';


DELETE *
FROM  Exam 
WHERE CreateDate < '2019-12-20)';
 câu delete này chưa chạy đc anh ạ giải thích hộ em 




 