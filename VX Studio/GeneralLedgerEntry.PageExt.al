pageextension 50096 "General Ledger Entry" extends "General Ledger Entries"
{
    layout
    {

    }

    actions
    {
        addlast(Reporting)
        {
            /* action("Voucher Narration")
            {
                ApplicationArea = all;
                Image = Description;
                RunObject = page "Posted Narration";
                RunPageLink = "Entry No." = filter (0), "Transaction No." = field ("Transaction No.");
            }
            action("Line Narration")
            {
                ApplicationArea = all;
                Image = LineDescription;
                RunObject = page "Posted Narration";
                RunPageLink = "Entry No." = FIELD ("Entry No."), "Transaction No." = field ("Transaction No.");
            } */
            action("Print Voucher")
            {
                ApplicationArea = All;
                Image = PrintVoucher;
                ToolTip = 'Print Voucher';
                Ellipsis = true;
                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                //TempGLEntry: Record "Temp. G/L Entry";
                begin
                    //TempGLEntry.DeleteAll();
                    //GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
                    GLEntry.SETRANGE("Document No.", "Document No.");
                    GLEntry.SETRANGE("Posting Date", "Posting Date");
                    //IF GLEntry.FindSet() THEN
                    /*    repeat
                           TempGLEntry.Reset();
                           TempGLEntry."Entry No." := GLEntry."Entry No.";
                           TempGLEntry.TransferFields(GLEntry);
                           TempGLEntry.Insert();
                       Until GLEntry.Next() = 0;
                   Commit();
                   TempGLEntry.Reset();
                   TempGLEntry.SETRANGE("Document No.", "Document No.");
                   TempGLEntry.SETRANGE("Posting Date", "Posting Date");
                   IF TempGLEntry.FindSet() then */
                    REPORT.RUN(REPORT::"Posted Voucher", TRUE, TRUE, GLEntry);
                end;
            }
        }
    }
}