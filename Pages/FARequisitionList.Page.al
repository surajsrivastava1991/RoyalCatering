page 50043 "FA Indent List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purchase Indent Header";
    CardPageId = "FA Indent Card";
    Caption = 'Fixed Asset Requisitions';
    SourceTableView = where("Replenishment Type" = CONST(1), "Requisition Type" = const("Fixed Asset"));
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Details; Details)
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Approval Status"; "Approval Status")
                {
                    ApplicationArea = All;
                }
                field("Transaction Status"; "Transaction Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}