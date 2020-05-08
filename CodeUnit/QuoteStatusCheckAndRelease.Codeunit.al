codeunit 50055 "After Release Purch Quote"
{
    trigger OnRun()
    begin

    end;

    var
        PurchaseQuoteHdrG: Record "Purchase Header";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        IndentLineG: Record "Purchase Indent Line";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnAfterManualReleasePurchaseDoc', '', true, true)]
    local procedure OnAfterManualReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    begin
        with PurchaseHeader do begin
            if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Quote then
                exit;
            PurchaseQuoteHdrG.Reset();
            PurchaseQuoteHdrG.SetRange("Ref. Requisition ID", "Ref. Requisition ID");
            PurchaseQuoteHdrG.SetFilter("No.", '<>%1', "No.");
            if PurchaseQuoteHdrG.FindSet() then
                repeat
                    if PurchaseQuoteHdrG.Status = PurchaseQuoteHdrG.Status::"Pending Approval" then begin
                        ApprovalsMgmt.OnCancelPurchaseApprovalRequest(PurchaseQuoteHdrG);
                    end;
                    PurchaseQuoteHdrG."Quote Cancelled" := true;
                    PurchaseQuoteHdrG.Modify();
                until PurchaseQuoteHdrG.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnAfterInsertPurchOrderLine', '', true, true)]
    local procedure OnAfterInsertPurchOrderLine(var PurchaseQuoteLine: Record "Purchase Line"; var PurchaseOrderLine: Record "Purchase Line")
    begin
        IndentLineG.Reset();
        IndentLineG.SetRange("Ref. Document Type", IndentLineG."Ref. Document Type"::"Purchase Quote");
        IndentLineG.SetRange("Ref. Document No.", PurchaseQuoteLine."No.");
        IndentLineG.SetRange("Ref. Document Line No.", PurchaseQuoteLine."Line No.");
        IndentLineG.CalcFields(Quantity);
        if IndentLineG.FindSet() then
            repeat
                IndentLineG."Ref. Document Type" := IndentLineG."Ref. Document Type"::"Purchase Order";
                IndentLineG."Ref. Document No." := PurchaseOrderLine."Document No.";
                IndentLineG."Ref. Document Line No." := PurchaseOrderLine."Line No.";
                IndentLineG.Modify();
                UpdateRequisitionStatus(PurchaseOrderLine)
            until IndentLineG.next() = 0;
    end;

    procedure UpdateRequisitionStatus(var PurchaseQuoteLineP: Record "Purchase Line")
    var
        ReqWkshModified: Codeunit "Req. Wksh.-Make Order-Mofified";
    begin
        if IndentLineG.Quantity <= PurchaseQuoteLineP.Quantity then begin
            IndentLineG."Transaction Status" := IndentLineG."Transaction Status"::"Approved-Ordered";
            IndentLineG.Modify();
            ReqWkshModified.UpdateHeaderStatus(IndentLineG);
        end
        else begin
            IndentLineG."Transaction Status" := IndentLineG."Transaction Status"::"Approved-Partially Ordered";
            IndentLineG.Modify();
            ReqWkshModified.UpdateHeaderStatus(IndentLineG);
        end;
    end;
}