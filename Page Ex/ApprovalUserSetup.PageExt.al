pageextension 50055 "Approval User Setup" extends "Approval User Setup" //MyTargetPageId
{
    layout
    {
        addlast(Control1)
        {
            field("Unlimited Indent Approval"; "Unlimited Indent Approval")
            {
                ApplicationArea = All;
                Caption = 'Unlimited Requisition approval';
                ToolTip = 'Table Field';
            }
        }
    }

    actions
    {
    }
}