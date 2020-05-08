codeunit 50002 "Event Call bef/Aft Posting"
{
    EventSubscriberInstance = StaticAutomatic;
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post (Yes/No)", 'OnAfterConfirmPost', '', true, true)]
    procedure OnAfterConfirmPost(PurchaseHeader: Record "Purchase Header")

    var
        PurchLineL: Record "Purchase Line";
    begin
        GeneralLedgerPosdtingG.PurchaseOrderToItemJournal(PurchaseHeader);

        PurchLineL.Reset();
        PurchLineL.SetRange("Document No.", PurchaseHeader."No.");
        PurchLineL.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchLineL.Setfilter("Qty To Reject", '<>%1', 0);
        PurchLineL.Setfilter("Qty. to Receive", '<>%1', 0);
        if PurchLineL.FindFirst() then
            GeneralLedgerPosdtingG.PurchaseOrderRejectToItemJournal(PurchaseHeader, PurchLineL);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeDeleteOneTransferHeader', '', true, true)]
    local procedure OnBeforeDeleteOneTransferHeader(TransferHeader: Record "Transfer Header"; var DeleteOne: Boolean)
    var
        ItemjrlLineL: Record "Item Journal Line";
        ItemJrlLinePostingL: codeunit "Item Jnl.-Post Line";
    begin

        GeneralLedgerPosdtingG.TransferOrderToItemJournal(TransferHeader);

        LocationG.Get(TransferHeader."Transfer-to Code");
        if LocationG."Location Type" = LocationG."Location Type"::" " then
            exit;
        ItemjrlLineL.Reset();
        ItemjrlLineL.SetRange("Journal Template Name", LocationG."Item Template Name");
        ItemjrlLineL.SetRange("Journal Batch Name", LocationG."Item Batch Name");
        if ItemjrlLineL.FindFirst() then
            repeat
                ItemJrlLinePostingL.Run(ItemjrlLineL);
            until ItemjrlLineL.Next() = 0;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterCheckMandatoryFields', '', true, true)]
    local procedure OnAfterCheckMandatoryFields(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    var
        ProductionPlanL: Record "Production Plan Header";
        SalseLineL: Record "Sales Line";
    begin
        LocationG.Get(SalesHeader."Location Code");
        if LocationG."Location Type" = LocationG."Location Type"::"Bulk Kitchen" then begin
            SalseLineL.Reset();
            SalseLineL.SetRange("Document No.", SalesHeader."No.");
            SalseLineL.Setfilter("Qty. to Ship", '<>%1', 0);
            if SalseLineL.FindSet() then
                repeat
                    ProductionPlanL.Reset();
                    ProductionPlanL.SetRange("BEO No.", SalesHeader."No.");
                    ProductionPlanL.SetRange("BEO Line No.", SalseLineL."Line No.");
                    if ProductionPlanL.FindFirst() then
                        if not (ProductionPlanL.Status = ProductionPlanL.Status::Finished) then
                            Error('Production Plan not yet posted');
                until SalseLineL.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostLines', '', true, true)]
    local procedure OnBeforePostLines(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    begin
        SalesLine.SetRange("Shipment Date", SalesHeader."Posting Date");   //050420 
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertItemLedgEntry', '', true, true)]
    local procedure OnBeforeInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; TransferItem: Boolean)
    begin
        ItemLedgerEntry."Reference Document No." := ItemJournalLine."Reference Document No.";
        ItemLedgerEntry."Maintenance Line No." := ItemJournalLine."Maintenance Line No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', true, true)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry."CL from Date" := GenJournalLine."CL from Date";
        GLEntry."CL To Date" := GenJournalLine."CL To Date";
        GLEntry."Bulk Kitchen" := GenJournalLine."Bulk Kitchen";
        GLEntry."Batch Description" := GenJournalLine."Batch Description";
    end;

    var
        LocationG: Record Location;
        GeneralLedgerPosdtingG: Codeunit "General Ledger Posting";
}
