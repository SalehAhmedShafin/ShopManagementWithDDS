clear screen;

drop table Branch CASCADE CONSTRAINTS;

--> Branch Table
CREATE TABLE Branch(
BranchID INT not null,
ShopID INT Not NULL,
branch_name VARCHAR(30) NOT NULL,
branch_address VARCHAR(200) NULL,
branch_contact VARCHAR(20) NULL,
branch_email VARCHAR(30) NULL check(branch_email like '%_@___%.__%'),
CONSTRAINT fk_shopID FOREIGN KEY (ShopID) REFERENCES Shop(ShopID),
PRIMARY KEY (BranchID));

insert into Branch(BranchID,ShopID,branch_name,branch_address,branch_contact) 
values (1,1,'dhaka','Mohakhali','01832115427');

insert into Branch(BranchID,ShopID,branch_name,branch_address,branch_contact) 
values (2,1,'rangpur','Noorpur','01832115427');


commit;