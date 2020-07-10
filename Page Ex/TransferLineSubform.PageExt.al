pageextension 50122 "Transfer Line Subform" extends "Transfer Order Subform"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("Unit Cost"; "Unit Cost")
            {
                ApplicationArea = all;
                ToolTip = 'Item Unit Cost';
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}