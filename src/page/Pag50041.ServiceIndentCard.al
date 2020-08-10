page 50041 "Service Indent Card"
{
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,History,Print/Send,Navigate';
    SourceTable = "Purchase Indent Header";
    Caption = 'Service Requisition Order';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Replishment Type"; "Replenishment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table field';
                }
                field("No."; "No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table field';
                }
                field(Details; Details)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table field';
                }
                field(Requester; Requester)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table field';
                }
                field("Receiving Location"; "Receiving Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table field';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Requested Date"; "Requested Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table field';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Item Category Code"; "Item Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Field';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table field';
                }
                field("Approval Status"; "Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table field';
                }
                field("Transaction Status"; "Transaction Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Field';
                }
            }


            part(Lines; "Service Indent Subpage")
            {
                Caption = 'Purchase Indent Lines';
                ApplicationArea = all;
                ToolTip = 'Table field';
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;

            }
        }
    }
    actions
    {
        area(processing)
        {
            group("Attachment")
            {
                Caption = 'Attachment';
                Image = Attachments;
                action(DocAttach)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Attachment Document";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal();
                    end;
                }
            }

            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RecordId);
                        //CreateRequisitionLines();//Create Requisition Lines
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Reject the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Delegate the requested changes to the substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group(Action13)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';

                    trigger OnAction()
                    var
                        PurIndentApprovalCUL: Codeunit "Purchase Indent Workflow";
                        Text002: Label 'This document can only be released when the approval process is complete.';
                    begin
                        if (PurIndentApprovalCUL.IsPurchaseIndentDocumentApprovalsWorkflowEnabled(Rec)) and (Rec."Approval Status" = rec."Approval Status"::Open) then
                            ERROR(Text002);
                        Rec."Approval Status" := rec."Approval Status"::Released;
                        Validate("Approval Status");
                        CurrPage.Update(true);
                        //CreateRequisitionLines();//Create Requisition Lines
                        ReqWksheetMakeOrderG.InitCarryOutAction(Rec)
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&open';
                    Enabled = "Approval Status" <> "Approval Status"::Open;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';

                    trigger OnAction()
                    var
                        Text003: Label 'The approval process must be cancelled or completed to reopen this document.';
                    begin
                        if "Approval Status" = "Approval Status"::"Pending Approval" then
                            Error(Text003);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                        PurIndentApprovalCUL: Codeunit "Purchase Indent Workflow";
                    begin
                        if PurIndentApprovalCUL.CheckPurchaseIndentDocumentApprovalsWorkflowEnabled(Rec) then
                            PurIndentApprovalCUL.OnSendPurchaseIndentDocumentForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                        PurIndentApprovalCUL: Codeunit "Purchase Indent Workflow";
                    begin
                        PurIndentApprovalCUL.OnCancelPurchaseIndentDocumentApprovalRequest(Rec);
                        WorkflowWebhookMgt.FindAndCancel(RecordId);
                    end;
                }
                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category9;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
                    begin
                        WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RecordId, DATABASE::"Purchase Indent Header", 6, "No.");
                    end;
                }
            }






            /*
            action("Create Purchse Order")
            {
                ApplicationArea = Suite;
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Create Purchase Order';
                trigger OnAction()
                var
                    IndentHdrL: Record "Purchase Indent Header";
                    IndentLineL: Record "Purchase Indent Line";
                    CreatePurchOrdersReport: Report "Create Purchase Orders";
                begin
                    TestField("Approval Status", "Approval Status"::Released);
                    IndentHdrL.SetRange("No.", "No.");
                    IndentLineL.SetRange("Document No.", "No.");
                    IndentLineL.SetRange("Order/Quote", IndentLineL."Order/Quote"::"Purchase Order");
                    CreatePurchOrdersReport.InitIndnetHeader(IndentHdrL);
                    CreatePurchOrdersReport.InitIndentLine(IndentLineL);
                    CreatePurchOrdersReport.Run();
                end;
            }
            action("Create Purchse Quote")
            {
                ApplicationArea = Suite;
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Create Purchase Quote';
                trigger OnAction()
                var
                    IndentHdrL: Record "Purchase Indent Header";
                    IndentLineL: Record "Purchase Indent Line";
                    CreatePurchOrdersReport: Report "Create Purchase Orders";
                begin
                    TestField("Approval Status", "Approval Status"::Released);
                    IndentHdrL.SetRange("No.", "No.");
                    IndentLineL.SetRange("Document No.", "No.");
                    IndentLineL.SetRange("Order/Quote", IndentLineL."Order/Quote"::"Purchase Quote");
                    CreatePurchOrdersReport.InitIndnetHeader(IndentHdrL);
                    CreatePurchOrdersReport.InitIndentLine(IndentLineL);
                    CreatePurchOrdersReport.Run();
                end;
            }
            */
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Replenishment Type" := "Replenishment Type"::Purchase;
        //"Service Requisition" := true;
        "Requisition Type" := "Requisition Type"::"Service Item";
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance();
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        ReqWksheetMakeOrderG: Codeunit "Req. Wksh.-Make Order-Mofified";

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);

        WorkflowWebhookMgt.GetCanRequestAndCanCancel(RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;
}