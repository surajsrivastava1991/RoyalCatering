codeunit 50051 "Purchase Indent Workflow"
{
    var
        EventHandlingCUG: Codeunit "Workflow Event Handling";
        ApprovalManagementCUG: Codeunit "Approvals Mgmt.";
        WorkflowManagement: Codeunit "Workflow Management";
        ResponseHandlingCUG: Codeunit "Workflow Response Handling";
        PurchaseIndentDocumentSendForApprovalEventDescTxt: Label 'Approval of a purchase indent document is requested.';
        PurchaseIndentDocumentApprovalRequestCancelEventDescTxt: Label 'An approval request for a purchase indent document is canceled.';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        PendingIndentDocumentApprovalExistsErr: Label 'An approval request already exists.', Comment = '%1 is the Document No. of the Indent Line';

        ApprovalReqCanceledForSelectedLinesMsg: Label 'The approval request for the selected record has been canceled.';
    //Workflow Event Handling -BEGIN
    //CreateEventsLibrary
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure OnAddWorkFlowEventToLibrary()
    begin
        EventHandlingCUG.AddEventToLibrary(RunWorkflowOnSendPurchaseIndentDocumentForApprovalCode(), DATABASE::"Purchase Indent Header",
          PurchaseIndentDocumentSendForApprovalEventDescTxt, 0, false);
        EventHandlingCUG.AddEventToLibrary(RunWorkflowOnCancelPurchaseIndentDocumentApprovalRequestCode(), DATABASE::"Purchase Indent Header",
          PurchaseIndentDocumentApprovalRequestCancelEventDescTxt, 0, false);
        /*Line
                EventHandlingCUG.AddEventToLibrary(RunWorkflowOnSendPurchaseIndentLineForApprovalCode, DATABASE::"Purchase Indent Line",
                  PurchaseIndentLineSendForApprovalEventDescTxt, 0, false);
                EventHandlingCUG.AddEventToLibrary(RunWorkflowOnCancelPurchaseIndentLineApprovalRequestCode, DATABASE::"Purchase Indent Line",
                  PurchaseIndentLineApprovalRequestCancelEventDescTxt, 0, false);
                  */
    end;
    //AddEventPredecessors
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelPurchaseIndentDocumentApprovalRequestCode():
                EventHandlingCUG.AddEventPredecessor(RunWorkflowOnCancelPurchaseIndentDocumentApprovalRequestCode(),
                  RunWorkflowOnSendPurchaseIndentDocumentForApprovalCode());
            EventHandlingCUG.RunWorkflowOnApproveApprovalRequestCode():

                EventHandlingCUG.AddEventPredecessor(EventHandlingCUG.RunWorkflowOnApproveApprovalRequestCode(),
                        RunWorkflowOnSendPurchaseIndentDocumentForApprovalCode());

            EventHandlingCUG.RunWorkflowOnRejectApprovalRequestCode():

                EventHandlingCUG.AddEventPredecessor(EventHandlingCUG.RunWorkflowOnRejectApprovalRequestCode(),
                        RunWorkflowOnSendPurchaseIndentDocumentForApprovalCode());

            EventHandlingCUG.RunWorkflowOnDelegateApprovalRequestCode():

                EventHandlingCUG.AddEventPredecessor(EventHandlingCUG.RunWorkflowOnDelegateApprovalRequestCode(),
                        RunWorkflowOnSendPurchaseIndentDocumentForApprovalCode());


        end;
    end;

    procedure RunWorkflowOnSendPurchaseIndentDocumentForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendPurchaseIndentDocumentForApproval'));
    end;

    procedure RunWorkflowOnCancelPurchaseIndentDocumentApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelPurchaseIndentDocumentApprovalRequest'));
    end;


    [EventSubscriber(ObjectType::Codeunit, 50051, 'OnSendPurchaseIndentDocumentForApproval', '', false, false)]
    [Scope('OnPrem')]
    procedure RunWorkflowOnSendPurchaseIndentDocumentForApproval(var PurchaseIndnetP: Record "Purchase Indent Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendPurchaseIndentDocumentForApprovalCode(), PurchaseIndnetP);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50051, 'OnCancelPurchaseIndentDocumentApprovalRequest', '', false, false)]
    [Scope('OnPrem')]
    procedure RunWorkflowOnCancelPurchaseIndentDocumentApprovalRequest(var PurchaseIndnetP: Record "Purchase Indent Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelPurchaseIndentDocumentApprovalRequestCode(), PurchaseIndnetP);
    end;

    //Workflow Event Handling -END

    //Approvals Mgmt -BEGIN
    [IntegrationEvent(false, false)]
    procedure OnSendPurchaseIndentDocumentForApproval(var PurchaseIndnetP: Record "Purchase Indent Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPurchaseIndentDocumentApprovalRequest(var PurchaseIndnetP: Record "Purchase Indent Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendPurchaseIndentLineForApproval(var PurchaseIndnetLineP: Record "Purchase Indent Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPurchaseIndentLineApprovalRequest(var PurchaseIndnetLineP: Record "Purchase Indent Line")
    begin
    end;

    procedure IsPurchaseIndentDocumentApprovalsWorkflowEnabled(var PurchaseIndnetP: Record "Purchase Indent Header"): Boolean
    begin
        exit(WorkflowManagement.CanExecuteWorkflow(PurchaseIndnetP,
            RunWorkflowOnSendPurchaseIndentDocumentForApprovalCode()));
    end;

    procedure CheckPurchaseIndentDocumentApprovalsWorkflowEnabled(var PurchaseIndnetP: Record "Purchase Indent Header"): Boolean
    begin
        if not
           WorkflowManagement.CanExecuteWorkflow(PurchaseIndnetP,
             RunWorkflowOnSendPurchaseIndentDocumentForApprovalCode())
        then
            Error(NoWorkflowEnabledErr);

        exit(true);
    end;


    procedure HasAnyOpenIndentLineApprovalEntries(DocumentNo: Code[20]): Boolean
    var
        PurIndentLineL: Record "Purchase Indent Line";
        ApprovalEntry: Record "Approval Entry";
        IndentLineRecRef: RecordRef;
        IndentLineRecordID: RecordID;
    begin
        ApprovalEntry.SetRange("Table ID", DATABASE::"Purchase Indent Line");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SetRange("Related to Change", false);
        if ApprovalEntry.IsEmpty then
            exit(false);

        PurIndentLineL.SetRange("Document No.", DocumentNo);
        if PurIndentLineL.IsEmpty() then
            exit(false);

        if PurIndentLineL.Count < ApprovalEntry.Count then begin
            PurIndentLineL.FindSet();
            repeat
                if ApprovalManagementCUG.HasOpenApprovalEntries(PurIndentLineL.RecordId) then
                    exit(true);
            until PurIndentLineL.Next() = 0;
        end else begin
            ApprovalEntry.FindSet();
            repeat
                IndentLineRecordID := ApprovalEntry."Record ID to Approve";
                IndentLineRecRef := IndentLineRecordID.GetRecord();
                IndentLineRecRef.SetTable(PurIndentLineL);
                if (PurIndentLineL."Document No." = DocumentNo) then
                    exit(true);
            until ApprovalEntry.Next() = 0;
        end;

        exit(false)
    end;

    procedure TrySendIndentDocumentApprovalRequest(var PurchaseIndentLine: Record "Purchase Indent Line")
    var
        PurchaseIndentDocument: Record "Purchase Indent Header";
    begin
        GetPurchaseIndentDocument(PurchaseIndentDocument, PurchaseIndentLine);
        CheckPurchaseIndentDocumentApprovalsWorkflowEnabled(PurchaseIndentDocument);
        if ApprovalManagementCUG.HasOpenApprovalEntries(PurchaseIndentDocument.RecordId) or
           HasAnyOpenIndentLineApprovalEntries(PurchaseIndentDocument."No.")
        then
            Error(PendingIndentDocumentApprovalExistsErr);
        OnSendPurchaseIndentDocumentForApproval(PurchaseIndentDocument);
    end;

    procedure TryCancelIndentBatchApprovalRequest(var PurchaseIndentLine: Record "Purchase Indent Line")
    var
        PurchaseIndentDocument: Record "Purchase Indent Header";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
    begin
        GetPurchaseIndentDocument(PurchaseIndentDocument, PurchaseIndentLine);
        OnCancelPurchaseIndentDocumentApprovalRequest(PurchaseIndentDocument);
        WorkflowWebhookManagement.FindAndCancel(PurchaseIndentDocument.RecordId);
    end;

    procedure TryCancelIndentLineApprovalRequests(var PurchaseIndentLine: Record "Purchase Indent Line")
    var
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
    begin
        repeat
            if ApprovalManagementCUG.HasOpenApprovalEntries(PurchaseIndentLine.RecordId) then
                OnCancelPurchaseIndentLineApprovalRequest(PurchaseIndentLine);
            WorkflowWebhookManagement.FindAndCancel(PurchaseIndentLine.RecordId);
        until PurchaseIndentLine.Next() = 0;
        Message(ApprovalReqCanceledForSelectedLinesMsg);
    end;

    procedure ShowIndentApprovalEntries(var PurchaseIndentLine: Record "Purchase Indent Line")
    var
        ApprovalEntry: Record "Approval Entry";
        PurchaseIndentDocument: Record "Purchase Indent Header";
    begin
        GetPurchaseIndentDocument(PurchaseIndentDocument, PurchaseIndentLine);

        ApprovalEntry.SetFilter("Table ID", '%1|%2', DATABASE::"Purchase Indent Header", DATABASE::"Purchase Indent Line");
        ApprovalEntry.SetFilter("Record ID to Approve", '%1|%2', PurchaseIndentDocument.RecordId, PurchaseIndentLine.RecordId);
        ApprovalEntry.SetRange("Related to Change", false);
        PAGE.Run(PAGE::"Approval Entries", ApprovalEntry);
    end;

    local procedure GetPurchaseIndentDocument(var PurchaseIndentDocument: Record "Purchase Indent Header"; var PurchaseIndentLine: Record "Purchase Indent Line")
    begin
        if not PurchaseIndentDocument.Get(PurchaseIndentLine."Document No.") then
            PurchaseIndentDocument.Get(PurchaseIndentLine.GetFilter("Document No."));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        IndentHeaderL: Record "Purchase Indent Header";
        IndentLineL: Record "Purchase Indent Line";
    begin
        case RecRef.Number of
            DATABASE::"Purchase Indent Header":
                RecRef.SetTable(IndentHeaderL);
            DATABASE::"Purchase Indent Line":
                begin
                    RecRef.SetTable(IndentLineL);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::" ";
                    ApprovalEntryArgument."Document No." := IndentLineL."Document No.";
                    ApprovalEntryArgument."Document Type 2" := ApprovalEntryArgument."Document Type 2"::Indent;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterIsSufficientApprover', '', true, true)]
    local procedure OnAfterIsSufficientApprover(UserSetup: Record "User Setup"; ApprovalEntryArgument: Record "Approval Entry"; var IsSufficient: Boolean)
    begin
        case ApprovalEntryArgument."Table ID" of
            DATABASE::"Purchase Indent Header":
                IsSufficient := IsSufficientPurchaseIndentLineApprover(UserSetup, ApprovalEntryArgument);
        end;
    end;

    local procedure IsSufficientPurchaseIndentLineApprover(UserSetup: Record "User Setup"; ApprovalEntryArgument: Record "Approval Entry"): Boolean
    begin

        if UserSetup."User ID" = UserSetup."Approver ID" then
            exit(true);
        if UserSetup."Unlimited Indent Approval" = true then
            exit(true);
        exit(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        PurchaseIndentL: Record "Purchase Indent Header";
    begin
        case RecRef.Number of
            DATABASE::"Purchase Indent Header":
                begin
                    RecRef.SetTable(PurchaseIndentL);
                    PurchaseIndentL.Validate("Approval Status", PurchaseIndentL."Approval Status"::"Pending Approval");
                    PurchaseIndentL.Modify(true);
                    Variant := PurchaseIndentL;
                    IsHandled := true;
                end;
        end;
    end;
    //Approvals Mgmt -END
    //Workflow Response Handling -Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    begin
        case ResponseFunctionName of
            ResponseHandlingCUG.SetStatusToPendingApprovalCode():
                ResponseHandlingCUG.AddResponsePredecessor(ResponseHandlingCUG.SetStatusToPendingApprovalCode(), RunWorkflowOnSendPurchaseIndentDocumentForApprovalCode());
            ResponseHandlingCUG.CreateApprovalRequestsCode():
                ResponseHandlingCUG.AddResponsePredecessor(ResponseHandlingCUG.CreateApprovalRequestsCode(), RunWorkflowOnSendPurchaseIndentDocumentForApprovalCode());
            ResponseHandlingCUG.SendApprovalRequestForApprovalCode():
                ResponseHandlingCUG.AddResponsePredecessor(
                  ResponseHandlingCUG.SendApprovalRequestForApprovalCode(), RunWorkflowOnSendPurchaseIndentDocumentForApprovalCode());
            ResponseHandlingCUG.OpenDocumentCode():
                ResponseHandlingCUG.AddResponsePredecessor(ResponseHandlingCUG.OpenDocumentCode(), RunWorkflowOnCancelPurchaseIndentDocumentApprovalRequestCode());
            ResponseHandlingCUG.CancelAllApprovalRequestsCode():
                ResponseHandlingCUG.AddResponsePredecessor(ResponseHandlingCUG.CancelAllApprovalRequestsCode(), RunWorkflowOnCancelPurchaseIndentDocumentApprovalRequestCode());
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        PurchaseIndentL: Record "Purchase Indent Header";
    begin
        RecRef.SetTable(PurchaseIndentL);
        PurchaseIndentL."Approval Status" := PurchaseIndentL."Approval Status"::Released;
        PurchaseIndentL.Modify();
        //if PurchaseIndentL."Replenishment Type" = PurchaseIndentL."Replenishment Type"::Purchase then
        PurchaseIndentL.CreateRequisitionLines();//Create Requisition Lines        
        Handled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        PurchaseIndentL: Record "Purchase Indent Header";
    begin
        RecRef.SetTable(PurchaseIndentL);
        PurchaseIndentL."Approval Status" := PurchaseIndentL."Approval Status"::Open;
        PurchaseIndentL.Modify();
        Handled := true;
    end;
    //Workflow Response Handling -End
    //Page Management -Begin
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnConditionalCardPageIDNotFound', '', true, true)]
    local procedure OnConditionalCardPageIDNotFound(RecordRef: RecordRef; var CardPageID: Integer)
    begin
        case RecordRef.Number of
            DATABASE::"Purchase Indent Header":
                CardPageID := PAGE::"Purchase Indent Card";
        end;
    end;
    //Page Management -End
}