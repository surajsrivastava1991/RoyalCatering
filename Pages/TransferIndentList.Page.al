page 50034 "Transfer Indent List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purchase Indent Header";
    CardPageId = "Transfer Indent";
    Caption = 'Transfer Requisitions';
    SourceTableView = where("Replishment Type" = CONST(2));
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
                    ToolTip = 'Table field';

                }
                field(Details; Details)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table field';

                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table field';

                }
                field("Approval Status"; "Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table field';

                }

            }
        }
        area(Factboxes)
        {

        }
    }
}