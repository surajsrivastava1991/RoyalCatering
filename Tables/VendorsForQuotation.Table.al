table 50004 "Vendors For Quotations"
{
    Caption = 'Vendors For Quotations';
    DataClassification = ToBeClassified;
    LookupPageId = "Vendors for quotation";
    DrillDownPageId = "Vendors for quotation";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        /*        
        field(1; "Worksheet Template Name"; Code[10])
        {
            Caption = 'Worksheet Template Name';
            TableRelation = "Req. Wksh. Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Requisition Wksh. Name".Name WHERE("Worksheet Template Name" = FIELD("Worksheet Template Name"));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        */
        field(4; "Vendor No."; Code[20])
        {
            Caption = 'MyField';
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
            trigger OnLookup()
            begin
                if "Select from vendor-item" = true then begin
                    //RequiWksheetG.Get("Worksheet Template Name", "Journal Batch Name", "Line No.");
                    ItemVendorG.Reset();
                    RequiWksheetG.Reset();
                    RequiWksheetG.SetRange("Req. Document No.", "Document No.");
                    RequiWksheetG.SetRange("Req. Line No.", "Line No.");
                    if RequiWksheetG.FindFirst() then
                        ItemVendorG.SetRange("Item No.", RequiWksheetG."No.");
                    if Page.RunModal(Page::"Item Vendor Catalog", ItemVendorG) = Action::LookupOK then
                        "Vendor No." := ItemVendorG."Vendor No.";
                end else
                    if Page.RunModal(Page::"Vendor List", VendorG) = Action::LookupOK then
                        "Vendor No." := VendorG."No.";
            end;
        }
        field(5; "Select from vendor-item"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.", "Vendor No.")
        {
            Clustered = true;
        }
    }
    var
        VendorG: Record Vendor;
        ItemVendorG: Record "Item Vendor";
        RequiWksheetG: Record "Requisition Line";
        ItemsG: Record Item;

}
/*
table 50004 "Vendors For Quotations"
{
    Caption = 'Vendors For Quotations';
    DataClassification = ToBeClassified;
    LookupPageId = "Vendors for quotation";
    DrillDownPageId = "Vendors for quotation";

    fields
    {
        field(1; "Worksheet Template Name"; Code[10])
        {
            Caption = 'Worksheet Template Name';
            TableRelation = "Req. Wksh. Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Requisition Wksh. Name".Name WHERE("Worksheet Template Name" = FIELD("Worksheet Template Name"));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Vendor No."; Code[20])
        {
            Caption = 'MyField';
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
            trigger OnLookup()
            begin
                if "Select from vendor-item" = true then begin
                    RequiWksheetG.Get("Worksheet Template Name", "Journal Batch Name", "Line No.");
                    ItemVendorG.Reset();
                    ItemVendorG.SetRange("Item No.", RequiWksheetG."No.");
                    if Page.RunModal(Page::"Item Vendor Catalog", ItemVendorG) = Action::LookupOK then
                        "Vendor No." := ItemVendorG."Vendor No.";
                end else
                    if Page.RunModal(Page::"Vendor List", VendorG) = Action::LookupOK then
                        "Vendor No." := VendorG."No.";
            end;
        }
        field(5; "Select from vendor-item"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; "Worksheet Template Name", "Journal Batch Name", "Line No.", "Vendor No.")
        {
            Clustered = true;
        }
    }
    var
        VendorG: Record Vendor;
        ItemVendorG: Record "Item Vendor";
        RequiWksheetG: Record "Requisition Line";
        ItemsG: Record Item;
        vendItemCatG: Record "Item Vendor";

}
*/
