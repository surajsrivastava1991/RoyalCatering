pageextension 50021 GenJnlTemplate extends "General Journal Templates"
{
    layout
    {
        addafter("Bal. Account No.")
        {
            field("Custumised Jnl."; "Custumised Jnl.")
            {
                ApplicationArea = all;
                ToolTip = 'Custom Fields';
            }
            field("Batch No. Series"; "Batch No. Series")
            {
                ApplicationArea = all;
                ToolTip = 'Custom Fields';
            }
            field("Batch Decription"; "Batch Description")
            {
                ApplicationArea = all;
                ToolTip = 'Custom Fields';
            }
            field("Allow Multiple Voucher"; "Allow Multiple Voucher")
            {
                ApplicationArea = all;
                ToolTip = 'Custom Fields';
            }
            field("Voucher Name"; "Voucher Name")
            {
                ApplicationArea = all;
                ToolTip = 'Voucher Name';
            }
            field("PDC Required"; "PDC Required")
            {
                caption = 'PDC Required';
                ApplicationArea = all;
                ToolTip = 'For PDC Posting';
            }
        }

    }
    actions
    {
        // Add changes to page actions here
    }
}