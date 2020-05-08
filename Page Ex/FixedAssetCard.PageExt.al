pageextension 50070 "Fixed Asset Card" extends "Fixed Asset Card"
{
    layout
    {
        addafter(Blocked)
        {
            field("Item No."; "Item No.")
            {
                ApplicationArea = all;
                ToolTip = 'Inventory Item for FA';
            }
            field("Quote Mandatory"; "Quote Mandatory")
            {
                ApplicationArea = All;
                ToolTip = 'Table Fields';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}