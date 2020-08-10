pageextension 50098 "Sales Header" extends "Sales Invoice"
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
            field("Bank Code"; "Bank Code")
            {
                ApplicationArea = all;
                ToolTip = 'Bank Details for Payment';
            }
        }
    }
}