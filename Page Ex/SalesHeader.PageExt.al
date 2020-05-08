pageextension 50098 "Sales Header" extends "Sales Order"
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