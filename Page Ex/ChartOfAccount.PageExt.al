pageextension 50089 "Chart Of Account" extends "G/L Account Card"
{
    layout
    {
        addafter("Account Type")
        {
            field("Fee/Charge Type"; "Fee/Charge Type")
            {
                ApplicationArea = all;
                ToolTip = 'Changed Type';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}