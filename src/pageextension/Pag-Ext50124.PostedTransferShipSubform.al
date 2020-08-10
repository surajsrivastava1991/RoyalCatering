pageextension 50124 "Posted Transfer Ship Subform" extends "Posted Transfer Shpt. Subform"
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

    }

}