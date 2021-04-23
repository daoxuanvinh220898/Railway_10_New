-- drop database if exists 
DROP DATABASE IF EXISTS 		TestingSystem;
CREATE DATABASE IF NOT EXISTS 			TestingSystem;
USE TestingSystem;

-- quesiton 1 : dinh danh phong ban --
DROP TABLE IF EXISTS		Department;
CREATE TABLE IF NOT EXISTS			Department (
    DepartmentID 			TINYINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	DepartmentName 			VARCHAR(50) NOT NULL UNIQUE KEY 
);

-- quesiton 2 : dinh danh chuc vu  -- 
DROP TABLE IF EXISTS 		`position`;
 CREATE TABLE  IF NOT EXISTS				`Position` (
	PositionID				TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	PositionName			VARCHAR(50) NOT NULL UNIQUE KEY 
);

-- quesition 3 : dinh danh cua khach hang --
DROP TABLE IF EXISTS 		`Account`;
 CREATE TABLE IF NOT EXISTS 				`Account`(
	AccountID				TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Email					VARCHAR(50) NOT NULL UNIQUE KEY ,
	Username				VARCHAR(50) NOT NULL UNIQUE KEY ,
	Fullname				VARCHAR(50 )NOT NULL UNIQUE KEY ,
	DepartmentID			TINYINT UNSIGNED NOT NULL  ,
	PositionID				TINYINT UNSIGNED,
	CreateDate          	DATE NOT NULL DEFAULT now() ,
    FOREIGN KEY ( DepartmentID ) REFERENCES Department (DepartmentID), 
    FOREIGN KEY ( PositionID  )  REFERENCES Position (PositionID )
);

-- quesition 4 : dinh danh cua nhom --
DROP TABLE IF EXISTS 		`Group`;
CREATE TABLE  IF NOT EXISTS 				`Group`(
	GroupID					TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT ,
	GroupName 				VARCHAR(50) NOT NULL UNIQUE KEY ,
	CreatorID				TINYINT NOT NULL ,
	CreateDate         	 	DATETIME NOT NULL DEFAULT now()
);

-- quesition 5 : dinh danh nhom khach hang su dung --
DROP TABLE IF EXISTS 		GroupAccount;
CREATE TABLE IF NOT EXISTS 				 GroupAccount(
	GroupID					TINYINT UNSIGNED,
	AccountID				TINYINT UNSIGNED,
	JoinDate				DATE DEFAULT now() ,
	FOREIGN KEY ( GroupID) REFERENCES `Group` (GroupID),
    FOREIGN KEY (AccountID) REFERENCES `Account` (`AccountID`),
    PRIMARY key  ( GroupID , AccountID)
); 

-- quesition  6 : dinh danh loai cau hoi --
DROP TABLE IF EXISTS 		TypeQuestion;
 CREATE TABLE IF NOT EXISTS 				TypeQuestion(
	TypeID					SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	TypeName 				VARCHAR(50) NOT NULL
);

-- quesition 7  : dinh danh cua chu de cau hoi --
 DROP TABLE IF EXISTS  		CategoryQuestion;
CREATE TABLE IF NOT EXISTS 				CategoryQuestion(
	CategoryID				TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	CategoryName 			VARCHAR(50) NOT NULL
);  

-- quesition 8 : dinh danh cua cau hoi --
DROP TABLE IF EXISTS        Question;
 CREATE TABLE IF NOT EXISTS  				Question(
	QuestionID				TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT ,
	Content					VARCHAR(50) NOT NULL  UNIQUE KEY ,
	CategoryID				TINYINT UNSIGNED NOT NULL, 
	TypeID					SMALLINT UNSIGNED NOT NULL, 
	CreatorID				TINYINT UNSIGNED NOT NULL,
	CreateDate 		   	 	DATE NOT NULL DEFAULT now() ,
    FOREIGN KEY ( CategoryID) REFERENCES  CategoryQuestion ( CategoryID),
    FOREIGN KEY ( TypeID ) REFERENCES  TypeQuestion (TypeID ) ,
    FOREIGN KEY (CreatorID)  REFERENCES `Account` (AccountID) 
);

-- quesiton 9 : dinh danh cua cau tra loi -- 
DROP TABLE IF EXISTS        Answer;
 CREATE TABLE IF NOT EXISTS  				Answer(
	AnswerID				TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Content					VARCHAR(50) NOT NULL unique key ,
	QuestionID				TINYINT UNSIGNED NOT NULL,
	IsCorrect				VARCHAR(50) NOT NULL unique key ,
     FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID)
);
   
   -- quesiiton 10 : dinh danh cua de thi --
DROP TABLE IF EXISTS 		Exam;
CREATE TABLE IF NOT EXISTS   				Exam(
	ExamID			    	TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	`Code`					SMALLINT NOT NULL unique key ,
	Title       			VARCHAR(100) NOT NULL,
	CategoryID				TINYINT UNSIGNED NOT NULL,
    Duration            	TINYINT UNSIGNED NOT NULL,
	CreatorID				TINYINT UNSIGNED NOT NULL ,
	CreateDate 		    	DATE DEFAULT now() ,
    FOREIGN KEY (CategoryID) REFERENCES CategoryQuestion (CategoryID) ,
    FOREIGN KEY (CreatorID)  REFERENCES `Account` (AccountID) 
);    

-- question 11--
DROP TABLE IF EXISTS 		ExamQuestion;
CREATE TABLE  IF NOT EXISTS 				ExamQuestion(
	ExamID			    	TINYINT UNSIGNED AUTO_INCREMENT,
	QuestionID				TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY ( ExamID , QuestionID ),
    FOREIGN KEY  ( ExamID ) REFERENCES Exam ( ExamID),
	FOREIGN KEY (QuestionID	) REFERENCES Question(QuestionID) 
 );   