
DROP DATABASE IF EXISTS car_sale_management	;
CREATE DATABASE IF NOT EXISTS car_sale_management ;
USE car_sale_management ;

--  CUSTOMER: khach hang --
DROP TABLE IF EXISTS		CUSTOMER;
CREATE TABLE IF NOT EXISTS  CUSTOMER ( 
		CustomerID  		TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
        `Name` 			 	VARCHAR(50) NOT NULL,
        Phone				VARCHAR(15) NOT NULL UNIQUE KEY ,
        Email				VARCHAR(50) NOT NULL UNIQUE KEY ,
        Address             VARCHAR(50) NOT NULL,
        Note				VARCHAR(500) 
);

-- car : xe  --
DROP TABLE IF EXISTS       CAR;
CREATE TABLE IF NOT EXISTS CAR (
		CarID			   TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
        Marker			   ENUM('HONDA','TOYOTA','NISSAN') NOT NULL ,
        Model				VARCHAR(20) NOT NULL UNIQUE KEY,
        `Year`				VARCHAR(4) NOT NULL ,
        Color				VARCHAR(20) NOT NULL ,
        Note 				VARCHAR(500) 
);

-- CAR_ORDER: dat hang -- 
DROP TABLE IF EXISTS     	CAR_ORDER;
CREATE TABLE IF NOT EXISTS  CAR_ORDER (
	  OrderID				TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
      CustomerID			TINYINT UNSIGNED NOT NULL,
      CarID					TINYINT UNSIGNED NOT NULL,
      Amount				TINYINT UNSIGNED DEFAULT 1,
      SalePrice				BIGINT UNSIGNED NOT NULL,
      OderDate				DATE NOT NULL,
      DeliveryDate			DATE NOT NULL,
      DeliveryAddress		VARCHAR(50) NOT NULL,
      staus					ENUM ('0','1','2'),  -- (0: đã đặt hàng, 1: đã giao, 2: đã hủy)--
      Note					VARCHAR(500),
      CONSTRAINT fk_order_Customer FOREIGN KEY (CustomerID) REFERENCES  Customer(CustomerID),
      CONSTRAINT fk_oder_car FOREIGN KEY (CarID)	   REFERENCES  Car(CarID)
);     
			
INSERT INTO CUSTOMER(`Name`        		, Phone			  , Email								, Address			, Note)
VALUES 				('đào xuân vinh'	, '0375555811'    , 'haidang29productions@gmail.com'  , 'nghệ an '		, 'giàu'),
					('nguyễn tuấn anh'	, '0946748755'	  , 'account1@gmail.com'				, 'hưng nguyên'		, 'nghèo'),
                    ('khổng văn vinh '  , '0946755748'    , 'account2@gmail.com'				, 'diễn châu '      , 'khoai to'),
                    ('phạm văn đồng '	, '0975884515'    , 'account3@gmail.com'				, 'yên thành'		, 'đại gia'),
                    ('phạm văn bé'		, '0645245455'    , 'dapphatchetngay@gmail.com'		, 'con cuông'		, 'nghịch ngợm');

INSERT INTO CAR     ( Marker				, Model			, `Year`		, Color			, note	)
VALUES				('HONDA'			, 'dream'			, 1998			, 'đen trắng'	, NULL	),
					('TOYOTA'			, 'jupiter'			, 2000			, 'red'			, 'đẹp máy ngon'),
                    ('NISSAN' 			, 'XE ĐUA'			, 1986			, 'white '		, 'tăng tốc nhanh'),
                    ('NISSAN'			, 'xe bán tải'		, 1999			, 'black'		, null),
                    ('TOYOTA'			, 'xe máy'      	, 1999			, 'yellow'		, 'nhỏ gon'); 
   
INSERT INTO CAR_ORDER (CustomerID		, CarID		, Amount 		, SalePrice		 ,   OderDate			, DeliveryDate			, DeliveryAddress		, Staus			, Note      )
VALUES				  (1				, 1			, 12			, 2000000  , '2019-04-05'		, '2019-04-06'			, 'nghệ an '			, 	'0'			, null),
					  (1				, 2 		,6				, 5000000	 , '2019-04-05'		, '2019-04-07'			, 'hà nội'				,   '1'			, 'đã giao hàng thành công'),
                      (1				, 3			,8				, 200000000, '2019-05-05'		, '2019-05-09'			, 'quảng nam'			,   '2'			,  '  đã hủy giao dịch'),
                      (4 				, 4 		,9				, 200000000	,  '2021-04-16'		, '2021-04-17'			, 'quảng bình'			,   '1'			, null),
                      (5				, 5			,30				, 2000000000	,  '2021-04-11'		, '2021-04-12'			, 'hải phòng'		,   '2'			, 'huy thanh công');
                      
                      
                      
            -- 2. Viết lệnh lấy ra thông tin của khách hàng: tên, số lượng oto khách hàng đã
			-- mua và sắp sếp tăng dần theo số lượng oto đã mua.         
 
 
 SELECT C.CustomerID , C.`Name` , ifnull(SUM(Amount),0) AS number_of_car
 FROM customer C
 LEFT JOIN car_order A ON C.CustomerID = A.CustomerID
 GROUP BY C.CustomerID
 ORDER BY SUM(Amount) ASC ;
 
 -- Viết hàm (không có parameter) trả về tên hãng sản xuất đã bán được nhiều
