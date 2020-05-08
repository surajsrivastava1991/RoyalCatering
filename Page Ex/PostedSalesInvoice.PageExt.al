pageextension 50099 "Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Work Description")
        {
            field("Invoice Description"; "Invoice Description")
            {
                ApplicationArea = all;
                ToolTip = 'Invoice Description';
            }
        }
    }
}