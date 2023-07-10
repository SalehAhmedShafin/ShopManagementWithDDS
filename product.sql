clear screen;

Drop table Product CASCADE CONSTRAINTS;

CREATE TABLE Product(
ProductID INT,
product_name VARCHAR(30) NOT NULL,
product_description VARCHAR(200) NULL,
product_model VARCHAR(30) NULL,
product_brand VARCHAR(30) NULL,
product_purchase_rate INT NOT NULL,
product_sales_rate INT NOT NULL,
total_quantity INT DEFAULT 0,
BranchID INT NOT NULL,
PRIMARY KEY (ProductID)
);
commit;