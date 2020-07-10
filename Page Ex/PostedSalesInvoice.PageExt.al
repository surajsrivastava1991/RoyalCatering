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
            field("Bank Code"; "Bank Code")
            {
                ApplicationArea = all;
                ToolTip = 'Bank Details for Payment';
            }
        }
    }
    actions
    {
        modify(Print)
        {
            ApplicationArea = Basic, Suite;
            ToolTip = 'Tax Invoice';
            Promoted = true;
            PromotedOnly = true;
            PromotedCategory = Report;
            Caption = 'Tax Invoice';
        }
        addafter(Email)
        {
            action("Facility Management")
            {
                ApplicationArea = Basic, Suite;
                Image = PrintReport;
                ToolTip = 'Facility Management';
                Ellipsis = true;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    SalesInvoiceL: Record "Sales Invoice Header";
                begin
                    SalesInvoiceL.Reset();
                    SalesInvoiceL.SetRange("No.", "No.");
                    REPORT.RUN(REPORT::"Facility Management", TRUE, TRUE, SalesInvoiceL);
                end;
            }

        }
    }

}
