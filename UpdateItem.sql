set verify off;
set serveroutput on;

create or replace package update_product_pack as 
    function get_branch_id_by_name(bName in Branch.branch_name%type)return Branch.BranchID%type;
    procedure update_product1_details(p_id in Product.ProductID%type,p_name in Product.product_name%type,p_desc in Product.product_description%type,p_model in Product.product_model%type,p_brand in Product.product_brand%type,p_purchase in Product.product_purchase_rate%type,p_sales in Product.product_sales_rate%type,p_quantity in Product.total_quantity%type);
    procedure update_product2_details(p_id in Product.ProductID%type,p_name in Product.product_name%type,p_desc in Product.product_description%type,p_model in Product.product_model%type,p_brand in Product.product_brand%type,p_purchase in Product.product_purchase_rate%type,p_sales in Product.product_sales_rate%type,p_quantity in Product.total_quantity%type);
end update_product_pack;
/

create or replace package body update_product_pack as 

    procedure update_product1_details(p_id in Product.ProductID%type,p_name in Product.product_name%type,p_desc in Product.product_description%type,p_model in Product.product_model%type,p_brand in Product.product_brand%type,p_purchase in Product.product_purchase_rate%type,p_sales in Product.product_sales_rate%type,p_quantity in Product.total_quantity%type) is
    pName Product.product_name%type;
    pDesc Product.product_description%type;
    pModel Product.product_model%type;
    pBrand Product.product_brand%type;
    pPurchaseRate Product.product_purchase_rate%type;
    pSalesRate Product.product_sales_rate%type;
    pQuantity Product.total_quantity%type;
    
    begin 

        select product_name,product_description,product_model,product_brand,product_purchase_rate,product_sales_rate,total_quantity
        into pName,pDesc,pModel,pBrand,pPurchaseRate,pSalesRate,pQuantity from Product1@site1 WHERE ProductID = p_id; 

        if p_name is not NULL then
            pName:=p_name;
        end if;
        if p_desc is not NULL then
            pDesc:=p_desc;
        end if;
        if p_model is not NULL then
            pModel:=p_model;
        end if;
        if p_brand is not NULL then
            pBrand:=p_brand;
        end if;
        if p_purchase is not NULL then
            pPurchaseRate:=p_purchase;
        end if;
        if p_sales is not NULL then
            pSalesRate:=p_sales;
        end if;
        if p_quantity is not NULL then
           pQuantity:=p_quantity;
        end if;
        

        UPDATE Product1@site1
        SET product_name = pName, product_description= pDesc, product_model=pModel,product_brand=pBrand,product_purchase_rate=pPurchaseRate,product_sales_rate=pSalesRate,total_quantity=pQuantity
        WHERE ProductID = p_id;

        exception 
            when NO_DATA_FOUND then
                dbms_output.put_line('No product found with id '||p_id);
    end update_product1_details;

    procedure update_product2_details(p_id in Product.ProductID%type,p_name in Product.product_name%type,p_desc in Product.product_description%type,p_model in Product.product_model%type,p_brand in Product.product_brand%type,p_purchase in Product.product_purchase_rate%type,p_sales in Product.product_sales_rate%type,p_quantity in Product.total_quantity%type) is
    pName Product.product_name%type;
    pDesc Product.product_description%type;
    pModel Product.product_model%type;
    pBrand Product.product_brand%type;
    pPurchaseRate Product.product_purchase_rate%type;
    pSalesRate Product.product_sales_rate%type;
    pQuantity Product.total_quantity%type;
    
    begin 

        select product_name,product_description,product_model,product_brand,product_purchase_rate,product_sales_rate,total_quantity
        into pName,pDesc,pModel,pBrand,pPurchaseRate,pSalesRate,pQuantity from Product2 WHERE ProductID = p_id; 

        if p_name is not NULL then
            pName:=p_name;
        end if;
        if p_desc is not NULL then
            pDesc:=p_desc;
        end if;
        if p_model is not NULL then
            pModel:=p_model;
        end if;
        if p_brand is not NULL then
            pBrand:=p_brand;
        end if;
        if p_purchase is not NULL then
            pPurchaseRate:=p_purchase;
        end if;
        if p_sales is not NULL then
            pSalesRate:=p_sales;
        end if;
        if p_quantity is not NULL then
           pQuantity:=p_quantity;
        end if;
        

        UPDATE Product2
        SET product_name = pName, product_description= pDesc, product_model=pModel,product_brand=pBrand,product_purchase_rate=pPurchaseRate,product_sales_rate=pSalesRate,total_quantity=pQuantity
        WHERE ProductID = p_id;

        exception 
            when NO_DATA_FOUND then
                dbms_output.put_line('No product found with id '||p_id);
    end update_product2_details;

    function get_branch_id_by_name(bName in Branch.branch_name%type)
    return Branch.BranchID%type is 
    begin 
        for row in (select * from Branch where lower(branch_name) like '%'||bName||'%') loop
            return row.BranchID;
        end loop;
        return 0;
    end get_branch_id_by_name;

end update_product_pack;
/


accept branchNameIn prompt "Enter branch name:";
accept pIdIn prompt "Enter product ID:";
accept pNameIn prompt "Enter product name to update:";
accept pDescIn prompt "Enter product description to update:";
accept pModelIn prompt "Enter product model to update:";
accept pBrandIn prompt "Enter product brand to update:";
accept pPurchaseRateIn prompt "Enter product purchase rate to update:";
accept pSalesRateIn prompt "Enter product sales rate to update:";
accept pQuantityIn prompt "Enter product total quantity to update:";


declare 
branchId Branch.BranchID%type;
branchName Branch.branch_name%type:='&branchNameIn';
pId Product.ProductID%type:=&pIdIn;
pName Product.product_name%type := '&pNameIn';
pDesc Product.product_description%type := '&pDescIn';
pModel Product.product_model%type:='&pModelIn';
pBrand Product.product_brand%type:='&pBrandIn';
pPurchaseRate Product.product_purchase_rate%type:= '&pPurchaseRateIn';
pSalesRate Product.product_sales_rate%type:= '&pSalesRateIn';
pQuantity Product.total_quantity%type := '&pQuantityIn';

branch_not_exist EXCEPTION;

begin 

    branchId := update_product_pack.get_branch_id_by_name(branchName);
    
    if BranchId = 0 THEN
        RAISE branch_not_exist;
    elsif BranchId = 1 then
        update_product_pack.update_product1_details(pId,pName,pDesc,pModel,pBrand,pPurchaseRate,pSalesRate,pQuantity);
    elsif BranchId = 2 then
        update_product_pack.update_product2_details(pId,pName,pDesc,pModel,pBrand,pPurchaseRate,pSalesRate,pQuantity);
    end if;

    EXCEPTION
		WHEN branch_not_exist THEN
			DBMS_OUTPUT.PUT_LINE('Branch does not exist.');

end;
/

commit;