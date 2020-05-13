page 50101 "PDC Entry"
{
    PageType = List;
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = "PDC Entry";
    Caption = 'PDC Entry';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Check No. For PDC Entry';
                }
                field("PDC Status"; "PDC Status")
                {
                    ApplicationArea = all;
                    ToolTip = 'Check Status For PDC Entry';
                    Editable = false;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'PDC Creation Date';
                    Editable = false;
                }
                field("Check Maturity Date"; "Check Maturity Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Check Maturity Date';
                    Editable = false;
                }
            }
        }
    }
}