pageextension 50039 "User Setup" extends "User Setup"
{
    layout
    {
        addafter(PhoneNo)
        {
            field("Unlimited Indent Approval"; "Unlimited Indent Approval")
            {
                ApplicationArea = all;
                ToolTip = 'Table Field';
            }
            field("Unlimited Purchase Approval"; "Unlimited Purchase Approval")
            {
                ApplicationArea = all;
                ToolTip = 'Table Field';
            }
            field("Unlimited Request Approval"; "Unlimited Request Approval")
            {
                ApplicationArea = all;
                ToolTip = 'Table Field';
            }
            field("Unlimited Sales Approval"; "Unlimited Sales Approval")
            {
                ApplicationArea = all;
                ToolTip = 'Table Field';
            }

        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }
}