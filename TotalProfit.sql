set verify off;
set serveroutput on;


create or replace package total_profit_pack as 
    function get_branch_id_by_name(bName in Branch.branch_name%type)return Branch.BranchID%type;
    procedure calculate_net_profit_b1(net_profit in out int);
    procedure calculate_net_profit_b2(net_profit in out int);
    procedure calculate_net_profit_all(net_profit in out int);
end total_profit_pack;
/

create or replace package body total_profit_pack as 
    
    function get_branch_id_by_name(bName in Branch.branch_name%type)
    return Branch.BranchID%type is 
    begin 
        for row in (select * from Branch where lower(branch_name) like '%'||bName||'%') loop
            return row.BranchID;
        end loop;
        return 0;
    end get_branch_id_by_name;


    procedure calculate_net_profit_b1(net_profit in out int) is 
    profitPerProduct int;
    begin 
        for row in (select product_purchase_rate,product_sales_rate,total_quantity from Product1@site1) loop
            profitPerProduct:=(row.product_sales_rate-row.product_purchase_rate)*row.total_quantity;
            net_profit:=net_profit+profitPerProduct;
        end loop;
        
    end calculate_net_profit_b1;

    procedure calculate_net_profit_b2(net_profit in out int) is 
    profitPerProduct int;
    begin 
        for row in (select product_purchase_rate,product_sales_rate,total_quantity from Product2) loop
            profitPerProduct:=(row.product_sales_rate-row.product_purchase_rate)*row.total_quantity;
            net_profit:=net_profit+profitPerProduct;
        end loop;
    end calculate_net_profit_b2;

    procedure calculate_net_profit_all(net_profit in out int) is
    profitPerProduct int;
    begin 
        for row in ((select product_purchase_rate,product_sales_rate,total_quantity from Product1@site1) UNION (select product_purchase_rate,product_sales_rate,total_quantity from Product2)) loop
            profitPerProduct:=(row.product_sales_rate-row.product_purchase_rate)*row.total_quantity;
            net_profit:=net_profit+profitPerProduct;
        end loop;
    end calculate_net_profit_all;


end total_profit_pack;
/

accept branchNameIn prompt "Enter branch name:";

declare 
branchId Branch.BranchID%type;
branchName Branch.branch_name%type:='&branchNameIn';
netProfit int:=0;
branchAllFlag int:=0;
branch_not_exist EXCEPTION;

begin 
    if lower(branchName) = 'all' then 
        total_profit_pack.calculate_net_profit_all(netProfit);
        dbms_output.put_line('Net Profit of all branches = '|| netProfit);
    else 
        branchId := total_profit_pack.get_branch_id_by_name(branchName);
        
        if BranchId = 0 THEN
            RAISE branch_not_exist;
        elsif BranchId = 1 then
            total_profit_pack.calculate_net_profit_b1(netProfit);
        elsif BranchId = 2 then
            total_profit_pack.calculate_net_profit_b2(netProfit);
        end if;
        dbms_output.put_line('Net Profit of '||branchName||' branch is = '|| netProfit);
    end if;

    

    


    EXCEPTION
		WHEN branch_not_exist THEN
			DBMS_OUTPUT.PUT_LINE('Branch does not exist.');

end;
/