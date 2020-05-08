codeunit 50020 JnlSelectionApprovalEvents
{
    EventSubscriberInstance = StaticAutomatic;
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterSetupNewLine', '', true, false)]
    local procedure GenJnlDocNoUpdate(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlTempL: Record "Gen. Journal Template";
        GenJnlLineL: Record "Gen. Journal Line";
        GenJrlBatchL: Record "Gen. Journal Batch";
    begin
        if GenJournalLine."Journal Template Name" = '' then
            exit;
        GenJnlLineL.Reset();
        GenJnlLineL.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJnlLineL.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        if GenJnlLineL.count = 0 then begin
            if GenJnlTempL.get(GenJournalLine."Journal Template Name") and (GenJnlTempL."Custumised Jnl.") then begin
                GenJournalLine."Document No." := GenJournalLine."Journal Batch Name" + GenJournalLine."Document No.";
                GenJrlBatchL.Reset();
                GenJrlBatchL.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
                GenJrlBatchL.SetRange(Name, GenJournalLine."Journal Batch Name");
                if GenJrlBatchL.FindFirst() then
                    GenJournalLine."Batch Description" := GenJrlBatchL."Description 2";
            end;
        end else begin
            GenJrlBatchL.Reset();
            GenJrlBatchL.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
            GenJrlBatchL.SetRange(Name, GenJournalLine."Journal Batch Name");
            if GenJrlBatchL.FindFirst() then
                GenJournalLine."Batch Description" := GenJrlBatchL."Description 2";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GenJnlManagement, 'OnTemplateSelectionSetFilter', '', true, false)]
    local procedure TemplateFilter(var GenJnlTemplate: Record "Gen. Journal Template")
    begin
        GenJnlTemplate.SetRange("Custumised Jnl.", false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnAfterGetPageID', '', true, false)]
    local procedure ApprovalEntryGetPage(RecordRef: RecordRef; var Pageid: Integer)
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        genJnlTemplate: Record "Gen. Journal Template";
    begin


        if (RecordRef.NUMBER = DATABASE::"Gen. Journal Batch") or (RecordRef.NUMBER = DATABASE::"Gen. Journal Line") then begin
            RecordRef.SETTABLE(GenJournalLine);
            if genJnlTemplate.get(GenJournalLine."Journal Template Name") and genJnlTemplate."Custumised Jnl." then
                case genJnlTemplate.Type of
                    genJnlTemplate.Type::General:
                        pageid := page::"Custumised General Journal";
                    genJnlTemplate.Type::Payments:
                        pageid := page::"Custumised Payment - Journal";
                    genJnlTemplate.Type::"Cash Receipts":
                        pageid := page::"Cust. Cash Receipt - Journal";
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Table, database::"Approval Entry", 'OnAfterInsertEvent', '', true, false)]
    local procedure SetBatchStatus(var Rec: Record "Approval Entry"; RunTrigger: Boolean)
    var
        GenJournalBatch: Record "Gen. Journal Batch";

        RecRef: RecordRef;
    begin
        if Rec."Table ID" <> Database::"Gen. Journal Batch" then
            exit;
        if RecRef.GET(rec."Record ID to Approve") then begin
            RecRef.SETTABLE(GenJournalBatch);
            if rec.Status = Rec.Status::Created then
                GenJournalBatch.VALIDATE("Approval Status", GenJournalBatch."Approval Status"::"Sent for Approval");
            GenJournalBatch.MODIFY(TRUE);
        end;
    end;

    [EventSubscriber(ObjectType::codeunit, Codeunit::"Approvals Mgmt.", 'OnCancelGeneralJournalBatchApprovalRequest', '', true, false)]
    local procedure UpdateGenBatchCancelStatus(var GenJournalBatch: Record "Gen. Journal Batch")
    begin
        GenJournalBatch.VALIDATE("Approval Status", GenJournalBatch."Approval Status"::Open);
        GenJournalBatch.MODIFY();
    end;

    [EventSubscriber(ObjectType::codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', true, false)]
    local procedure UpdateGenBatchApprovedStatus(var ApprovalEntry: Record "Approval Entry")
    var
        GenJournalBatch: Record "Gen. Journal Batch";

        RecRef: RecordRef;
    begin
        if ApprovalEntry."Table ID" <> Database::"Gen. Journal Batch" then
            exit;
        if RecRef.GET(ApprovalEntry."Record ID to Approve") then begin
            RecRef.SETTABLE(GenJournalBatch);
            GenJournalBatch.VALIDATE("Approval Status", GenJournalBatch."Approval Status"::Approved);
            GenJournalBatch.MODIFY();
        end;
    end;

    [EventSubscriber(ObjectType::codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', true, false)]
    local procedure UpdateGenBatchRejectStatus(var ApprovalEntry: Record "Approval Entry")
    var
        GenJournalBatch: Record "Gen. Journal Batch";

        RecRef: RecordRef;
    begin
        if ApprovalEntry."Table ID" <> Database::"Gen. Journal Batch" then
            exit;
        if RecRef.GET(ApprovalEntry."Record ID to Approve") then begin
            RecRef.SETTABLE(GenJournalBatch);
            GenJournalBatch.VALIDATE("Approval Status", GenJournalBatch."Approval Status"::Rejected);
            GenJournalBatch.MODIFY(TRUE);
        end;
    end;

    // [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", 'OnBeforeModifyEvent', '', true, false)]

    // local procedure CheckRecordRestriction(var Rec: Record "Gen. Journal Line")
    // begin
    //     CheckUserisApprover(rec);
    // end;

    // [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", 'OnBeforeDeleteEvent', '', true, false)]

    // local procedure CheckDelRecordRestriction(var Rec: Record "Gen. Journal Line")
    // begin
    //     CheckUserisApprover(rec);
    // end;

    // [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", 'OnBeforeInsertEvent', '', true, false)]

    // local procedure CheckInsRecordRestriction(var Rec: Record "Gen. Journal Line")

    // begin
    //     CheckUserisApprover(rec);
    // end;

    /**
        /*[EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnBeforeUpdateAndDeleteLines', '', true, false)]
        local procedure UpdateBatchStatusAfterJnlPosting(var GenJournalLine: Record "Gen. Journal Line")
        var
            GenJnlBatchL: Record "Gen. Journal Batch";
        begin
            if GenJnlBatchL.get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") then begin
                GenJnlBatchl.VALIDATE("Approval Status", GenJnlBatchl."Approval Status"::open);
                GenJnlBatchl.MODIFY(TRUE);
            end;
        end;*/

    //Suraj
    // procedure CheckUserisApprover(Gnlline: Record "Gen. Journal Line")
    // var
    //     AppEntL: Record "Approval Entry";
    //     GnlBatchL: Record "Gen. Journal Batch";
    // begin
    //     if GnlBatchL.get(Gnlline."Journal Template Name", Gnlline."Journal Batch Name") then begin
    //         if (GnlBatchL."Approval Status" = GnlBatchL."Approval Status"::"Sent for Approval") or
    //         (GnlBatchL."Approval Status" = GnlBatchL."Approval Status"::Approved) then begin
    //             AppEntL.Reset();
    //             AppEntL.SETFILTER("Table ID", '%1|%2', DATABASE::"Gen. Journal Batch", DATABASE::"Gen. Journal Line");
    //             AppEntL.SETFILTER("Record ID to Approve", '%1|%2', GnlBatchL.RECORDID, Gnlline.RECORDID);
    //             AppEntL.SETRANGE("Related to Change", FALSE);
    //             AppEntL.SetRange("Approver ID", UserId);
    //             if not AppEntL.findset then
    //                 error('You dont have permission to modify.')
    //         end;
    //     end;
    // end;


    var
        myInt: Integer;
}