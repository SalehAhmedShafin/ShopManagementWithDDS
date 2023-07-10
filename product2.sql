clear screen;

Drop table Product2 CASCADE CONSTRAINTS;

CREATE SEQUENCE product2_seq START WITH 1;

CREATE TABLE Product2(
ProductID INT,
product_name VARCHAR(30) NOT NULL,
product_description VARCHAR(200) NULL,
product_model VARCHAR(30) NULL,
product_brand VARCHAR(30) NULL,
product_purchase_rate INT NOT NULL,
product_sales_rate INT NOT NULL,
total_quantity INT DEFAULT 0,
BranchID INT NOT NULL,
CONSTRAINT product2_pk PRIMARY KEY (ProductID)
);

insert into Product2 values(1,'Potato','Good Quality by Pran','p123','Pran',80,70,100,1);

CREATE OR REPLACE TRIGGER Product2Trigger_after_insert
AFTER INSERT
ON Product2
BEGIN
   DBMS_OUTPUT.PUT_LINE('VALUES INSERTED INTO Product2 TABLE');
END;
/

CREATE OR REPLACE TRIGGER Product2Trigger_before_insert 
BEFORE INSERT ON Product2
FOR EACH ROW
BEGIN
  SELECT product2_seq.NEXTVAL
  INTO   :new.ProductID
  FROM   dual;
 END;
/
CREATE OR REPLACE TRIGGER Product2Trigger_after_update
AFTER update
ON Product2
BEGIN
   DBMS_OUTPUT.PUT_LINE('VALUES updated INTO Product2 TABLE');
END;
/
CREATE OR REPLACE TRIGGER Product2Trigger_after_delete
AFTER Delete
ON Product2
BEGIN
   DBMS_OUTPUT.PUT_LINE('VALUES deleted from Product2 TABLE');
END;
/
commit;