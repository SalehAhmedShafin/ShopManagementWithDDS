# ShopManagementWithDDS
Introduction
Shop Management System is a management system project where products can be inserted to 
different site’s database and searching functionality from different sites is also introduced in 
this distributed database project.
Proposed Implementation Method
There are 3 tables (Shop, Branch, Product) in the server side and 1 table (Product#) in each 
site.
1. Server/connection.sql file is used for establishing connection with 2 sites.
2. Server/insert_product.sql file is for inserting product.
a. At first, the user will enter the branch in which he/she wants to store product
b. Then user will give product details
c. function insert_product_package.get_branch_id_by_name(BranchName) gives the branch 
id [PL/SQL control statements(loop) is used here]
d. If branch is not found then raise custom exception
e. If branch id is found then insert data into corresponding site’s DB
3. In Site1/Tables/Product1.sql 
a. A sequence and Product1Trigger_before_insert trigger is created to auto increment 
the ProductID when a new product is added
b. Product1Trigger_after_insert trigger is for notifying user about the insertion of 
new row
4. Server/search_products.sql file is used to search products according to the name
a. procedure search_product_by_name(p_name in Product.product_name%type) is 
responsible for this functionality [PL/SQL control statements and cursors is used 
here]
b. Search in both table from both sites and show the data
Types of Database Fragmentation
Global Schema:
Shop(ShopID,shop_name,shop_logo,shop_address,shop_contact,shop_email)
Product(ProductID,product_name,product_description,product_model,product_brand,produ
ct_purchase_rate,product_sales_rate,total_quantity,BranchID)
Branch(BranchID, ShopID,branch_name,branch_address,branch_contact,branch_email)
Fragmentation Schema:
Product1: SLBranch=’Dhaka’ Product
Product2: SLBranch=’Rangpur’ Product
Allocation Schema: Product1 at site 1. Product2 at site 2.
Distributed database a good choice 
A shop management system project may need a distributed database for several reasons:
Scalability: A distributed database can handle large amounts of data and can easily scale to 
accommodate the growing needs of the business.
Performance: Distributed databases can improve performance by distributing data across 
multiple nodes, which can reduce the load on a single node and improve the response time of 
queries.
High availability: A distributed database can ensure that data remains available even if a node 
or server goes down. 
Data consistency: Distributed databases can ensure data consistency.
Flexibility: A distributed database can be deployed on different platforms.
Security: Distributed databases can provide better security by distributing the data across 
multiple nodes, which makes it more difficult for hackers to access all the data in one place
