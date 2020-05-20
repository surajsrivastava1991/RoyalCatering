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
                field("Check Amount"; "Check Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'PDC Amount';
                }
                field("Entry Posted"; "Entry Posted")
                {
                    ApplicationArea = all;
                    ToolTip = 'Entry Posted';
                    Editable = false;
                }
                field("Jouranl Type"; "Jouranl Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Journal Type';
                    Editable = false;
                }
                field(Template; Template)
                {
                    ApplicationArea = all;
                    ToolTip = 'Template';
                    Editable = false;
                }
                field("Batch No."; "Batch No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Batch No.';
                    Editable = false;
                }
                field("Customer No./Vendor No."; "Customer No./Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Customer/ Vendor No.';
                    Editable = false;
                }
                field("Customer/Vendor Name"; "Customer/Vendor Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Customer/Vendor Name';
                    Editable = false;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = all;
                    ToolTip = 'Amount';
                    Editable = false;
                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Bank Account No.';
                    Editable = false;
                }
                field("Bank Account Name"; "Bank Account Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Bank Account Name';
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Creation)
        {
            group(Export)
            {
                Caption = 'Export';
                Image = Export;
                action("PDC Export")
                {
                    ApplicationArea = all;
                    Caption = 'PDC Export';
                    Image = Export;
                    Promoted = true;
                    PromotedOnly = true;
                    RunObject = xmlport "PDC Export";
                    ToolTip = 'Export the PDC Entry';
                }
            }
        }
    }
}