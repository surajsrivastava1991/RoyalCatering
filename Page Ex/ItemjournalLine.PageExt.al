pageextension 50075 "Item Journal Line" extends "Item Journal"
{
    layout
    {
        addafter("Shortcut Dimension 1 Code")
        {
            field("Reference Document No."; "Reference Document No.")
            {
                ApplicationArea = all;
                ToolTip = 'Document no you have to specify which you want to post';
            }
            field("Maintenance Line No."; "Maintenance Line No.")
            {
                ApplicationArea = all;
                ToolTip = 'Line no of maintenance order, which you are going to post';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}