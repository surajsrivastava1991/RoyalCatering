page 50040 "Service Indent List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purchase Indent Header";
    CardPageId = "Service Indent Card";
    Caption = 'Service Requisitions';
    SourceTableView = where("Replenishment Type" = CONST(1), "Service Requisition" = const(true));
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