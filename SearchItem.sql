set serveroutput on;
set verify off;

create or replace package search_product_package AS
function get_branch_id_by_name(bName in Branch.branch_name%type)return Branch.BranchID%type;
procedure search_product_all(p_name in Product.product_name%type);
procedure search_product_b1(p_name in Product.product_name%type);
procedure search_product_b2(p_name in Product.product_name%type);
end search_product_package;
/

create or replace package body search_product_package AS
    function get_branch_id_by_name(bName in Branch.branch_name%type)
    return Branch.BranchID%type is 
    begin 
        for row in (select * from Branch where lower(branch_name) like '%'||bName||'%') loop
            return row.BranchID;
        end loop;
        return 0;
    end get_branch_id_by_name;

    procedure search_product_all(p_name in Product.product_name%type)
    IS
    BEGIN
    dbms_output.put_line('Products with matching name:');
    dbms_output.put_line('Branch name | Product Name | Model | Brand | Purchase rate | Sales rate | Total quantity');
    
    for row in (select * from (Product1@site1 P1 INNER JOIN Branch ON P1.BranchID = Branch.BranchID) where lower(product_name) like '%'||p_name||'%') loop
        dbms_output.put_line(row.branch_name||' | '||row.product_name||' | '||row.product_model||' | '||row.product_brand||' | '||row.product_purchase_rate||' | '||row.product_sales_rate||' | '||row.total_quantity);
    end loop;

    for row in (select * from (Product2 P2 INNER JOIN Branch ON P2.BranchID = Branch.BranchID) where lower(product_name) like '%'||p_name||'%') loop
        dbms_output.put_line(row.branch_name||' | '||row.product_name||' | '||row.product_model||' | '||row.product_brand||' | '||row.product_purchase_rate||' | '||row.product_sales_rate||' | '||row.total_quantity);
    end loop;

    exception 
            when NO_DATA_FOUND then
                dbms_output.put_line('No product found');

    end search_product_all;

    procedure search_product_b1(p_name in Product.product_name%type)
    IS
    BEGIN
    dbms_output.put_line('Products with matching name:');
    dbms_output.put_line('Branch name | Product Name | Model | Brand | Purchase rate | Sales rate | Total quantity');
    
    for row in (select * from (Product1@site1 P1 INNER JOIN Branch ON P1.BranchID = Branch.BranchID) where lower(product_name) like '%'||p_name||'%') loop
        dbms_output.put_line(row.branch_name||' | '||row.product_name||' | '||row.product_model||' | '||row.product_brand||' | '||row.product_purchase_rate||' | '||row.product_sales_rate||' | '||row.total_quantity);
    end loop;

    exception 
            when NO_DATA_FOUND then
                dbms_output.put_line('No product found');

    end search_product_b1;

    procedure search_product_b2(p_name in Product.product_name%type)
    IS
    BEGIN
    dbms_output.put_line('Products with matching name:');
    dbms_output.put_line('Branch name | Product Name | Model | Brand | Purchase rate | Sales rate | Total quantity');
    
    for row in (select * from (Product2 P2 INNER JOIN Branch ON P2.BranchID = Branch.BranchID) where lower(product_name) like '%'||p_name||'%') loop
        dbms_output.put_line(row.branch_name||' | '||row.product_name||' | '||row.product_model||' | '||row.product_brand||' | '||row.product_purchase_rate||' | '||row.product_sales_rate||' | '||row.total_quantity);
    end loop;

    exception 
            when NO_DATA_FOUND then
                dbms_output.put_line('No product found');

    end search_product_b2;

end search_product_package;
/

accept branchNameIn prompt "Enter branch name:";
accept ProductName prompt "Enter product name to search:";

declare 
ProductName Product.product_name%type := '&ProductName';
branchId Branch.BranchID%type;
branchName Branch.branch_name%type:='&branchNameIn';
branch_not_exist EXCEPTION;
BEGIN
    if lower(branchName) = 'all' then 
        search_product_package.search_product_all(ProductName);
    else 
        branchId := search_product_package.get_branch_id_by_name(branchName);
        
        if BranchId = 0 THEN
            RAISE branch_not_exist;
        elsif BranchId = 1 then
            search_product_package.search_product_all(ProductName);
        elsif BranchId = 2 then
            search_product_package.search_product_all(ProductName);
        end if;
    end if;


    EXCEPTION
		WHEN branch_not_exist THEN
			DBMS_OUTPUT.PUT_LINE('Branch does not exist.');

END;
/

commit;