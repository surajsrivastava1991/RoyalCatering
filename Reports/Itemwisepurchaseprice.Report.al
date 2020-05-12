report 50004 "Item wise purchase price"
{
    Caption = 'Item wise purchase price';
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './res/ItemwisePurPriceLayout.rdl';

    dataset
    {
        dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
        {
            DataItemTableView = sorting(Type, "No.") where(type = const(Item));
            RequestFilterFields = "Posting Date", "No.", "Buy-from Vendor No.", "Document No.";
            column(ItemCatCodeVar1; ItemCatCodeVar1)
            {

            }
            column(ItemCatCodeVar2; ItemCatCodeVar2)
            {

            }
            column(ItemCatCodeVar3; ItemCatCodeVar3)
            {

            }
            column(Item_No; ItemG."No.")
            {

            }
            column(Item_Name; ItemG.Description)
            {

            }
            column(Unit_of_Measure_Code; "Unit of Measure Code")
            {

            }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
            {

            }
            column(VendorName; VendorG.Name)
            {

            }
            column(Quantity; Quantity)
            {

            }
            column(Unit_Cost; "Unit Cost")
            {

            }
            column(Line_Amount; "Line Amount")
            {

            }
            column(DateFilterText; DateFilterText)
            {

            }
            column(ItemFilterText; ItemFilterText)
            {

            }
            column(VendorFilterText; VendorFilterText)
            {

            }
            column(Country_Origin_Code; ItemG."Country/Region of Origin Code")
            {

            }
            column(ManuFactCodeText; ManuFactCodeText)
            {

            }
            trigger OnPreDataItem()
            begin
                DateFilterText := 'Date Filter : ' + "Purch. Inv. Line".GetFilter("Posting Date");
                ItemFilterText := 'Item Filters : ' + "Purch. Inv. Line".GetFilter("No.");
                VendorFilterText := 'Vendor Filters : ' + "Purch. Inv. Line".GetFilter("Buy-from Vendor No.");
            end;

            trigger OnAfterGetRecord()
            begin
                ItemG.Get("No.");
                ItemCatCode1G.Reset();
                ItemCatCode2G.Reset();
                ItemCatCode3G.Reset();
                ManuFactCodeText := '';
                ItemCatCodeVar1 := '';
                ItemCatCodeVar2 := '';
                ItemCatCodeVar3 := '';
                if ItemCatCode1G.Get(ItemG."Item Category Code") then begin
                    ItemCatCodeVar1 := ItemCatCode1G.Code;
                    if ItemCatCode2G.Get(ItemCatCode1G."Parent Category") then begin
                        ItemCatCodeVar2 := ItemCatCode2G.Code;
                        if ItemCatCode3G.Get(ItemCatCode2G."Parent Category") then
                            ItemCatCodeVar3 := ItemCatCode3G.Code;
                    end;
                end;
                if ManufacturerCodeG.Get(ItemG."Manufacturer Code") then
                    ManuFactCodeText := ManufacturerCodeG.Name;
                if VendorG.Get("Buy-from Vendor No.") then;
            end;
        }

    }

    var
        ItemG: Record Item;
        ItemCatCode1G: Record "Item Category";
        ItemCatCode2G: Record "Item Category";
        ItemCatCode3G: Record "Item Category";
        ManufacturerCodeG: Record Manufacturer;
        VendorG: Record Vendor;
        ItemCatCodeVar1: Code[20];
        ItemCatCodeVar2: Code[20];
        ItemCatCodeVar3: Code[20];
        DateFilterText: Text[100];
        ItemFilterText: Text[100];
        VendorFilterText: Text[100];
        ManuFactCodeText: Text[50];
}