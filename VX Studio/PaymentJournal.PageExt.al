pageextension 50090 "Payment Journal" extends "Payment Journal"
{
    layout
    {
        addbefore(Amount)
        {
            field(Narration; Narration)
            { ApplicationArea = All; }
            field(VoucherNarration; "Voucher Narration")
            { ApplicationArea = All; }


        }
    }

    actions
    {
        addlast("&Line")
        {
            action("Voucher Narration")
            {
                ApplicationArea = All;
                Image = VoucherDescription;
                RunObject = page Narration;
                RunPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                   "Journal Batch Name" = FIELD("Journal Batch Name"),
                   "Document No." = FIELD("Document No."), "Gen. Journal Line No." = FILTER(0);
                trigger OnAction()
                begin

                end;
            }
            action("Line Narration")
            {
                ApplicationArea = All;
                Image = LineDescription;
                RunObject = page "Line Narration";
                RunPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                    "Journal Batch Name" = FIELD("Journal Batch Name"),
                    "Gen. Journal Line No." = FIELD("Line No."), "Document No." = FIELD("Document No.");
                trigger OnAction()
                begin

                end;
            }
            action("Preview Voucher")
            {
                ApplicationArea = All;
                Image = PreviewChecks;
                trigger OnAction()
                var
                    GenJournalL: Record "Gen. Journal Line";
                begin
                    GenJournalL.Reset();
                    GenJournalL.SetRange("Journal Template Name", "Journal Template Name");
                    GenJournalL.SetRange("Journal Batch Name", "Journal Batch Name");
                    GenJournalL.SetRange("Document No.", "Document No.");
                    GenJournalL.SetRange("Posting Date", "Posting Date");
                    Report.RunModal(50301, true, false, GenJournalL);
                end;
            }
        }
    }

    var
        myInt: Integer;
}