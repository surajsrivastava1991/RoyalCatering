page 50045 "FA Indent Subpage"
{

    PageType = ListPart;
    SourceTable = "Purchase Indent Line";
    Caption = 'FA Indent Subpage';
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Type; Type)
                {
                    Editable = false;
                    OptionCaption = ' ,,,,,Fixed Asset,Item(Service)';
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                    trigger OnValidate()
                    var
                        ItemL: Record Item;
                    begin
                        "Order/Quote" := "Order/Quote"::"Purchase Order";
                        //ItemL.Get("No.");
                        //"Vendor No." := ItemL."Vendor No.";
                        //CurrPage.Update(true);
                    end;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Replenishment Type"; "Replenishment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Order/Quote"; "Order/Quote")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Vendors For Quotation"; "Vendors For Quotation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                }
                field("Direct Unit Cost"; "Direct Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'table fields';
                }
                field("Receiving Location"; "Receiving Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                }
                field("From Location"; "From Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                }
                field("Requested Date"; "Requested Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Trade agreement exist"; "Trade agreement exist")
                {
                    Caption = 'Vendor Trade Agreement';
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Purchase quote mandatory"; "Purchase quote mandatory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Transaction Status"; "Transaction Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Ref. Document Type"; "Ref. Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Ref. Document No."; "Ref. Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Ref. Document Line No."; "Ref. Document Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        PurchIndentHdrG.get("Document No.");
        "Item Category Code" := PurchIndentHdrG."Item Category Code";
        "Receiving Location" := PurchIndentHdrG."Receiving Location";
        "Requested Date" := PurchIndentHdrG."Requested Date";
        "Replenishment Type" := PurchIndentHdrG."Replenishment Type";
        "From Location" := PurchIndentHdrG."From Location";
        "Creation Date" := PurchIndentHdrG."Creation Date";
        Type := Type::"Fixed Asset";
    end;

    var
        PurchIndentHdrG: Record "Purchase Indent Header";

}