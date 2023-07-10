set serveroutput on;
set verify off;


create or replace package insert_product_package AS
    procedure insert_product_into_site1(branch_id in Branch.BranchID%type,p_name in Product.product_name%type,p_desc in Product.product_description%type,p_model in Product.product_model%type,p_brand in Product.product_brand%type,p_purchase in Product.product_purchase_rate%type,p_sales in Product.product_sales_rate%type,p_quantity in Product.total_quantity%type);
    procedure insert_product_into_site2(branch_id in Branch.BranchID%type,p_name in Product.product_name%type,p_desc in Product.product_description%type,p_model in Product.product_model%type,p_brand in Product.product_brand%type,p_purchase in Product.product_purchase_rate%type,p_sales in Product.product_sales_rate%type,p_quantity in Product.total_quantity%type);
    function get_branch_id_by_name(b_name in Branch.branch_name%type) return number;
end insert_product_package;
/

create or replace package body insert_product_package as
    procedure insert_product_into_site1(branch_id in Branch.BranchID%type,p_name in Product.product_name%type,p_desc in Product.product_description%type,p_model in Product.product_model%type,p_brand in Product.product_brand%type,p_purchase in Product.product_purchase_rate%type,p_sales in Product.product_sales_rate%type,p_quantity in Product.total_quantity%type)
    IS
    BEGIN
        insert into Product1@site1(product_name,product_description,product_model,product_brand,
        product_purchase_rate,product_sales_rate,total_quantity,BranchID) values 
        (p_name,p_desc,p_model,p_brand,p_purchase,p_sales,p_quantity,branch_id);
		commit;
    END insert_product_into_site1;

    procedure insert_product_into_site2(branch_id in Branch.BranchID%type,p_name in Product.product_name%type,p_desc in Product.product_description%type,p_model in Product.product_model%type,p_brand in Product.product_brand%type,p_purchase in Product.product_purchase_rate%type,p_sales in Product.product_sales_rate%type,p_quantity in Product.total_quantity%type)
    IS
    BEGIN
        insert into Product2(product_name,product_description,product_model,product_brand,
        product_purchase_rate,product_sales_rate,total_quantity,BranchID) values 
        (p_name,p_desc,p_model,p_brand,p_purchase,p_sales,p_quantity,branch_id);
		commit;
    END insert_product_into_site2;

    function get_branch_id_by_name(b_name in Branch.branch_name%type)
    return number
    is 
    BEGIN
        for row in (select * from Branch where lower(branch_name) like '%'||b_name||'%') loop
            return row.BranchID;
        end loop;
        return 0;
    end get_branch_id_by_name;
    
end insert_product_package;
/

ACCEPT BranchNameInput PROMPT "Enter branch name:";
ACCEPT ProductNameInput PROMPT "Enter product name:";
ACCEPT ProductDescInput PROMPT "Enter product description:";
ACCEPT ProductModelInput PROMPT "Enter product model:";
ACCEPT ProductBrandInput PROMPT "Enter product brand:";
ACCEPT ProductPurchaseRateInput PROMPT "Enter product purchase rate:";
ACCEPT ProductSalesRateInput PROMPT "Enter product sales rate:";
ACCEPT ProductTotalQuantityInput PROMPT "Enter product total quantity:";


declare 
BranchId Branch.BranchID%type;
BranchName Branch.branch_name%type := '&BranchNameInput';
ProductName Product.product_name%type := '&ProductNameInput';
ProductDesc Product.product_description%type := '&ProductDescInput';
ProductModel Product.product_model%type := '&ProductModelInput';
ProductBrand Product.product_brand%type := '&ProductBrandInput';
ProductPurchaseRate Product.product_purchase_rate%type := &ProductPurchaseRateInput;
ProductSalesRate Product.product_sales_rate%type := &ProductSalesRateInput;
ProductTotalQuantity Product.total_quantity%type := &ProductTotalQuantityInput;

branch_not_exist EXCEPTION;

begin 
    
    BranchId := insert_product_package.get_branch_id_by_name(BranchName);
    
    if BranchId = 0 THEN
    RAISE branch_not_exist;
    end if;


    if BranchId = 1 THEN
        insert_product_package.insert_product_into_site1(BranchId,ProductName,ProductDesc,ProductModel,ProductBrand,ProductPurchaseRate,ProductSalesRate,ProductTotalQuantity);
    elsif BranchId = 2 THEN
        insert_product_package.insert_product_into_site2(BranchId,ProductName,ProductDesc,ProductModel,ProductBrand,ProductPurchaseRate,ProductSalesRate,ProductTotalQuantity);
    end if;

    EXCEPTION
		WHEN branch_not_exist THEN
			DBMS_OUTPUT.PUT_LINE('Branch does not exist.');

end;
/

commit;