-- oto nhất trong năm nay.

DROP PROCEDURE IF EXISTS get_marker_of_amount;
DELIMITER $$
CREATE PROCEDURE get_marker_of_amount()
BEGIN
SELECT C.Marker , YEAR(OderDate) AS OrderYear , SUM(Amount) AS number_of_car
FROM car C
INNER JOIN car_order A ON C.CarID = A.CarID 
WHERE Year(OderDate) = Year(now())
GROUP BY C.Marker
HAVING SUM(Amount) =  (SELECT MAX(number_of_car) FROM (SELECT  SUM(Amount) AS number_of_car
							FROM car C
							INNER JOIN car_order A ON C.CarID = A.CarID 
							WHERE Year(OderDate) = Year(now())
							GROUP BY C.Marker) AS temp );
END$$
DELIMITER ;
  
  CALL get_marker_of_amount() ;
  
  DROP FUNCTION IF EXISTS get_marker;
  DELIMITER $$
  CREATE FUNCTION  get_marker() returns  ENUM('HONDA','TOYOTA','NISSAN')
  begin
  declare v_max_marker ENUM('HONDA','TOYOTA','NISSAN');
  SELECT c.marker INTO  v_max_marker 
  FROM car c
  JOIN car_order co
  USING (CarID)
  WHERE Year(co.OderDate) = Year(now()) AND co.staus = '1'
  GROUP BY c.Marker
  ORDER BY SUM(Amount) desc
  LIMIT 1;
	return v_max_marker;
    end$$
    DELIMITER ;
    
    SELECT  get_marker();
    
    
    
  -- 4. Viết 1 thủ tục (không có parameter) để xóa các đơn hàng đã bị hủy của
-- những năm trước. In ra số lượng bản ghi đã bị xóa.,
-- SET GLOBAL log_bin_trust_function_creators = 1;
DROP PROCEDURE IF EXISTS Delete_of_cancel;
 DELIMITER $$
CREATE PROCEDURE Delete_of_cancel()
begin
  SELECT COUNT(*) as Delete_of_cancel
  FROM car_order
  WHERE year(now()) > year(OderDate) AND staus = '2';
  
  Delete
  FROM car_order 
  WHERE year(now()) > year(OderDate) AND staus = '2';
  end$$
  DELIMITER ;
  
  call Delete_of_cancel();
  
  
  -- 5 5. Viết 1 thủ tục (có CustomerID parameter) để in ra thông tin của các đơn
--        hàng đã đặt hàng bao gồm: tên của khách hàng, mã đơn hàng, số lượng oto
--        và tên hãng sản xuất.
  
  DROP PROCEDURE IF EXISTS printOrder;
DELIMITER $$
CREATE PROCEDURE printOrder(IN customerID TINYINT)
BEGIN
    SELECT CM.Name, CO.OrderID AS 'Ma don da dat', CO.Amount AS 'So luong', C.Maker AS 'Ten Hang', C.Model, CO.Status AS 'Trang thai'
    FROM Car_Order CO
             JOIN Customer CM ON CO.CustomerID = CM.CustomerID
             JOIN Car C ON CO.CarID = C.CarID
    WHERE CM.CustomerID = customerID
      AND CO.Status = 0;
#     GROUP BY CO.CustomerID, CO.CarID;
END $$
DELIMITER ;

CALL printOrder(1);


 
  
  -- Cau 6: Viết trigger để tránh trường hợp người dụng nhập thông tin không hợp lệ vào database (DeliveryDate < OrderDate + 15).
   
   
   DROP TRIGGER IF EXISTS trigger_of_caroder;
   DELIMITER $$
			CREATE TRIGGER trigger_of_caroder
            BEFORE INSERT ON car_order
            FOR EACH ROW
            BEGIN
            
                 IF(NEW.DeliveryDate < (NEW.OderDate + 15)) THEN
                 SIGNAL SQLSTATE '12345'
                 SET MESSAGE_TEXT='DeliveryDate < OrderDate + 15 tối thiểu thời gian giao hàng phải lớn hơn 15 ngày ';
				END IF;
            END $$
            DELIMITER ;
            
            -- CÂU 4 Hãy cấu hình table sao cho khi xóa 1 location nào đó thì tất cả employee ở
            --  location đó sẽ có location_id = null
					ALTER TABLE employee
					ADD FOREIGN KEY (Location_ID) REFERENCES location(Location_ID)
					ON DELETE SET NULL;

					DELETE 
					FROM location
					WHERE Location_ID = 3;
            
            
            
            
  