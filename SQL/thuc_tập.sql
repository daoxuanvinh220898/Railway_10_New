-- 1.1 Tạo bảng với các ràng buộc -- 
DROP DATABASE IF EXISTS THUCTAP	;
CREATE DATABASE IF NOT EXISTS THUCTAP ;
USE THUCTAP ;

--  Country : tạo dữ liệu quốc gia  --
DROP TABLE IF EXISTS		 	Country ;
CREATE TABLE IF NOT EXISTS   	Country  ( 
				Country_ID   	TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
                Country_Name  	VARCHAR(50) NOT NULL
 );
 
 
 -- Location :tạo dữ liệu vị trí -- 
 DROP TABLE IF EXISTS 			Location ; 
 CREATE TABLE IF NOT EXISTS 	Location (
				Location_ID  	TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
				Street_address  VARCHAR(50) NOT NULL UNIQUE KEY,
                Postal_code     VARCHAR(50) NOT NULL,
                Country_ID      TINYINT UNSIGNED,
     CONSTRAINT fk_Country FOREIGN KEY (Country_ID) REFERENCES Country(Country_ID)          
);
 
-- Employee : tạo dữ liệu nhân viên -- 
DROP TABLE IF EXISTS       		Employee;
CREATE TABLE IF NOT EXISTS 		Employee (
				Employee_ID		TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
                Full_name		VARCHAR(50) NOT NULL,
                Email			VARCHAR(50) NOT NULL UNIQUE KEY,
                Location_ID 	TINYINT UNSIGNED ,
     CONSTRAINT fk_Location FOREIGN KEY (Location_ID) REFERENCES  Location( Location_ID) 
);     

-- 1.2 INSERT sữ liệu vào bảng --

INSERT INTO Country ( Country_Name )
VALUES				( 'VIỆT NAM' ),
					('SINGAPORE'),
                    ( 'LÀO');
                    
INSERT INTO location (Street_address  ,      Postal_code , 			Country_ID  ) 
VALUES 				 (' XUÂN THỦY '   ,		'5521'		 , 			   1		),
					 ( 'HAI BÀ TRƯNG ',		'1101'		 , 			   2		),
                     ( 'NAM TỪ LIÊM'  ,     '2208'		 ,			   3		);
  
INSERT INTO Employee (  Full_name	  	,		Email		           ,			Location_ID )
VALUES				 ( 'ĐÀO XUÂN VINH'	,   'nn03@gmail.com'           ,             2        ),
					 ( 'NGUYỄN TUẤN ANH',   'account3@gmail.com '      ,             3		 ),
                     ( 'NGUYỄN ĐỨC ANH ',   'dapphatchetngay@gmail.com',			 1		);	
						
-- CÂU 2.A :   Lấy tất cả các nhân viên thuộc Việt nam --
   SELECT *
   FROM Employee E
   JOIN Location L USING (Location_ID)
   JOIN country C USING  (Country_ID)
   WHERE Country_Name = 'VIỆT NAM';
   
-- CÂU 2.B : Lấy ra tên quốc gia của employee có email là "nn03@gmail.co" --
  SELECT C.Country_Name 
  FROM  Employee E
  JOIN Location L USING (Location_ID)
  JOIN country C USING (Country_ID )
  WHERE Email = 'nn03@gmail.com';

 
 -- caau.c Thống kê mỗi country, mỗi location có bao nhiêu employee đang
 -- làm việc.
 SELECT C.Country_Name , L.Street_address , COUNT(*) AS number_of_employee
  FROM country C 
  LEFT JOIN Location L USING (Country_ID)
  LEFT JOIN Employee E USING (Location_ID)
  GROUP BY E.Location_ID;
  
  
-- câu 3 : Tạo trigger cho table Employee chỉ cho phép insert mỗi quốc gia có tối đa
-- 10 employee  -- 
 
 DROP TRIGGER IF EXISTS trigger_of_Employee;
 DELIMITER $$
			CREATE TRIGGER trigger_of_Employee
            BEFORE INSERT ON employee 
            FOR EACH ROW 
            BEGIN 
					DECLARE 
                    IF(NEW.Location_ID IN (SELECT
                    SIGNAL SQLSTATE '12345'
                     SET MESSAGE_TEXT=
                     
                     
                     
                     -- CÂU 4 Hãy cấu hình table sao cho khi xóa 1 location nào đó thì tất cả employee ở
                     --  location đó sẽ có location_id = null
					ALTER TABLE employee
					ADD FOREIGN KEY (Location_ID) REFERENCES location(Location_ID)
					ON DELETE SET NULL;

					DELETE 
					FROM location
					WHERE Location_ID = 3;
  
  
  
  