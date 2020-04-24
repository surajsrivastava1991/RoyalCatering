page 50039 "Purchase Indent List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purchase Indent Header";
    CardPageId = "Purchase Indent Card";
    Caption = 'Purchase Requisitions';
    SourceTableView = where("Replenishment Type" = CONST(1));
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
            }
        }
    }
}