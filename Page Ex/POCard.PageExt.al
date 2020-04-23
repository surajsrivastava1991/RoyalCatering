pageextension 50004 "PO Card" extends "Purchase Order"
{
    layout
    {
        addafter(Status)
        {
            field("Mail Sent"; "Mail Sent")
            {
                ApplicationArea = all;
                ToolTip = 'Mail sent to vendor with attchmented report';
            }
            field("Created By"; "Created By")
            {
                ApplicationArea = all;
                ToolTip = 'Created by the user';
            }
        }
        addafter(General)
        {
            group("Email Body")
            {
                field("Mail Body1"; "Mail Body1")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Mail Body2"; "Mail Body2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    MultiLine = true;
                }
                field("Mail Body3"; "Mail Body3")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    MultiLine = true;

                }
                field("Mail Body4"; "Mail Body4")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Visible = false;
                }
                field("Mail Body5"; "Mail Body5")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Visible = false;
                }
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        modify(Post)
        {
            Visible = false;
            Enabled = false;
        }
        addbefore(Preview)
        {
            action(PostC)
            {
                ApplicationArea = Suite;
                Caption = 'P&ost';
                Ellipsis = true;
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                var
                    ItemjrlLineL: Record "Item Journal Line";
                    PurchreceiptHeaderL: Record "Purch. Rcpt. Header";
                    PurchLineL: Record "Purchase Line";
                    ItemJrlLinePostingL: codeunit "Item Jnl.-Post Line";
                    JrlLinePostingL: codeunit "Item Journal Posting";
                    DocumentNoL: Code[20];
                begin
                    TestField("Location Code");
                    LocationG.Get("Location Code");
                    LocationG.TestField("Reject Location");
                    if LocationG."Location Type" <> LocationG."Location Type"::" " then begin
                        LocationG.TestField("Item Template Name");
                        LocationG.TestField("Item Batch Name");
                    end;

                    LocationG.TestField("Transfer Template Name");
                    LocationG.TestField("Transfer Batch Name");
                    DocumentNoL := "No.";
                    //Purchase Psoting 

                    CODEUNIT.Run(CODEUNIT::"Purch.-Post (Yes/No)", Rec);

                    // if LocationG."Location Type" = LocationG."Location Type"::" " then
                    //     exit;

                    // For Flow of Posted Purchase Receipt No. Till Item Ledger Entry
                    PurchreceiptHeaderL.Reset();
                    PurchreceiptHeaderL.SetRange("Order No.", DocumentNoL);
                    if PurchreceiptHeaderL.FindLast() then begin

                        ItemjrlLineL.Reset();
                        ItemjrlLineL.SetRange("Journal Template Name", LocationG."Item Template Name");
                        ItemjrlLineL.SetRange("Journal Batch Name", LocationG."Item Batch Name");
                        if ItemjrlLineL.FindFirst() then
                            repeat
                                ItemjrlLineL."Reference Document No." := PurchreceiptHeaderL."No.";
                                ItemjrlLineL.Modify();
                            until ItemjrlLineL.Next() = 0;
                    end;

                    //For Sales Negative Entry

                    ItemjrlLineL.Reset();
                    ItemjrlLineL.SetRange("Journal Template Name", LocationG."Item Template Name");
                    ItemjrlLineL.SetRange("Journal Batch Name", LocationG."Item Batch Name");
                    if ItemjrlLineL.FindFirst() then
                        repeat
                            if LocationG."Location Type" <> LocationG."Location Type"::" " then
                                ItemJrlLinePostingL.Run(ItemjrlLineL);
                        until ItemjrlLineL.Next() = 0;

                    //For Rejected Qty Reclassification Posting

                    ItemjrlLineL.Reset();
                    ItemjrlLineL.SetRange("Journal Template Name", LocationG."Transfer Template Name");
                    ItemjrlLineL.SetRange("Journal Batch Name", LocationG."Transfer Batch Name");
                    if ItemjrlLineL.FindFirst() then
                        JrlLinePostingL.Run(ItemjrlLineL);

                    //Purchase Line Qty Rejected modification
                    PurchLineL.Reset();
                    PurchLineL.SetRange("Document No.", "No.");
                    PurchLineL.SetRange("Document Type", "Document Type");
                    PurchLineL.Setfilter("Qty To Reject", '<>%1', 0);
                    if PurchLineL.FindFirst() then
                        repeat
                            PurchLineL."Rejected Qty." += PurchLineL."Qty To Reject";
                            PurchLineL."Qty To Reject" := 0;
                            // PurchLineL."Qty. to Accept" := PurchLineL.Quantity - PurchLineL."Quantity Received";
                            PurchLineL.Modify();
                        until PurchLineL.Next() = 0;
                end;

            }
        }

        addbefore("&Print")
        {
            action("Send Mail")
            {
                ApplicationArea = all;
                ToolTip = 'Table field';
                Image = MailAttachment;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                trigger OnAction()
                begin
                    PurchaseHeaderG.RESET();
                    PurchaseHeaderG.SetRange("No.", "No.");
                    Report.Run(50003, true, true, PurchaseHeaderG);
                    if Confirm('Do you want to send an E-mail to vendor?') then
                        if "Mail Sent" then begin
                            if Confirm('Mail sent already, Do you want to send it again?') then
                                SendMail();
                        end else
                            SendMail();

                end;
            }

        }
    }
    var
        PurchaseHeaderG: Record "Purchase Header";
        LocationG: Record location;
        ItemJournalPostingCodeUnitG: Codeunit "General Ledger Posting";


}