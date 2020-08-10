tableextension 50059 "Requisition Line Ext" extends "Requisition Line"
{
    fields
    {
        field(50000; "Req. Document No."; Code[20])
        {
            Editable = false;
            Caption = 'Req. Document No.';
            DataClassification = CustomerContent;
        }
        field(50001; "Req. Line No."; Integer)
        {
            Editable = false;
            Caption = 'Req. Line No.';
            DataClassification = CustomerContent;
        }
        field(50002; "From Request"; Boolean)
        {
            Caption = 'From Request';
            DataClassification = CustomerContent;
        }
        field(50003; "Vendor Trade Agreement"; Boolean)
        {
            Editable = false;
            Caption = 'Vendor Trade Agreement';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CheckOrderOrQuote();
            end;
        }
        field(50004; "Purchaser Code"; Code[50])
        {
            Caption = 'Purchase Code';
            DataClassification = CustomerContent;
            TableRelation = "User Setup";
        }
        field(50005; "Cancelled"; Boolean)
        {
            Editable = false;
            Caption = 'Cancelled';
            DataClassification = CustomerContent;
        }
        field(50006; "Vendors For Quotation"; Integer)
        {
            Caption = 'Vendors For Quotation';
            FieldClass = FlowField;
            CalcFormula = count ("Vendors For Quotations" where("Document No." = field("Req. Document No."),
            "Line No." = field("Req. Line No.")));
        }
        field(50007; "Order/Quote"; Option)
        {
            Caption = 'Order/Quote';
            OptionMembers = " ","Purchase Order","Purchase Quote";
            DataClassification = CustomerContent;
        }
        field(50008; "Purchase quote mandatory"; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        modify("Replenishment System")
        {
            trigger OnAfterValidate()
            begin
                CheckOrderOrQuote();
            end;
        }
        modify("No.")
        {
            TableRelation = Item;
            trigger OnAfterValidate()
            var
                ItemL: Record Item;
            begin
                if Type = Type::Item then
                    if ItemL.Get("No.") then
                        "Purchase quote mandatory" := ItemL."Quote Mandatory";
            end;
        }
    }
    procedure CheckOrderOrQuote()
    var
        PurchSetupL: Record "Purchases & Payables Setup";
    begin
        PurchSetupL.Get();
        if ("Replenishment System" = "Replenishment System"::Purchase) then begin
            if ((not "Vendor Trade Agreement") and PurchSetupL."Check Vendor Trade Agreement") or ("Purchase quote mandatory" and PurchSetupL."Quote all") then
                "Order/Quote" := "Order/Quote"::"Purchase Quote"
            else
                "Order/Quote" := "Order/Quote"::"Purchase Order";
        end else
            "Order/Quote" := "Order/Quote"::" ";
    end;
}