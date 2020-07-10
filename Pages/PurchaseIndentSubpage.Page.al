page 50037 "Purchase Indent Subpage"
{

    PageType = ListPart;
    SourceTable = "Purchase Indent Line";
    Caption = 'Purchase Indent Subpage';
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
                    OptionCaption = ' ,,Item,,,,';
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
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
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
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
                field("Unit Cost"; "Unit Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Unit cost of the Item based on the Unit of measurement';
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PurchIndentHdrG: Record "Purchase Indent Header";
    begin
        PurchIndentHdrG.get("Document No.");
        "Item Category Code" := PurchIndentHdrG."Item Category Code";
        "Receiving Location" := PurchIndentHdrG."Receiving Location";
        "Requested Date" := PurchIndentHdrG."Requested Date";
        "Replenishment Type" := PurchIndentHdrG."Replenishment Type";
        "From Location" := PurchIndentHdrG."From Location";
        "Creation Date" := PurchIndentHdrG."Creation Date";
        Type := Type::Item;
    end;
}