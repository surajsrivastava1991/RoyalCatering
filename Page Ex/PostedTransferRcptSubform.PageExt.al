pageextension 50123 "Posted Transfer Rcpt Subform" extends "Posted Transfer Rcpt. Subform"
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