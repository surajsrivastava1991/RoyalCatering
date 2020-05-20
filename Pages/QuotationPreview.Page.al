page 50046 "Quotation Preview"
{
    Caption = 'Quotation Preview';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purchase Line";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Item No"; "No.")
                {
                    Caption = 'Item No.';
                    ApplicationArea = All;
                    ToolTip = 'TableFields';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'TableFields';
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Document No."; "Document No.")
                {
                    Caption = 'Document No.';
                    ApplicationArea = All;
                    ToolTip = 'TableFields';
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'TableFields';
                }
                field("Vendor Name"; PurchaseHdrG."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'TableFields';
                }
                field(Status; PurchaseHdrG.Status)
                {
                    StyleExpr = StyleTextVar;
                    ApplicationArea = All;
                    ToolTip = 'TableFields';
                }
                field("Unit Cost"; "Direct Unit Cost")
                {
                    Caption = 'Unit Cost';
                    ApplicationArea = All;
                    ToolTip = 'TableFields';
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'TableFields';
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'TableFields';
                }

                field("Quote Cancelled"; PurchaseHdrG."Quote Cancelled")
                {
                    ApplicationArea = All;
                    ToolTip = 'TableFields';
                }
                field("Ref. Requisition ID"; PurchaseHdrG."Ref. Requisition ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'TableFields';
                }
                field("Commercial Specification"; "Commercial Specification")
                {
                    ApplicationArea = All;
                    ToolTip = 'TableFields';
                }
                field("Technical Sepcification"; "Technical Sepcification")
                {
                    ApplicationArea = All;
                    ToolTip = 'TableFields';
                }
                field("User Comment"; "User Comment")
                {
                    ApplicationArea = All;
                    ToolTip = 'TableFields';
                }

            }
        }
        area(Factboxes)
        {

        }
    }
    actions
    {
        area(Processing)
        {
            action(ShowRecord)
            {
                ApplicationArea = All;
                ToolTip = 'Show Record';
                trigger OnAction()
                begin
                    PurchaseHdrG.Get("Document Type", "Document No.");
                    if PurchaseHdrG."Document Type" = PurchaseHdrG."Document Type"::Quote then
                        Page.Run(Page::"Purchase Quote", PurchaseHdrG)
                    else
                        Page.Run(Page::"Purchase Order", PurchaseHdrG);
                end;
            }
        }
    }
    var
        PurchaseHdrG: Record "Purchase Header";
        StyleTextVar: Text;

    trigger OnAfterGetRecord()
    begin
        PurchaseHdrG.Get("Document Type", "Document No.");
        if PurchaseHdrG.Status = PurchaseHdrG.Status::Released then
            StyleTextVar := 'Favorable'
        else
            StyleTextVar := 'Standard';
    end;
}