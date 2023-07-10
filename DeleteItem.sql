set serveroutput on;
set verify off;


create or replace package delete_product_package AS
    procedure delete_product_from_site1(p_name in Product.product_name%type);
    procedure delete_product_from_site2(p_name in Product.product_name%type);
    function get_branch_id_by_name(b_name in Branch.branch_name%type) return number;
end delete_product_package;
/

create or replace package body delete_product_package as
    procedure delete_product_from_site1(p_name in Product.product_name%type)
    IS
    BEGIN
        delete from Product1@site1 where product_name like '%'||p_name||'%';
    END delete_product_from_site1;

    procedure delete_product_from_site2(p_name in Product.product_name%type)
    IS
    BEGIN
        delete from Product2 where product_name like '%'||p_name||'%';
    END delete_product_from_site2;

    function get_branch_id_by_name(b_name in Branch.branch_name%type)
    return number
    is 
    BEGIN
        for row in (select * from Branch where lower(branch_name) like '%'||b_name||'%') loop
            return row.BranchID;
        end loop;
        return 0;
    end get_branch_id_by_name;
    
end delete_product_package;
/

ACCEPT BranchNameInput PROMPT "Enter branch name:";
ACCEPT ProductNameInput PROMPT "Enter product name:";



declare 
BranchId Branch.BranchID%type;
BranchName Branch.branch_name%type := '&BranchNameInput';
ProductName Product.product_name%type := '&ProductNameInput';


branch_not_exist EXCEPTION;

begin 
    
    BranchId :=delete_product_package.get_branch_id_by_name(BranchName);
    
    if BranchId = 0 THEN
    RAISE branch_not_exist;
    end if;


    if BranchId = 1 THEN
        delete_product_package.delete_product_from_site1(ProductName);
    elsif BranchId = 2 THEN
        delete_product_package.delete_product_from_site2(ProductName);
    end if;

    EXCEPTION
		WHEN branch_not_exist THEN
			DBMS_OUTPUT.PUT_LINE('Branch does not exist.');

end;
/

commit;




