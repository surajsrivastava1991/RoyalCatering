pageextension 50012 "Inventory Setup Ex" extends "Inventory Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Location Mandatory")
        {
            field("Kitchen Cost Account"; "Kitchen Cost Account")
            {
                ApplicationArea = all;
                ToolTip = 'Bulk Kitchen Costing Account';
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }
}